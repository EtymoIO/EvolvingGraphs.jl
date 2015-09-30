# test nodes 
a = Node(1, "a")
@test  key(a) == "a"
@test index(a) == 1
@test eltype(a) <: AbstractString

a1 = Node(1, "a")
@test a == a1

b = AttributeNode(1, "a", @compat Dict())
b1 = AttributeNode(1, "a")
attributes(b) = @compat Dict("a" => 2)
@test index(b) == 1
@test key(b) == "a"
@test attributes(b) == @compat Dict("a" => 2)
@test eltype(b) <: AbstractString
@test b == b1

d = TimeNode(2, 'd', "t1")
@test key(d) == 'd'
@test timestamp(d) == "t1"
@test index(d) == 2
@test eltype(d)[1] <: Char
@test eltype(d)[2] <: AbstractString

# test edges
e1 = Edge('a', 'b')
@test source(e1) == 'a'
@test target(e1) == 'b'
e3 = Edge('b', 'a')
@test rev(e3) == e1

e2 = TimeEdge('a', 'b', 3)
@test source(e2) == 'a'
@test target(e2) == 'b'
@test timestamp(e2) == 3
