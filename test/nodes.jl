a = Node("a")
k = key(a)
a1 = Node("a")

@test a == a1


b = IndexNode(2, "b")
index(b)
key(b)

c = IndexNode(2, "b")

@test b == c

d = TimeNode(2, 'd', "t1")
key(d)
time(d)
index(d)

