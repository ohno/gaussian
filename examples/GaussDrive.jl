module GaussDrive

    function write(path, text)
        mkpath(dirname(path))
        file = open(path, "w")
        Base.write(file, text)
        close(file)
    end

    function read(path)
        try
            file = open(path, "r")
            text = Base.read(file, String)
            close(file)
            return text
        catch
            return ""
        end
    end

    function run(path)
        script = dirname(@__FILE__) * "/g16.sh"
        Base.run(`sh.exe $script $path`)
    end

    function formchk(path)
        script = dirname(@__FILE__) * "/formchk.sh"
        Base.run(`sh.exe $script $path`)
    end

    function info(path)
        text = GaussDrive.read(path)
        m = match(r"[\-]+[\r\n\s]*#\s(?<method>[A-Za-z0-9\-=,\(\)]+)\/(?<basis>[A-Za-z0-9\-=,\(\)]+)\s", text)
        if !isnothing(m)
            # println(m.match)
            return (method=m[:method], basis=m[:basis])
        else
            return (method=NaN, basis=NaN)
        end
    end

    function method(path)
        res = info(path)
        return res.method
    end

    function basis(path)
        res = info(path)
        return res.basis
    end

    function get(path, regex)
        result = []
        text = GaussDrive.read(path)
        for m in eachmatch(regex, text)
            target = m[:target] # (?<target>...)
            target = replace(target, "D" => "E")
            push!(result, parse.(Float64, target))
            println(parse.(Float64, target))
        end
        if result == []
            return NaN
        else
            return result[end]
        end
    end

    # https://zenn.dev/ohno/articles/b66d3ca5c90263
    # https://qiita.com/BlueSilverCat/items/f35f9b03169d0f70818b
    function energy(path; method=GaussDrive.method(path), regex="")
        if regex == ""
            if method ∈ ["CID" "CISD" "CCS" "CCD" "CCSD" "UCID" "UCISD" "UCCS" "UCCD" "UCCSD"]
                return GaussDrive.get(path, r"Wavefunction amplitudes converged. E\(Corr\)=\s*(?<target>[+-]?\d+(?:\.\d+)?).*\r")
            elseif method ∈ ["CCSD(T)" "CCSD-T" "UCCSD(T)" "UCCSD-T"]
                return GaussDrive.get(path, r"\sCCSD\(T\)=\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+).*\r")
            elseif method ∈ ["CIS" "UCIS" "CIS(D)" "UCIS(D)"]
                return GaussDrive.get(path, r"Total Energy, E\(CIS/TDA\)\s*=\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+).*\r")
            elseif method ∈ ["MP2" "MP3" "UMP2" "UMP3"]
                return GaussDrive.get(path, r".*EUMP\d\s*=\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+).*\r")
            elseif method ∈ ["MP4" "UMP4"]
                return GaussDrive.get(path, r".*UMP4\(SDTQ\)=\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+).*\r")
            elseif method ∈ ["HF" "RHF" "ROHF" "B3LYP" "BLYP" "CAM-B3LYP" "B3PW91" "MPW1PW91" "HSEH1PBE" "WB97XD" "APFD" "UHF" "UB3LYP" "UBLYP" "UCAM-B3LYP" "UB3PW91" "UMPW1PW91" "UHSEH1PBE" "UWB97XD" "APFD"]
                res = GaussDrive.get(path, r" Total Energy, E\(TD-HF/TD-DFT\)\s*=\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+).*\r")
                if isnan(res)
                    return GaussDrive.get(path, r" SCF Done:  E\(.*\) =\s*(?<target>[+-]?\d+(?:\.\d+)?)\s*.*\r")
                else
                    return res
                end
            elseif occursin("CASSCF", "$method")
                return GaussDrive.get(path, r"ITN=.*MaxIt=.*E=\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+)\s*DE=.*\r")
            else
                println("unknown method, $method")
                return NaN
            end
        else
            return GaussDrive.get(path, regex)
        end
    end
    
    function findminimal(arr)
        res = []
        for i in 2:length(arr[begin+1:end-1])
            if !isnan(arr[i-1]) && !isnan(arr[i]) && !isnan(arr[i+1])
                if arr[i-1] > arr[i] < arr[i+1]
                    push!(res, i)
                end
            end
        end
        return res
    end

    function table(dir; sort=true, by=0)
        # get
        E = Dict()
        R = Dict()
        for file in readdir(dir)
            path = "$(dir)/$(file)"
            if occursin(".out", path)
                method = GaussDrive.method(path)
                basis  = GaussDrive.basis(path)
                energy = GaussDrive.energy(path)
                distance = GaussDrive.get(path, r".*R\(1,2\)\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+)\s*.*\r")
                E[file, method, basis] = energy
                R[file, method, basis] = distance
            end
        end
        # sort
        if sort
            if by ==0
                E = Base.sort(E, by=k->E[k], rev=true)
            else
                E = Base.sort(E, by=k->k[by], rev=true)
            end
        end
        # export
        s  = "| file | method | basis | E | R |\n"
        s *= "| :--- | :--- | :--- | :--- | :--- |\n"
        for k in keys(E)
            file = k[1]
            method = k[2]
            basis  = k[3]
            energy = E[k]
            distance = R[k]
            s *= "| $file | $method | $basis | $energy | $distance |\n"    
        end        
        return s
    end

end