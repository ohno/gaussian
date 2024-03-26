module GaussDrive

    using Base

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
        m = match(r"\#.*\s(?<method>[A-Za-z0-9\-=,\(\)]+)\/(?<basis>[A-Za-z0-9\-\+=,\(\)]+)\s", text)
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

    function get(path, regex; type=Float64)
        result = []
        text = GaussDrive.read(path)
        for m in eachmatch(regex, text)
            target = m[:target] # (?<target>...)
            target = replace(target, "D" => "E")
            push!(result, parse.(type, target))
        end
        if result == []
            return NaN
        else
            return result[end]
        end
    end

    function count(path, regex)
        n = 0
        text = GaussDrive.read(path)
        for m in eachmatch(regex, text)
            n += 1
        end
        return n
    end
    
    # https://zenn.dev/ohno/articles/b66d3ca5c90263
    # https://qiita.com/BlueSilverCat/items/f35f9b03169d0f70818b
    function energy(path; method=GaussDrive.method(path), regex="")
        if regex == ""
            if method ∈ ["CID" "CISD" "QCISD" "QCISD(T)" "CCS" "CCD" "CCSD" "UCID" "UCISD" "UCCS" "UCCD" "UCCSD"]
                return GaussDrive.get(path, r"Wavefunction amplitudes converged. E\(Corr\)=\s*(?<target>[+-]?\d+(?:\.\d+)?).*\r")
            elseif method ∈ ["CCSD(T)" "CCSD(T,E4T)" "CCSD-T" "UCCSD(T)" "UCCSD-T"]
                return GaussDrive.get(path, r"\sCCSD\(T\)=\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+).*\r")
            elseif method ∈ ["QCISD(T)" "QCISD(T,E4T)"]
                return GaussDrive.get(path, r"\sQCISD\(T\)=\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+).*\r")
            elseif method ∈ ["CIS" "UCIS" "CIS(D)" "UCIS(D)"]
                return GaussDrive.get(path, r"Total Energy, E\(CIS/TDA\)\s*=\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+).*\r")
            elseif method ∈ ["MP2" "MP3" "UMP2" "UMP3"]
                return GaussDrive.get(path, r".*EUMP\d\s*=\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+).*\r")
            elseif method ∈ ["MP4" "UMP4"]
                return GaussDrive.get(path, r".*UMP4\(SDTQ\)=\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+).*\r")
            elseif method ∈ ["HF" "RHF" "ROHF" "LSDA" "SVWN" "SVWN5" "BLYP" "B3LYP" "CAM-B3LYP" "B3PW91" "MPW1PW91" "HSEH1PBE" "WB97XD" "APFD" "PBE1PBE" "wB97XD" "UHF" "ULSDA" "USVWN" "USVWN5" "UBLYP" "UB3LYP" "UCAM-B3LYP" "UB3PW91" "UMPW1PW91" "UHSEH1PBE" "UWB97XD" "UAPFD" "UPBE1PBE" "UwB97XD"]
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

    function table(dir; sorting=true)
        # get
        results = []
        for file in readdir(dir)
            path = "$(dir)/$(file)"
            if occursin(".out", path)
                method = GaussDrive.method(path)
                basis  = GaussDrive.basis(path)
                energy = GaussDrive.energy(path)
                distance = GaussDrive.get(path, r".*R\(1,2\)\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+)\s*.*\r")
                angle = GaussDrive.get(path, r".*A\(2,1,3\)\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+)\s*.*\r")
                push!(results, (file, (method=method, basis=basis, energy=energy, distance=angle, angle=angle)))
            end
        end

        # sort
        if sorting
            results = sort(results, by=x->x[2].energy, rev=true)
        end

        # export
        s  = "| file | method | basis | E | R | A |\n"
        s *= "| :--- | :--- | :--- | :--- | :--- | :--- |\n"
        for k in keys(results)
            file = results[k][1]
            method = results[k][2].method
            basis  = results[k][2].basis
            energy = results[k][2].energy
            distance = results[k][2].distance
            angle = results[k][2].angle
            s *= "| $file | $method | $basis | $energy | $distance | $angle |\n"
        end        
        return s
    end
    
end