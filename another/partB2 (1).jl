### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 0e335174-c37c-4404-a07d-7e9604797903
using Pkg

# ╔═╡ 0c1fac62-1847-4d9f-9d44-c984af50b5a5
using PlutoUI

# ╔═╡ 70de51ca-8cb2-443e-a32d-31ab58922462
using DataStructures

# ╔═╡ c43317a7-4daa-404f-96c8-1704b19f5712
using Printf

# ╔═╡ 5d73bb0c-b038-4e7a-809e-4db23f3621af
abstract type AbstractCSP
end

# ╔═╡ 90154e7e-d538-4bbd-90b0-d241dc1dad87
@enum domains a b c d e

# ╔═╡ b5bc4e0c-058a-49b4-8d15-cbcf16da6232
mutable struct CSPVar
	name::String
	value::Union{Nothing,domains}
	forbidden_values::Vector{domains}
	domain_count::Int64
	variables::Vector
    domains::Dict{String, Vector}
    constraints::Dict{String, Vector{}}
end

# ╔═╡ 1eb136a5-287c-4656-8155-a9a42414aaa4
struct csp
	vars::Vector{CSPVar}
	constraints::Vector{Tuple{CSPVar,CSPVar}}
end

# ╔═╡ 87f24c7c-f75a-46f8-ba46-94c1606a0aa2
struct Constraint{V}
    variables::Vector{String}
    point1::String
    point2::String  
	value::V
end

# ╔═╡ 5ae9e29f-dc20-4b4b-a71d-42b19648c3b6
mutable struct CSPDict
    dict::Union{Nothing, Dict, Constraint}
end

# ╔═╡ 79f4e3c4-ecc8-4d32-ac14-ddd550450fe0
mutable struct CSP <: AbstractCSP
	vars::AbstractVector
	domains::CSPDict
	neighbors::CSPDict
	constraints::Function
	initial::Tuple
	current_domains::Union{Nothing, Dict}
	nassigns::Int64
end

# ╔═╡ 79fd2896-a227-4cd7-a0c6-3c32a2ab8a26
struct graph{T <: Real,U}
    edges::Dict{Tuple{U,U},T}
    verts::Set{U}
end

# ╔═╡ b3e255ec-18d7-4d31-84f0-5b136ac13ca7
function ConstaintProblem(vars::AbstractVector, domains::CSPDict, neighbors::CSPDict, constraints::Function;
                initial::Tuple=(), current_domains::Union{Nothing, Dict}=nothing, nassigns::Int64=0)
        return new(vars, domains, neighbors, constraints, initial, current_domains, nassigns)
    end

# ╔═╡ b9c65d12-68d0-4413-a2e1-a2d1cb8794f1
function MyArc(edges::Vector{Tuple{U,U,T}}) where {T <: Real,U}
    vnames = Set{U}(v for edge in edges for v in edge[1:2])
    adjmat = Dict((edge[1], edge[2]) => edge[3] for edge in edges)
    return graph(adjmat, vnames)
end

# ╔═╡ 01d88b29-58d8-454e-8016-ead0ef8c16b8
begin
	vertices(h::graph) = h.verts
	edges(h::graph)    = h.edges
end

# ╔═╡ f6ade561-89cc-487d-8bad-3b4337409d1a
difference = rand(setdiff(Set([a,b,c,d,e]), Set([a,b])))

# ╔═╡ 39979737-b952-407b-8428-a8c274ae85f3
neighbours(h::graph, v) = Set((b, c) for ((a, b), c) in edges(h) if a == v)

# ╔═╡ 06b335d0-6cf6-40a9-939c-c26894049af6
function Find_The_Path(h::graph{T,U}, source::U, dest::U) where {T, U}
    @assert source ∈ vertices(h) "$source is not a vertex in the graph"
 
    if source == dest return [source], 0 end
    
    inf  = typemax(T)
    dist = Dict(v => inf for v in vertices(h))
    prev = Dict(v => v   for v in vertices(h))
    dist[source] = 0
    Q = copy(vertices(h))
    neigh = Dict(v => neighbours(h, v) for v in vertices(h))
 
    
    while !isempty(Q)
        u = reduce((x, y) -> dist[x] < dist[y] ? x : y, Q)
        pop!(Q, u)
        if dist[u] == inf || u == dest break end
        for (v, cost) in neigh[u]
            alt = dist[u] + cost
            if alt < dist[v]
                dist[v] = alt
                prev[v] = u
            end
        end
    end
 
  
    rst, cost = U[], dist[dest]
    if prev[dest] == dest
        return rst, cost
    else
        while dest != source
            pushfirst!(rst, dest)
            dest = prev[dest]
        end
        pushfirst!(rst, dest)
        return rst, cost
    end
end

# ╔═╡ 18f03f96-6c9b-487c-b0d5-39c83a17e486
function Goaltest(problem::T, state::Tuple) where {T <: AbstractCSP}
    let
        local assignment = Dict(state);
        return (length(assignment) == length(problem.vars) &&
                all((function(key)
                            return error(problem, key, assignment[key], assignment) == 0;
                        end)
                        ,
                        problem.vars));
    end
end

# ╔═╡ 818a09af-34dd-44c1-89c2-a26cf972c236
function CostOfPath(problem::T, cost::Float64, state1::Tuple, action::Tuple, state2::Tuple) where {T <: AbstractCSP}
    return cost + 1;
end

# ╔═╡ fb84a750-265a-43aa-9bd9-ec0b86931b14
function PrunningFunction(problem::T, key, value, removals) where {T <: AbstractCSP}
    local not_removed::Bool = true;
    for (i, element) in enumerate(problem.current_domains[key])
        if (element == value)
            deleteat!(problem.current_domains[key], i);
            not_removed = false;
            break;
        end
    end
    if (not_removed)
        error("Could not find ", value, " in ", problem.current_domains[key], " for key '", key, "' to be removed!");
    end
    if (!(typeof(removals) <: Nothing))
        push!(removals, Pair(key, value));
    end
    nothing;
end

# ╔═╡ 14033676-ac50-4f17-9680-197a4a9a71bf
function ForwardChecking(problem::T, var, value, assignment::Dict, removals::Union{Nothing, AbstractVector}) where {T <: AbstractCSP}
    for B in problem.neighbors[var]
        if (!haskey(assignment, B))
            for b in copy(problem.current_domains[B])
                if (!problem.constraints(var, value, B, b))
                    prunning(problem, B, b, removals);
                end
            end
            if (length(problem.current_domains[B]) == 0)
                return false;
            end
        end
    end
    return true;
end

# ╔═╡ 38472f77-636d-4057-bcc1-2b38e43ec771
function Backtracking(csp:: CSPVar,  assignment=Dict(), path=Dict())::Union{Dict,Nothing}
    
     if length(assignment) == length(csp.variables)
        return assignment
     end

    unassigned::Vector{String} = []
    for v in csp.variables
        if (!haskey(assignment, v))
            push!(unassigned, v)
        end
    end

    
    first = unassigned[1]
    
    for value in csp.domains[first]
        local_assignment = deepcopy(assignment)
        local_assignment[first] = value
      
        if check_consistent(csp, first, local_assignment)
        
            for un in unassigned
                ass = deepcopy(local_assignment)
                for (i, val) in enumerate(csp.domains[un])
                    ass[un] = val
                    if un != first
                        if(!check_consistent(csp, un, ass))
                            deleteat!(csp.domains[un], i)
                        end
                    end
                end
            end
            path[first] = csp.domains
            
            result = backtracking_search(csp, local_assignment)
           
            if result !== nothing
                print_sol(path)
                return result
            end
        end
    end
    return nothing
end

# ╔═╡ 14364f97-7cd2-457c-924b-34f203654e79
variables = ["a2", "a3", "a4", "a5", "a6"]

# ╔═╡ 3afc2f67-d464-4c8a-98ae-53f308699183
testgraph = [("a", "c", 1), ("c", "b", 2), ("c", "e", 3),("d", "e", 4),("e", "a", 5),("e", "b", 6),("e", "d", 7)]

# ╔═╡ d41b3b4e-2a92-4b89-a2f8-ba0bdb45cf89
h = MyArc(testgraph)

# ╔═╡ 359b7d1e-0b23-4192-b8e3-3d7d8a6a3d66
src ,dst = "c", "d"

# ╔═╡ dec2e595-cf07-4a41-90f1-3ceffcb4b0cc
path, cost = Find_The_Path(h, src, dst)

# ╔═╡ 86e729df-86ed-40c0-9fee-d7585b4bb4e2
with_terminal() do
	@printf("\n%3s | %2s | %s\n", "src", "dst", "path")
  
	for src in vertices(h), dst in vertices(h)
    path, cost = Find_The_Path(h, src, dst)
    @printf("%3s | %2s | %s\n", src, dst, isempty(path) ? "no possible path" : join(path, " → ") * " ($cost)")
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DataStructures = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[compat]
DataStructures = "~0.18.11"
PlutoUI = "~0.7.38"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═0e335174-c37c-4404-a07d-7e9604797903
# ╠═0c1fac62-1847-4d9f-9d44-c984af50b5a5
# ╠═70de51ca-8cb2-443e-a32d-31ab58922462
# ╠═c43317a7-4daa-404f-96c8-1704b19f5712
# ╠═5d73bb0c-b038-4e7a-809e-4db23f3621af
# ╠═5ae9e29f-dc20-4b4b-a71d-42b19648c3b6
# ╠═1eb136a5-287c-4656-8155-a9a42414aaa4
# ╠═79f4e3c4-ecc8-4d32-ac14-ddd550450fe0
# ╠═90154e7e-d538-4bbd-90b0-d241dc1dad87
# ╠═b5bc4e0c-058a-49b4-8d15-cbcf16da6232
# ╠═87f24c7c-f75a-46f8-ba46-94c1606a0aa2
# ╠═79fd2896-a227-4cd7-a0c6-3c32a2ab8a26
# ╠═b3e255ec-18d7-4d31-84f0-5b136ac13ca7
# ╠═b9c65d12-68d0-4413-a2e1-a2d1cb8794f1
# ╠═01d88b29-58d8-454e-8016-ead0ef8c16b8
# ╠═f6ade561-89cc-487d-8bad-3b4337409d1a
# ╠═39979737-b952-407b-8428-a8c274ae85f3
# ╠═06b335d0-6cf6-40a9-939c-c26894049af6
# ╠═18f03f96-6c9b-487c-b0d5-39c83a17e486
# ╠═818a09af-34dd-44c1-89c2-a26cf972c236
# ╠═fb84a750-265a-43aa-9bd9-ec0b86931b14
# ╠═14033676-ac50-4f17-9680-197a4a9a71bf
# ╠═38472f77-636d-4057-bcc1-2b38e43ec771
# ╠═14364f97-7cd2-457c-924b-34f203654e79
# ╠═3afc2f67-d464-4c8a-98ae-53f308699183
# ╠═d41b3b4e-2a92-4b89-a2f8-ba0bdb45cf89
# ╠═359b7d1e-0b23-4192-b8e3-3d7d8a6a3d66
# ╠═dec2e595-cf07-4a41-90f1-3ceffcb4b0cc
# ╠═86e729df-86ed-40c0-9fee-d7585b4bb4e2
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
