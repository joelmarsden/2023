using Printf, IterTools

mutable struct Workflow
    var
    operator
    value
    target
    positive
    negative
end

struct Combo
    var
    operator
    value
end

function parseInput(f)
    workflows = Dict()
    workflows["A"] = [Workflow("", "*", 0, "A", nothing, nothing)]
    workflows["R"] = [Workflow("", "*", 0, "R", nothing, nothing)]
    ratings = []
    isWorkflow = true
    for line in readlines(f)
        strip(line) == "" && (isWorkflow = false; continue)
        if isWorkflow
            wf, ins = split(line, '{')
            workflows[wf] = parseWorkflow(ins[1:end-1])
        else
            line = strip(line, '{') ; line = strip(line, '}')
            rat = Dict() 
            for x in split(line, ',')
                r, l = split(x, "=")
                rat[r] = parse(Int, l)
            end
            push!(ratings, rat)
        end
    end
    (workflows, ratings)
end

function parseWorkflow(str)
    wf = []
    for w in split(str, ',')
        if occursin(":", w)
            rule, target = split(w, ':')
            var = "" ; value =0
            if occursin(">", rule)
                var, value = split(rule, '>')
                push!(wf, Workflow(var, ">", parse(Int, value), target, nothing, nothing))
            end
            if occursin("<", rule)
                var, value = split(rule, '<')
                push!(wf, Workflow(var, "<", parse(Int, value), target, nothing, nothing))
            end
        else
            push!(wf, Workflow("", "*", 0, w, nothing, nothing))
        end
    end  
    wf
end

function processWorkflow(workflow, r)
    for ins in workflow
        ins.operator == "*" && (return ins.target)
        rating = r[ins.var]
        val = ins.value
        ins.operator == "<"  && rating < val && (return ins.target)
        ins.operator == ">"  && rating > val && (return ins.target)
    end
    @assert false
end

function part1(f)
    total = 0
    workflows, ratings = parseInput(f)
    for r in ratings
        w = "in"
        while true
            next = processWorkflow(workflows[w], r)
            next == "R" && break
            next == "A" && (total += sum(values(r)); break)
            w = next
        end
    end
    (total, workflows)
end

function buildTree(workflowDict, w) 
    w == "A" || w == "R"  && return
    for (wfcur,wfnext) in partition(workflowDict[w],2,1)
        if isnothing(wfcur.positive)
            wfcur.positive =  workflowDict[wfcur.target][1]
            buildTree(workflowDict, wfcur.target)
        end
        if isnothing(wfcur.negative)
            wfcur.negative =  workflowDict[wfnext.target][1]
            buildTree(workflowDict, wfnext.target)
        end
    end
end

function traverse(wf::Workflow, path, acc)
    wf.target == "R" && return
    if wf.target == "A"
        #p = push!(copy(path),Combo(wf.var, wf.operator, wf.value))
        push!(acc, copy(path))
        return
    end
    push!(path,Combo(wf.var, wf.operator, wf.value))
    !isnothing(wf.positive) && traverse(wf.positive, copy(path), acc)
    !isnothing(wf.negative) && traverse(wf.negative, copy(path), acc)
end

function part2(f)
    # build a decision tree and work back from the leaves
    workflowDict, _ = parseInput(f)
    buildTree(workflowDict, "in")
    path = [] ; acc = []
    traverse(workflowDict["in"][1], path, acc)
    acc
end

@show part1("data/19_input.txt")
#@show part2("data/19_input.txt")