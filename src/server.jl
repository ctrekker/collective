#=
server:
- Julia version: 1.3.0
- Author: ctrek
- Date: 2020-07-01
=#

using Sockets

include("io.jl")

struct CollectiveNode
    ip::String
    port::UInt16
    weight::Float64
end

buffers = Vector{Any}(nothing, 10)
nodes = CollectiveNode[]
function writeResponse(sock, msg, body=[])
    write(sock, msg)
    write(sock, "\n")
    if !isnothing(body)
        writeArray(sock, body)
    else
        writeArray(sock, [])
    end
end
writeSuccess(sock) = writeResponse(sock, "true")

function handleClient(sock)
    command = split(lowercase(readline(sock)), " ")
    pCommand = command[1]
    body = readArray(sock)

    if pCommand == "set_buf"
        buffId = parse(Int, command[2])
        buffers[buffId] = body
        writeSuccess(sock)
    elseif pCommand == "get_buf"
        bufId = parse(Int, command[2])
        writeResponse(sock, "true", buffers[bufId])
    elseif pCommand == "save"
        bufId = parse(Int, command[2])
        if !isdir("data")
            mkdir("data")
        end
        f = open("data/$(command[3]).dat", "w")
        writeArray(f, buffers[bufId])
        close(f)
        writeSuccess(sock)
    elseif pCommand == "load"
        bufId = parse(Int, command[3])
        f = open("data/$(command[2]).dat", "r")
        buffers[bufId] = readArray(f)
        writeSuccess(sock)
        close(f)
    elseif pCommand == "del"
        rm("data/$(command[2]).dat")
        writeSuccess(sock)
    elseif pCommand == "cat"
        bufId = parse(Int, command[2])
        f = open("data/$(command[3]).dat", "r+")
        arraySize = readArraySize(f)
        if reduce(+, arraySize[1:end-1] .== size(buffers[bufId])[1:end-1]) / (length(arraySize) - 1) == 1
            concatArray(f, buffers[bufId])
            writeSuccess(sock)
        else
            writeResponse(sock, "false")
        end
        close(f)
    elseif pCommand == "ping"
        writeResponse(sock, "pong")
    elseif pCommand == "exit"
        writeSuccess(sock)
        close(sock)
    else

    end
end

server = listen(31512)
while true
    sock = accept(server)
    @async begin
        try
            while true
                handleClient(sock)
            end
        catch err
#             println("connection ended with error $err")
#             throw(err)
            println(err)
        end
    end
end
