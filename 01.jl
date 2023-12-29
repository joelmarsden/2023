function calibration(line)
    s = filter(isdigit, line)
    x = length(s) > 0 ? parse(Int, s[1]) : 0
    10x + (length(s) > 1 ? parse(Int, s[end]) : x)
end

part1(f) = sum(calibration(line) for line in readlines(open(f)))

firstrange(r) = isnothing(r) ? typemax(Int) : r[1]

function realCalibration(line)
    line = lowercase(line)
    map = [ "one" => "1", "two" => "2", "three" => "3", "four" => "4", 
            "five" => "5", "six" => "6", "seven" => "7", "eight" => "8", "nine" => "9", 
            "1" => "1", "2" => "2", "3" => "3", "4" => "4", 
            "5" => "5", "6" => "6", "7" => "7", "8" => "8", "9" => "9"]
    res = ""
    while true       
        indexes = [firstrange(findfirst(k, line)) for (k, _) in map]
        # first
        minIdx = findmin(indexes)
        minIdx[1] == typemax(Int) && break
        res *= map[minIdx[2]][2]
        # next
        deleteat!(indexes, minIdx[2])
        minIdx = findmin(indexes)
        minIdx[1] == typemax(Int) && break
        line = line[minIdx[1]:end]
    end
    res
end

part2(f) = sum(calibration(realCalibration(line)) for line in readlines(open(f)))

@show part1("data/01_input.txt")
@show part2("data/01_input.txt")