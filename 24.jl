using Printf, JuMP, GLPK, HiGHS, SCIP
#using Printf, Z3

strToInt(line) = [parse(Int,i) for i in split(line, ",") if strip(i) != ""]

function parseInput(f)
    input = []
    for line in readlines(f)
        position, velocity = split(line, "@")
        push!(input, (strToInt(position), strToInt(velocity)))
    end
    input
end

function eq2d(p, v)
    m = v[2]/v[1]
    c = p[2]-p[1]*m
    (m, -1, c)
end

insideTestArea2d(xi, yi, tmin, tmax) = (xi >= tmin && xi <= tmax && yi >= tmin && yi <= tmax)

function isInFuture2d(p, v, xi, yi)
    dx1 = abs(xi-p[1])
    dy1 = abs(yi-p[2])
    dx2 = abs(xi-(p[1]+v[1]))
    dy2 = abs(yi-(p[2]+v[2]))
    dx2 <= dx1 && dy2 <= dy1
end

function part1(f, tmin, tmax)
    total = 0
    points = parseInput(f)
    for (i, (p1,v1)) in enumerate(points)
        (a1,b1,c1) = eq2d(p1,v1)
        for j in i+1:length(points)
            (p2, v2) = points[j]
            (a2,b2,c2) = eq2d(p2, v2)
            xi = (b1*c2-b2*c1)/(a1*b2-a2*b1)
            yi = (c1*a2-c2*a1)/(a1*b2-a2*b1)
            if insideTestArea2d(xi, yi, tmin, tmax) && isInFuture2d(p1, v1, xi, yi) && isInFuture2d(p2, v2, xi, yi)
                total += 1
            end
        end
    end
    total
end

function part2(f)
    
    input = parseInput(f)
    N = length(input)
    model = Model()
    set_optimizer(model, SCIP.Optimizer)
    #set_attribute(model, "display/verblevel", 0)
    #set_attribute(model, "limits/gap", 0.05)
    #set_attribute(model, "numerics/epsilon",0.001)

    @variable(model, x, Int)
    @variable(model, y, Int)
    @variable(model, z, Int)
    @variable(model, vx, Int)
    @variable(model, vy, Int)
    @variable(model, vz, Int)
    # @variable(model, x)
    # @variable(model, y)
    # @variable(model, z)
    # @variable(model, vx)
    # @variable(model, vy)
    # @variable(model, vz)
    @variable(model, Ti[1:N] >= 0, Int)

    for (i, (p, v)) in enumerate(input)
        #@constraint(model, x + Ti[i]*vx == p[1] + Ti[i]*v[1])
        #@constraint(model, y + Ti[i]*vy == p[2] + Ti[i]*v[2])
        #@constraint(model, z + Ti[i]*vz == p[3] + Ti[i]*v[3])
        
        @constraint(model, x + Ti[i]*vx - p[1] - Ti[i]*v[1] == 0)
        @constraint(model, y + Ti[i]*vy - p[2] - Ti[i]*v[2] == 0)
        @constraint(model, z + Ti[i]*vz - p[3] - Ti[i]*v[3] == 0)

        #@constraint(model, x + Ti[i]*(-3) - p[1] - Ti[i]*v[1] == 0)
        #@constraint(model, y + Ti[i]*(1) - p[2] - Ti[i]*v[2] == 0)
        #@constraint(model, z + Ti[i]*(2) - p[3] - Ti[i]*v[3] == 0)
        i>2 && break
    end

    #@objective(model, Min, sum(Ti[i] for i in 1:N))

    optimize!(model)
    (Int(value.(x)),Int(value.(y)),Int(value.(z)))
end


@time @show part1("data/24_input_ex.txt", 7, 27)
@time @show part1("data/24_input.txt", 200000000000000, 400000000000000)
@time @show part2("data/24_input_ex.txt")

