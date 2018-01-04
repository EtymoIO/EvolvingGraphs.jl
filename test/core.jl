# test core functionalities

# test nodes
a = Node(1, "a")
@test  node_key(a) == "a"
@test node_index(a) == 1
@test eltype(a) <: AbstractString
println(a)

a1 = Node(1, "a")
@test a == a1

b = AttributeNode(1, "a",  Dict())
b1 = AttributeNode(1, "a")
attributes(b) =  Dict("a" => 2)
@test node_index(b) == 1
@test node_key(b) == "a"
@test attributes(b) ==  Dict("a" => 2)
@test eltype(b) <: AbstractString
@test b == b1
println(b)

d = TimeNode(a,  "t1")
@test node_key(d) == "a"
@test timestamp(d) == "t1"
@test node_index(d) == 1
@test eltype(d)[1] <: Node
@test eltype(d)[2] <: AbstractString
println(d)

# test edges
e1 = Edge('a', 'b')
@test source(e1) == 'a'
@test target(e1) == 'b'
e3 = Edge('b', 'a')
@test rev(e3) == e1
println(e1)

e2 = TimeEdge('a', 'b', 3)
@test source(e2) == 'a'
@test target(e2) == 'b'
@test timestamp(e2) == 3
println(e2)
@test has_node(e2, 'a')

e = WeightedTimeEdge(1, 2, 2.3, 2)
@test source(e) == 1
@test target(e) == 2
@test timestamp(e) == 2
@test weight(e) == 2.3
println(e)
