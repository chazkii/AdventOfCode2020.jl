testinput = """939
7,13,x,x,59,x,31,19"""

input = """1000655
17,x,x,x,x,x,x,x,x,x,x,37,x,x,x,x,x,571,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,13,x,x,x,x,23,x,x,x,x,x,29,x,401,x,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,19"""

function earliestbus(input::String)
    parts = split(input, "\n")
    ts = parse(Int, parts[:1])
    ids = [parse(Int, id) for id in split(parts[:2], ",") if id != "x"]
    times = Dict{Int, Int}()
    for id in ids
        t1 = ts - (ts % id)
        while t1 < ts
            t1 += id
        end
        times[id] = t1
    end
    invtimes = Dict(v => k for (k, v) in times)
    (te, ide) = minimum(invtimes)
    return (te - ts) * ide
end

input = "7,13,x,x,59,x,31,19"
input = "17,x,13,19"

function earliestts(input::String)::Int
    pairs = Set([(i - 1, parse(Int, id)) for (i, id) in enumerate(split(input, ",")) if id != "x"])
    t = 0
    step = 1
    while length(pairs) > 0
        t += step
        rm = Set()
        for (offset, id) in pairs
            if (t + offset) % id == 0
                push!(rm, (offset, id))
                step *= id
            end
        end
        pairs = setdiff(pairs, rm)
    end
    return t
end

using Test

@test earliestts("7,13,x,x,59,x,31,19") == 1068781
@test earliestts("17,x,13,19") == 3417
@test earliestts("67,7,59,61") == 754018
@test earliestts("67,x,7,59,61") == 779210
@test earliestts("67,7,x,59,61") == 1261476
@test earliestts("1789,37,47,1889") == 1202161486
earliestts("17,x,x,x,x,x,x,x,x,x,x,37,x,x,x,x,x,571,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,13,x,x,x,x,23,x,x,x,x,x,29,x,401,x,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,19")