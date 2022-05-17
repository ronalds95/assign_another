### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 87f3abbe-c25a-11ec-15bd-1f981f9133af
using Pkg

# ╔═╡ fd1e543c-5221-43f8-b73e-b7b07e966124
using Markdown

# ╔═╡ dac5c3ae-1748-49df-b7c1-0218a70e692f
using PlutoUI

# ╔═╡ 95cba2b2-2214-41f5-b210-45af8e4df213
using InteractiveUtils

# ╔═╡ 03113e04-04e5-4ffb-b0f3-9b423bdb60fe
using DataStructures

# ╔═╡ 826a7b13-4855-4be8-89be-e4227077eb83
# State definitions

# ╔═╡ 83df0c73-ab75-4531-afa0-e52d7b803ef6
struct State
name::String
position::Int64
parcel::Vector{Bool}
end

# ╔═╡ caaa09ff-b814-434e-81b7-9b63449a9a69
# Action Definition

# ╔═╡ 26fb91fe-e9f5-437b-9daa-a92eb1779ccc
struct Action
name::String
cost::Int64
end

# ╔═╡ e2580823-e2b4-43d1-b69c-6dbb2183dde3
A1 = Action("Left", 2)

# ╔═╡ dcac604c-05eb-4340-9a68-64a5c881837a
A2 = Action("Right", 2)

# ╔═╡ b27d1573-38f1-43b7-bbb9-1cd969277a80
A3 = Action("Move_Up", 1)

# ╔═╡ ad016653-a55b-4255-8314-4135026ac97c
A4 = Action("Move_Down", 1)

# ╔═╡ b9760f58-085e-4ee0-8af4-515aae93c985
A5 = Action("Collect", 5)

# ╔═╡ fae64717-d29f-40c7-8f69-4e2eefe9a14f
"md States"

# ╔═╡ 136cdabb-ca8f-48a6-afd5-b909f9cb1501
S1 = State("State one", 1, [true, true, true])

# ╔═╡ 7e69f173-135d-4fed-9774-b24e712ffac3
S2 = State("State two", 2, [true, true, true])

# ╔═╡ 19106858-f556-4ae9-b83f-848acdbdedbc
S3 = State("State three", 3, [true, true, true])

# ╔═╡ bb2d4b4a-defe-4d2e-9576-dde120719fa0
S4 = State("State four", 1, [false, true, true])

# ╔═╡ 6c8997ec-5852-4540-90d1-cd55e7cf2f62
S5 = State("State five", 2, [false, true, true])

# ╔═╡ d8ae2103-fce8-4d83-942c-d22eef4fb6c1
S6 = State("State six", 3, [false, true, true])

# ╔═╡ 2f5f3d02-99b2-4eb6-8295-503ca76bd01e
S7 = State("State seven", 1, [true, false, true])

# ╔═╡ a48b911d-8324-4d02-8754-e0f64b328daf
S8 = State("State eight", 2, [true, false, true])

# ╔═╡ 701a57ec-be39-4407-b316-03b0b4b02a49
S9 = State("State nine", 3, [true, false, true])

# ╔═╡ 3590b63a-4d59-465b-900b-475f6f44517c
S10 = State("State ten", 1, [true, true, false])

# ╔═╡ fc9e7bdc-55d8-4ca7-9bda-cb5198ad66fd
S11 = State("State eleven", 2, [true, true, false])

# ╔═╡ 00ee3fdd-fb32-495a-9109-cf537eae6cdd
S12 = State("State twelve", 3, [true, true, false])

# ╔═╡ 696c2d10-a20f-423a-b4dc-5ea7c283033c
S13 = State("State thirteen", 3, [false, false, false])

# ╔═╡ 9b2fd80d-b1c5-48e7-be28-3ba45a77b220
#transition model

# ╔═╡ 1dc2b83c-2c7d-4b32-bf16-392b52c66e35
Transition_Mod = Dict()

# ╔═╡ b481ea6d-2f78-47fe-85fc-1ca28780c657
# Add a mapping/push! to the transition Model

# ╔═╡ c5a78536-1c2f-45d4-8131-33162e08ebbe
push!(Transition_Mod, S1 => [(A5, S4), (A2, S1), (A5, S7), (A5, S10), (A3, S2), (A4, S3)])

# ╔═╡ 21012f61-9750-41ff-a025-795df206d537
push!(Transition_Mod, S2 => [(A5, S5), (A2, S2), (A5, S8), (A2, S2), (A3, S2), (A4, S3)]) #continue here

# ╔═╡ 1108a71b-7d2c-4031-8937-0d407e5d1619
push!(Transition_Mod, S3 => [(A1, S2), (A3, S6), (A4, S11), (A5, S3)])

# ╔═╡ 3a1204b5-329d-4c12-ae79-e2b7447fe719
push!(Transition_Mod, S4 => [(A2, S5), (A4, S9), (A5, S4)])

# ╔═╡ f8f283af-99fc-40e2-bd09-5cf940f36fa2
push!(Transition_Mod, S5 => [(A1, S4), (A2, S6), (A4, S8), (A5, S5)])

# ╔═╡ abe21d12-19fc-421c-927e-15cf34143b54
push!(Transition_Mod, S6 => [(A1, S5), (A2, S6), (A3, S7), (A3, S7)])

# ╔═╡ 9db231c9-a749-49d2-8b9d-d94afe4b91fb
push!(Transition_Mod, S7 => [(A2, S8), (A3, S4), (A5, S7)])

# ╔═╡ dba4028b-ec97-4e78-9d42-0691bc63d98b
push!(Transition_Mod, S8 => [(A1, S7), (A2, S12), (A3, S5), (A5, S8)])

# ╔═╡ a1b74e22-d80b-4e5d-8ab6-3c75bafcff9b
push!(Transition_Mod, S9 => [(A2, S12), (A2, S8), (A3, S4), (A5, S9)])

# ╔═╡ 226b560a-ad2b-4654-8570-e9d33bb033fb
push!(Transition_Mod, S10 => [(A2, S2), (A3, S4), (A4, S7), (A5, S10)])

# ╔═╡ 5d06cc80-1a8b-4904-aed7-b05b76ff328d
push!(Transition_Mod, S11 => [(A1, S7), (A3, S6), (A5, S11)])

# ╔═╡ 5167fe8d-0ec8-402c-bb9b-9b980d2dc818
push!(Transition_Mod, S12 => [(A1, S7), (A2, S6), (A5, S12)])

# ╔═╡ 2ff91068-ddbd-4943-9a5e-5c040386d2b1
Transition_Mod

# ╔═╡ be305fcb-d0ce-4808-b272-7f07ba238c38
#Promptint user to enter data

# ╔═╡ 3ffe4113-84a2-4795-80c9-6c9639a3c650
@bind storey_no TextField()

# ╔═╡ e271a880-ffc5-4c4e-955b-4f41477d55c5
with_terminal() do
	println( storey_no)
end

# ╔═╡ ae2e4468-af41-4255-9635-e35a99b0e3da
@bind no_off_offices TextField()

# ╔═╡ 28014a9e-a114-4dc5-95e1-240b7bbbfa23
with_terminal() do
	println(no_off_offices)
end

# ╔═╡ 0bd5e8ad-80a5-4141-add3-c0d68ed64ee3
@bind parcels TextField()

# ╔═╡ 4a057678-f23d-4c6d-813f-d79a79183e21
with_terminal() do
	println(parcels)
end

# ╔═╡ 665f6535-edb2-44f5-8631-8b44da8edbbd
@bind location TextField()

# ╔═╡ 549ab0f7-7071-4535-8554-3422504fc7cb
with_terminal() do
	println( location)
end

# ╔═╡ 460c77be-7707-488a-8aa2-e954875a835c
# Our Goal State

# ╔═╡ 2e6d029e-b34e-45cd-958f-32a9c3e72665
with_terminal() do
	println(S12)
end

# ╔═╡ 07e709d0-ae83-413f-96d8-5e10500017b7
function heuristic(S1, goalState)
    return distance(S1[1] - goalState[1]) + distance(cell[2] - goalState[2])
end

# ╔═╡ 21a2eb16-1eb7-4f2d-93db-b1e7c9baa821
function A_Star_Search(TransModel,initialState, goalState)
	
    result = []
	frontier = Queue{State}()
	visited = []
	parents = Dict{State, State}()
	first_state = true
    enqueue!(frontier, initialState)
	parent = initialState
	
    while true
		if isempty(frontier)
			return []
		else
			currentState = dequeue!(frontier)
			push!(visited, currentState)
			candidates = TransModel[currentState]
			for single_candidate in candidates
				if !(single_candidate[2] in visited)
					push!(parents, single_candidate[2] => currentState)
					if (single_candiadte[2] in goal_state)
						return get_result(TransModel, parents,initialState, single_candidate[2])
					else
						enqueue!(frontier, single_candidate[2])
					end
				end
			end
		end
	end
end

# ╔═╡ 0fed6f60-0499-475f-9380-f9df806f62f6
function create_result(TransModel, ancestors, initialState, goalState)
	result = []
	visitor = goalState
	while !(visitor == initialState)
		current_state_ancestor = ancestors[visitor]
		related_transitions = TransModel[current_state_ancestor]
		for single_trans in related_transitions
			if single_trans[2] == visitor
				push!(result, single_trans[1])
				break
			else
				continue
			end
		end
		visitor = current_state_ancestor
	end
	return result
end

# ╔═╡ f89d2b1d-3176-4394-9c94-060c0966e4a2
function search(initialState, transition_dict, is_goal,all_candidates,
add_candidate, remove_candidate)
	visited = []
	ancestors = Dict{State, State}()
	the_candidates = add_candidate(all_candidates, initialState, 0)
	parent = initialState
	while true
		if isempty(the_candidates)
			return []
		else
			(t1, t2) = remove_candidate(the_candidates)
			current_state = t1
			the_candidates = t2
#proceed with handling the current state
			push!(visited, current_state)
			candidates = transition_dict[current_state]
			for single_candidate in candidates
				if !(single_candidate[2] in visited)
					push!(ancestors, single_candidate[2] => current_state)
					if (is_goal(single_candidate[2]))
						return create_result(transition_dict, ancestors,
initialState, single_candidate[2])
					else
						the_candidates = add_candidate(the_candidates,
single_candidate[2], single_candidate[1].cost)
						end
					end
				end
			end
		end
end

# ╔═╡ 831cd8bf-32b9-4ebb-a3a4-7ae627715e98
function goal_test(currentState::State)
    return ! (currentState.parcel[1] || currentState.parcel[2])
end

# ╔═╡ d4d62052-a475-46e9-b657-1a5b0b95724a
function add_to_queue(queue::Queue{State}, state::State, cost::Int64)
    enqueue!(queue, state)
    return queue
end

# ╔═╡ f00c2df6-9d0c-4c78-9095-3e41b2193587
function add_to_stack(stack::Stack{State}, state::State, cost::Int64)
    push!(stack, state)
    return stack
end

# ╔═╡ 95dd3903-b7c4-403f-8bd5-34df3ab775ec
function remove_from_queue(queue::Queue{State})
    removed = dequeue!(queue)
    return (removed, queue)
end

# ╔═╡ 4cbf47cd-7e14-4743-aecf-416e5d505416
function remove_from_stack(stack::Stack{State})
    removed = pop!(stack)
    return (removed, stack)
end

# ╔═╡ d0b3f97b-d7bc-4af2-a23f-615010df6ab7
# Calling A Star Search Strategy

# ╔═╡ c60a063e-87fc-4744-ac51-cf5a157957b5
search(S1, Transition_Mod, goal_test, Stack{State}(), add_to_stack,
remove_from_stack)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DataStructures = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
InteractiveUtils = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

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
git-tree-sha1 = "3b429f37de37f1fc603cc1de4a799dc7fbe4c0b6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.0"

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
# ╠═87f3abbe-c25a-11ec-15bd-1f981f9133af
# ╠═fd1e543c-5221-43f8-b73e-b7b07e966124
# ╠═dac5c3ae-1748-49df-b7c1-0218a70e692f
# ╠═95cba2b2-2214-41f5-b210-45af8e4df213
# ╠═03113e04-04e5-4ffb-b0f3-9b423bdb60fe
# ╠═826a7b13-4855-4be8-89be-e4227077eb83
# ╠═83df0c73-ab75-4531-afa0-e52d7b803ef6
# ╠═caaa09ff-b814-434e-81b7-9b63449a9a69
# ╠═26fb91fe-e9f5-437b-9daa-a92eb1779ccc
# ╠═e2580823-e2b4-43d1-b69c-6dbb2183dde3
# ╠═dcac604c-05eb-4340-9a68-64a5c881837a
# ╠═b27d1573-38f1-43b7-bbb9-1cd969277a80
# ╠═ad016653-a55b-4255-8314-4135026ac97c
# ╠═b9760f58-085e-4ee0-8af4-515aae93c985
# ╠═fae64717-d29f-40c7-8f69-4e2eefe9a14f
# ╠═136cdabb-ca8f-48a6-afd5-b909f9cb1501
# ╠═7e69f173-135d-4fed-9774-b24e712ffac3
# ╠═19106858-f556-4ae9-b83f-848acdbdedbc
# ╠═bb2d4b4a-defe-4d2e-9576-dde120719fa0
# ╠═6c8997ec-5852-4540-90d1-cd55e7cf2f62
# ╠═d8ae2103-fce8-4d83-942c-d22eef4fb6c1
# ╠═2f5f3d02-99b2-4eb6-8295-503ca76bd01e
# ╠═a48b911d-8324-4d02-8754-e0f64b328daf
# ╠═701a57ec-be39-4407-b316-03b0b4b02a49
# ╠═3590b63a-4d59-465b-900b-475f6f44517c
# ╠═fc9e7bdc-55d8-4ca7-9bda-cb5198ad66fd
# ╠═00ee3fdd-fb32-495a-9109-cf537eae6cdd
# ╠═696c2d10-a20f-423a-b4dc-5ea7c283033c
# ╠═9b2fd80d-b1c5-48e7-be28-3ba45a77b220
# ╠═1dc2b83c-2c7d-4b32-bf16-392b52c66e35
# ╠═b481ea6d-2f78-47fe-85fc-1ca28780c657
# ╠═c5a78536-1c2f-45d4-8131-33162e08ebbe
# ╠═21012f61-9750-41ff-a025-795df206d537
# ╠═1108a71b-7d2c-4031-8937-0d407e5d1619
# ╠═3a1204b5-329d-4c12-ae79-e2b7447fe719
# ╠═f8f283af-99fc-40e2-bd09-5cf940f36fa2
# ╠═abe21d12-19fc-421c-927e-15cf34143b54
# ╠═9db231c9-a749-49d2-8b9d-d94afe4b91fb
# ╠═dba4028b-ec97-4e78-9d42-0691bc63d98b
# ╠═a1b74e22-d80b-4e5d-8ab6-3c75bafcff9b
# ╠═226b560a-ad2b-4654-8570-e9d33bb033fb
# ╠═5d06cc80-1a8b-4904-aed7-b05b76ff328d
# ╠═5167fe8d-0ec8-402c-bb9b-9b980d2dc818
# ╠═2ff91068-ddbd-4943-9a5e-5c040386d2b1
# ╠═be305fcb-d0ce-4808-b272-7f07ba238c38
# ╠═3ffe4113-84a2-4795-80c9-6c9639a3c650
# ╠═e271a880-ffc5-4c4e-955b-4f41477d55c5
# ╠═ae2e4468-af41-4255-9635-e35a99b0e3da
# ╠═28014a9e-a114-4dc5-95e1-240b7bbbfa23
# ╠═0bd5e8ad-80a5-4141-add3-c0d68ed64ee3
# ╠═4a057678-f23d-4c6d-813f-d79a79183e21
# ╠═665f6535-edb2-44f5-8631-8b44da8edbbd
# ╠═549ab0f7-7071-4535-8554-3422504fc7cb
# ╠═460c77be-7707-488a-8aa2-e954875a835c
# ╠═2e6d029e-b34e-45cd-958f-32a9c3e72665
# ╠═07e709d0-ae83-413f-96d8-5e10500017b7
# ╠═21a2eb16-1eb7-4f2d-93db-b1e7c9baa821
# ╠═0fed6f60-0499-475f-9380-f9df806f62f6
# ╠═f89d2b1d-3176-4394-9c94-060c0966e4a2
# ╠═831cd8bf-32b9-4ebb-a3a4-7ae627715e98
# ╠═d4d62052-a475-46e9-b657-1a5b0b95724a
# ╠═f00c2df6-9d0c-4c78-9095-3e41b2193587
# ╠═95dd3903-b7c4-403f-8bd5-34df3ab775ec
# ╠═4cbf47cd-7e14-4743-aecf-416e5d505416
# ╠═d0b3f97b-d7bc-4af2-a23f-615010df6ab7
# ╠═c60a063e-87fc-4744-ac51-cf5a157957b5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
