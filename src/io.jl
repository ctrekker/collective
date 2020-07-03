#=
io:
- Julia version: 1.3.0
- Author: ctrek
- Date: 2020-07-01
=#

function readArray(stream)
    dimensions = read(stream, Int16)
    if dimensions === 0
        return []
    end
    sizes = []
    for i ∈ 1:dimensions
        push!(sizes, read(stream, Int64))
    end

    buff = zeros(Float64, sizes...)

    for i ∈ 1:reduce(*, sizes)
        buff[i] = read(stream, Float64)
    end

    return buff
end
function readArraySize(stream)
    seekstart(stream)
    dimensions = read(stream, Int16)
    sizes = []
    for i ∈ 1:dimensions
        push!(sizes, read(stream, Int64))
    end

    return sizes
end
function concatArray(stream, array)
    seekstart(stream)
    dimensions = read(stream, Int16)
    lastSizeIndex = sizeof(Int16) + sizeof(Int64) * (dimensions - 1)
    seek(stream, lastSizeIndex)
    lastSize = read(stream, Int64)
    seek(stream, lastSizeIndex)
    write(stream, Int64(lastSize + size(array)[end]))

    seekend(stream)
    for i ∈ 1:length(array)
        write(stream, Float64(array[i]))
    end
end
function writeArray(stream, array)
    write(stream, Int16(length(size(array))))
    for size ∈ size(array)
        write(stream, Int64(size))
    end

    for e ∈ array
        write(stream, Float64(e))
    end
end
