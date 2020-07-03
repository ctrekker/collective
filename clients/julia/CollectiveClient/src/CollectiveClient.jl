module CollectiveClient

export executeCommand

function readArray(stream)
    dimensions = read(stream, UInt16)
    if dimensions === 0
        return []
    end
    sizes = []
    for i ∈ 1:dimensions
        push!(sizes, read(stream, UInt64))
    end

    buff = zeros(Float64, sizes...)

    for i ∈ 1:reduce(*, sizes)
        buff[i] = read(stream, Float64)
    end

    return buff
end

function writeArray(stream, array)
    write(stream, UInt16(length(size(array))))
    for size ∈ size(array)
        write(stream, UInt64(size))
    end

    for e ∈ array
        write(stream, Float64(e))
    end
end

function sendCommand(conn, cmd)
    write(conn, cmd)
    write(conn, "\n")
end
sendBody(conn, arr) = writeArray(conn, arr)
function executeCommand(conn, cmd, body=nothing)
    sendCommand(conn, cmd)
    if !isnothing(body)
        sendBody(conn, body)
    else
        sendBody(conn, [])
    end
    msg = readline(conn)
    body = readArray(conn)
    return msg, body
end

set_buf(conn, buf_id::Int, arr::Array) = executeCommand(conn, "set_buf $buf_id", arr)
get_buf(conn, buf_id::Int) = executeCommand(conn, "get_buf $buf_id")
save(conn, buf_id::Int, name::String) = executeCommand(conn, "save $buf_id $name")
load(conn, name::String, buf_id::Int) = executeCommand(conn, "load $name $buf_id")
del(conn, name::String) = executeCommand(conn, "del $name")
cat(conn, buf_id::Int, name::String) = executeCommand(conn, "cat $buf_id $name")

end
