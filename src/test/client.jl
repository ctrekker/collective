#=
client:
- Julia version: 1.3.0
- Author: ctrek
- Date: 2020-07-01
=#

using Sockets
conn = connect(31512)

include("../io.jl")
include("../../clients/julia/CollectiveClient/src/CollectiveClient.jl")
using .CollectiveClient

println(executeCommand(conn, "set_buf 1", randn((5, 5))))
# println(executeCommand(conn, "save 1 test"  ))
# println(executeCommand(conn, "cat 1 test"))
# println(executeCommand(conn, "load test 2"))
# println(executeCommand(conn, "get_buf 2"))

# println(executeCommand(conn, "del test"))
