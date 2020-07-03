#=
client:
- Julia version: 1.3.0
- Author: ctrek
- Date: 2020-07-01
=#

module CollectiveClient
include("io.jl")
export sendCommand, sendBody, executeCommand
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
end
