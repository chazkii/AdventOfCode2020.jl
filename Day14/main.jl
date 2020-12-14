filename = "./Day14/test-input.txt"

testinput = """mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0"""

line = "mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"
line = "mem[8] = 11"
mem = Dict{Int, Int}()
filename = "./Day14/input.txt"
for line in readlines(filename)
    if startswith(line, "mask")  # new instruction
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
sum(values(mem))

# PART 2
for line in readlines(filename)
    if startswith(line, "mask")  # new instruction
        mask = match(r"mask = ([X10]+)", line)[:1]
        bitmask = Dict{Int, Int}()
        float_idx = []
        xstr = @pipe convert(String, mask) |> replace(_, '1' => '0') |> replace(_, 'X' => '1')
        X = parse(Int, xstr, base=2)
        for (i, c) in enumerate(reverse(mask))
            if in(c, ('0', '1'))
                bitmask[i - 1] = parse(Int, c)
            else
                push!(float_idx, i)
            end
        end
    elseif startswith(line, "mem")
        m = match(r"mem\[(\d+)\] = (\d+)", line)
        raw_addr, val = (parse(Int, m[:1]), parse(Int, m[:2]))
        addrs = []
        # take addr and apply mask
        aon = 
        push!(addrs, aon)
        push!(addrs, aoff)
        for (offset, bit) in bitmask
            if bit == 1
                raw_addr |= bit << offset
            end
        end
        for addr in addrs
            mem[addr] = val
        end
    end
end

@test productaddr("000000X1101X") == Set(["000000011010", "000000011011", "000000111010", "000000111011"])
function produceaddr(addr::String)::Set{String}
    produceaddr(addr, 1)
    return addrs
end

function produceaddr(addr::String, i::int)::Set{String}
    if length(addr) == i
        return addr
    end
    if c == 'X'
        addr[i] = ''
end
addr = "000000000000000000000000000000X1001X"
function produceaddr(addr::String)
    fo = Int[]
    for (i, c) in enumerate(addr)
        offset = length(addr) - i
        if c == 'X'
            insert!(fo, 1, 1 << offset)
        end
    end
    root = parse(Int, replace(addr, 'X' => '0'), base=2)
    addrs = []
    for f in fo
        return [root + f, root]
    end
    return addrs
end

# need to exploit that they are binary to make my life so much easier
function sums(arr)
    insert!(arr, 0, 0)
    0 + a for a in arr[2:end]
    collect(vcat([0], )
end
# 0, 5, 4, 3
# [0, 5], [0, 4], [0, 3]
in_ = [5, 4, 3]
out_ = [0, 3, 4, 5, 7, 8, 8, 9, 12]
subsetsums(arr, 1, length(arr) - 1)

function produceaddr(addr::String, sum::String)
    xi = findfirst('X', addr)
    if isnothing(xi)
        return string(sum, addr)
    end
    head = string(sum, addr[1:xi-1])
    tail = addr[xi+1:end]
    return vcat(produceaddr(tail, string(head, '0')), produceaddr(tail, string(head, '1')))
end

addr = "00000000000000000000000000000001X0XX"

line = "mem[8] = 11"
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
# 4155706053115 too low
# 10542299922150 too high

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
addrv = 26
mask = "00000000000000000000000000000000X0XX"
maskaddr("00000000000000000000000000000000X0XX", 26)