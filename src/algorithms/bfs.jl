# _breath_first_visit(g, (v1, t1))
# find all reachable nodes from (v1, t1)
function _breath_first_visit(g::AbstractEvolvingGraph, s::Tuple)
    level =  Dict(s => 0)
    i = 1
    fronter = [s]
    reachable = [s]
    while length(fronter) > 0
        next = Tuple[]
        for u in fronter
            for v in out_neighbors(g, u)
                if !(v in keys(level))
                    level[v] = i
                    push!(reachable, v)
                    push!(next, v)
                end
            end
        end
        fronter = next
        i += 1
    end
    reachable
end
