a = Node(1, "a")
k = key(a)
a1 = Node(1, "a")

@test a == a1


b = AttributeNode(1, "a", @compat Dict())
b1 = AttributeNode(1, "a")

@test b == b1


d = TimeNode(2, 'd', "t1")
key(d)
time(d)
index(d)

