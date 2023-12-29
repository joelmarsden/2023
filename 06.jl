
wins(races) = prod([sum(1 for x in 1:t if x*(t-x) > d) for (t,d) in races])

@time @show wins([50 => 242, 74 => 1017, 86 => 1691, 85 => 1252])
@time @show wins([50748685 => 242101716911252])