
using Test

function spokennum(start::Vector{Int}, stop::Int)::Int
    nums = copy(start)
    while length(nums) < stop
        lastidx = findlast(x -> x == last(nums), nums[1:end-1])
        if isnothing(lastidx)
            push!(nums, 0)
        else
            push!(nums, length(nums) - lastidx)
        end
    end
    return last(nums)
end

@test spokennum([0, 3, 6], 2020) == 436
@test spokennum([0, 3, 6], 10) == 0
spokennum([0, 3, 1, 6, 7, 5], 2020)

function spokennumv2(start::Vector{Int}, stop::Int)::Int
    nums = copy(start)
    lastidxs = Dict(c => i for (i, c) in enumerate(nums[1:end-1]))
    l = last(nums)
    while length(nums) < stop
        if !haskey(lastidxs, l)
            push!(nums, 0)
        else
            c = length(nums) - lastidxs[l]
            push!(nums, c)
        end
        lastidxs[l] = length(nums) - 1
        l = last(nums)
    end
    return last(nums)
end


@test spokennumv2([0, 3, 6], 9) == 4
@test spokennumv2([0, 3, 6], 10) == 0
spokennumv2([0, 3, 1, 6, 7, 5], 30000000)