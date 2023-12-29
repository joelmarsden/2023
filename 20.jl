using Printf, IterTools

mutable struct Eq
    type
    from
    toEq
    state
    conjInput
end

function parseInput(f)
    modules = Dict{String,Eq}()
    for line in readlines(f)
        strip(line) == "" && continue
        if line[1] == '%' || line[1] == '&'
            type = line[1]
            from = string(strip(line[2:3]))
            to = [string(strip(o)) for o in split(line[8:end],',')]
            modules[from] = Eq(type, from, to, false, Dict())   
        end 
        if line[1] == 'b'
            to = [string(strip(o)) for o in split(line[16:end],',')]
            modules["broadcaster"] = Eq('b', "broadcaster", to, false, Dict())
        end
    end
    initialiseConjunctors(modules)
end

function initialiseConjunctors(modules)
    for m in values(modules)
        for r in m.toEq
            haskey(modules,r) || continue
            conj = modules[r]
            conj.type == '&' && (conj.conjInput[m.from] = false)
        end
    end
    modules
end

function sendPulse(fromeq, eq, isHigh)
    eq.type == '%' && (return sendPulseToInverter(eq, isHigh))
    eq.type == '&' && (return sendPulseToConjunctor(fromeq, eq, isHigh))
    eq.type == '*' && (eq.state = isHigh)
    []
end

function sendPulseToInverter(eq, isHigh)
    isHigh && return [] 
    !isHigh && (eq.state = !eq.state) # toggle on low pulse
    [(eq,t,eq.state) for t in eq.toEq]
end

function sendPulseToConjunctor(fromeq, eq, isHigh)
    # conjunction & (remembers all inputs and on pulse records it - if all high pulses sense low pulse else high)
    eq.conjInput[fromeq.from] = isHigh 
    state = !(sum(values(eq.conjInput)) == length(eq.conjInput))
    [(eq,t,state) for t in eq.toEq]
end

diffs(l) = [(s-f) for (f,s) in partition(l,2,1)]

function part1(f,c)
    modules = parseInput(f)
    bc = modules["broadcaster"]
    totalLP = 0; totalHP = 0
    for cycle in 1:c
        #@printf("cycle %d\n", cycle)
        queue = []
        totalLP += 1 # button press
        for t in bc.toEq
            totalLP += 1
            nPulses = sendPulse(bc, modules[t], false)
            (length(nPulses) > 0) && append!(queue,nPulses)  
            #@printf("\tbroadcaster: -low-> %s\n",t) 
        end
        while length(queue) > 0
            (from, to, pulse) = popfirst!(queue)
            pulse == true ? (totalHP+=1) : (totalLP+=1)
            haskey(modules,to) || (modules[to] = Eq('*', to, [], false, Dict())) #rx
            #@printf("\t%s: -%s-> %s\n",from.from, (pulse ? "high" : "low"), to) 
            next = sendPulse(from, modules[to], pulse)
            append!(queue,next)
        end
    end
    (totalLP*totalHP)
end

function part2(f,c)
    modules = parseInput(f)
    bc = modules["broadcaster"]

    # bq connects to rx (could look this up programmatically)
    bq = modules["bq"]
    rxInputCycles = Dict()
    for (k,_) in bq.conjInput
        rxInputCycles[k] = []
    end

    for cycle in 1:c
        queue = []
        for t in bc.toEq
            nPulses = sendPulse(bc, modules[t], false)
            (length(nPulses) > 0) && append!(queue,nPulses)  
        end
        while length(queue) > 0
            (from, to, pulse) = popfirst!(queue)
            haskey(modules,to) || (modules[to] = Eq('*', to, [], false, Dict())) #rx

            if to == "bq" && pulse
                push!(rxInputCycles[from.from], cycle)
                l = [length(x) for x in values(rxInputCycles)]
                if length(l[l .>2]) == length(l) # found cycles for each input - return the lcm (all firing)
                    diff = [diffs(x) for x in values(rxInputCycles)]
                    return lcm([x[1] for x in diff])
                end
            end

            next = sendPulse(from, modules[to], pulse)
            append!(queue,next)
        end
    end
    -1
end

@time @show part1("data/20_input.txt", 1000)
@time @show part2("data/20_input.txt", 30000)