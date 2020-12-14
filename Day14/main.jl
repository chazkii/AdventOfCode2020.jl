filename = "./Day14/test-input.txt"
filename = "./Day14/input.txt"

function decodev1(filename)
    mem = Dict{Int, Int}()
    clear = nothing
    bitmask = nothing
    for line in readlines(filename)
        if startswith(line, "mask")
            mask = match(r"mask = ([X10]+)", line)[:1]
            bitmask = Dict{Int, Int}()
            clearstr = @pipe convert(String, mask) |> replace(_, '1' => '0') |> replace(_, 'X' => '1')
            clear = parse(Int, clearstr, base=2)
            for (i, c) in enumerate(reverse(mask))
                if in(c, ('0', '1'))
                    bitmask[i - 1] = parse(Int, c)
                end
            end
        elseif startswith(line, "mem")
            m = match(r"mem\[(\d+)\] = (\d+)", line)
            addr, val = (parse(Int, m[:1]), parse(Int, m[:2]))
            val &= clear
            for (offset, bit) in bitmask
                val |= bit << offset
            end
            mem[addr] = val
        end
    end
    return sum(values(mem))
end


decodev1("./Day14/input.txt")


function produceaddr(addr::String)
    return produceaddr(addr, "")
end

function produceaddr(addr::String, sum::String)
    xi = findfirst('X', addr)
    if isnothing(xi)
        return string(sum, addr)
    end
    head = string(sum, addr[1:xi-1])
    tail = addr[xi+1:end]
    return vcat(produceaddr(tail, string(head, '0')), produceaddr(tail, string(head, '1')))
end


function maskaddr(mask::String, addrv::Int)::String
    raw_addr_str = bitstring(addrv)
    addr_str = raw_addr_str[length(raw_addr_str) - length(mask) + 1:end]
    @assert length(addr_str) == length(mask)
    res_array = []
    for (mc, ac) in zip(mask, addr_str)
        if mc == '0'
            push!(res_array, ac)
        else
            push!(res_array, mc)
        end
    end
    return join(res_array)
end


function decodev2(filename)
    mem = Dict{Int, Int}()
    mask_str = ""
    for line in readlines(filename)
        if startswith(line, "mask")  # new instruction
            mask_str = convert(String, match(r"mask = ([X10]+)", line)[:1])
        elseif startswith(line, "mem")
            m = match(r"mem\[(\d+)\] = (\d+)", line)
            addrv, val = (parse(Int, m[:1]), parse(Int, m[:2]))
            res = maskaddr(mask_str, addrv)
            for addr in produceaddr(res)
                mem[parse(Int, addr, base=2)] = val
            end
        end
    end
    return sum(values(mem))
end


decodev2("./Day14/input.txt")