using Primes

function parseMap(f)
    rl = "" ; d = Dict()
    for (n, line) in enumerate(readlines(open(f)))
        (n == 1) && (rl = line; continue)
        line = replace(line, r"\(|\)|\ " => "")
        line == "" && continue
        from, to = split(line, "=" )
        l, r = split(to, ",")
        d[from] = (l,r)
    end
    (rl, d)
end

function part1(f)
    rl, d = parseMap(f)
    from = "AAA"
    pos = 1 ; steps = 0
    while from != "ZZZ"
        (pos > length(rl)) && (pos = 1)
        from = (rl[pos] == 'L' ? d[from][1] : d[from][2])
        steps += 1 ; pos += 1
    end
    steps
end

function part2(f)
    rl, d = parseMap(f)
    pos = 1 ; steps = 0
    paths = [k for (k,_) in d if endswith(k,'A')]
    zIndex = zeros(BigInt, length(paths))
    while prod(zIndex) == 0
        (pos > length(rl)) && (pos = 1)
        paths = [rl[pos] == 'L' ? d[from][1] : d[from][2] for from in paths]
        steps += 1 ; pos += 1
        for (i,p) in enumerate(paths)
            (endswith(p,'Z') && zIndex[i] == 0) && (zIndex[i] = steps)
        end
    end
    prod([k for (k,_) in factor(Dict,prod(zIndex))]) # lcm
end

@time @show part1("data/08_input.txt")
@time @show part2("data/08_input.txt")