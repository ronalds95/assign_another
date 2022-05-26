### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 18179b21-2698-4b3b-8fac-afa94e7ec3d4
using Markdown

# ╔═╡ 18986a7e-64cc-4b4b-9674-78a36064e1d6
using InteractiveUtils

# ╔═╡ e042c57e-d63b-45f3-809f-e875c083bc45
using DataStructures

# ╔═╡ 5a10bfee-27f5-472f-a711-1cde2c34524a
using PlutoUI

# ╔═╡ bb73a4b4-8f44-4e65-98c2-bff5ec34e7f0
mutable struct State
 name::String
 position::Int64
 parcel::Vector{Bool}
end

# ╔═╡ 7ad937d3-2d5d-4a49-b4f0-9a8285c80c4d
@enum Actions me mw mu md co

# ╔═╡ c03a8564-0142-46fd-97db-38c7cad5e54f
struct Action
 name::String
 cost::Int64
end

# ╔═╡ 86d21837-7aac-4a4b-848f-7a50902ef4db
Action3 = Action("move up", 1)

# ╔═╡ 01156fce-ab06-418c-98ee-eeea56aa6895
Action4 = Action("move down", 1)

# ╔═╡ 8ab287ff-02f5-4e48-b2ec-067ab60df509
Action1 = Action("move east", 2)

# ╔═╡ c41e1f9d-9152-4e49-b399-a3518b272e20
Action2 = Action("move west", 2)

# ╔═╡ b652f3c6-1917-44e0-81d7-660049b6372a
Action5 = Action("collect", 5)

# ╔═╡ 08f25ba7-0932-4aaf-8531-f22fbd438659
State1 = State("State 1", 1, [true, false, true])

# ╔═╡ d79b64d2-0ebe-419f-b335-e652f90176f2
State2 = State("State 2", 2, [true, true, false])

# ╔═╡ fb0fc01c-4701-44e7-9b2a-4415f49ba7e6
State3 = State("State 3", 3, [false, true, true])

# ╔═╡ 94c8c32f-ab9b-4357-8f77-0fad7be3c13d
State4 = State("State 4", 4, [false, true, true])

# ╔═╡ f4ff0ba3-2747-4413-80cd-3d71cf1e0c96
State5 = State("State 5", 5, [true, false, true])

# ╔═╡ 91a0b65c-7954-4a04-a12b-8c9ae2a7760b
State6 = State("State 6", 1, [false, true, true])

# ╔═╡ 27d20346-20bd-44af-80c6-9a01ac8e4b42
State7 = State("State 7", 2, [false, false, true])

# ╔═╡ 6584e0be-2bb1-449f-a823-e75b5b85bd0b
State8 = State("State 8", 3, [false, false,true])

# ╔═╡ 14ef6b44-917d-4bc7-b385-712e12415237
State9 = State("State 9", 4, [false, false, true])

# ╔═╡ ab9845eb-a61d-4b2a-a7c2-8dfc0e3ff8c6
State10 = State("State 10", 5, [false, false, true])

# ╔═╡ 950cace7-4051-4dc1-9a22-cf7619f9c0db
TransitionModel = Dict()

# ╔═╡ e4b78b2c-a0b1-44de-9ef7-9fce9a925d62
push!(TransitionModel, State1 => [(Action2, State2), (Action5, State6), (Action3, State1)])

# ╔═╡ c4be3a33-2017-4923-be9e-05226e5277e2
push!(TransitionModel, State1 => [(Action2, State3), (Action5, State7), (Action1, State2)])

# ╔═╡ 543dd83d-c2db-4697-b686-fc36ffc4f6d3
push!(TransitionModel, State1 => [(Action4, State4), (Action5, State8), (Action1, State3)])

# ╔═╡ 2a58a7ad-4ddb-4e0b-ae52-ef7e787e499a
push!(TransitionModel, State1 => [(Action2, State5), (Action5, State9), (Action3, State4)])

# ╔═╡ fab6499d-e38e-4615-8c0b-af7134c8a8a5
push!(TransitionModel, State9 => [(Action2, State5), (Action5, State10), (Action4, State10)])

# ╔═╡ 872f2aab-7815-455c-b9e4-5be4b403e4c7
TransitionModel

# ╔═╡ 3fcba19d-3923-4ac0-b1c6-21ff23bbd858
function heuristic(currentState, goalState)
 h = distance(currentState[1] - goalState[1]) + distance(cell[2] - goalState[2])
    return h
end

# ╔═╡ 0276ed2b-abb8-47f3-b907-5c509bb7769e
function astarS(TransitionModel,initialState, goalState)
	
    result = []
 frontier = Queue{State}()
 explored = []
 parents = Dict{State, State}()
 first_state = true
    enqueue!(frontier, initialState)
 parent = initialState
	
    while true
  if isempty(frontier)
   return []
  else
   currentState = dequeue!(frontier)
   push!(explored, currentState)
   candidates = TransitionModel[currentState]
   for single_candidate in candidates
    if !(single_candidate[2] in explored)
     push!(parents, single_candidate[2] => currentState)
     if (single_candiadte[2] in goal_state)
      return get_result(TransitionModel, parents,initialState, single_candidate[2])
     else
      enqueue!(frontier, single_candidate[2])
     end
    end
   end
  end
 end
end

# ╔═╡ 3a547a63-2f3b-4dd4-9d4a-65c6d6e7c89a
function result(TransitionModel, ancestors, initialState, goalState)
 result = []
 explorer = goalState
 while !(explorer == initialState)
  current_state_ancestor = ancestors[explorer]
  related_transitions = TransitionModel[current_state_ancestor]
  for single_trans in related_transitions
   if single_trans[2] == explorer
    push!(result, single_trans[1])
    break
   else
    continue
   end
  end
  explorer = current_state_ancestor
 end
 return result
end

# ╔═╡ ddcaa01d-5322-47fc-9482-ceee6cc49cfd
function findSearch(initialState, transition_dict, is_goal,all_candidates,
add_candidate, remove_candidate)
 explored = []
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
   push!(explored, current_state)
   candidates = transition_dict[current_state]
   for single_candidate in candidates
    if !(single_candidate[2] in explored)
     push!(ancestors, single_candidate[2] => current_state)
     if (is_goal(single_candidate[2]))
      return result(transition_dict, ancestors,
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

# ╔═╡ 4115a34f-5e1c-404a-bdf2-ee6dfff42cd5
function goalT(currentState::State)
    return ! (currentState.parcel[1] || currentState.parcel[2])
end

# ╔═╡ 59f6bf66-3f4b-4285-9ec1-c13751b23f7c
function addQueue(queue::Queue{State}, state::State, cost::Int64)
    enqueue!(queue, state)
    return queue
end

# ╔═╡ b295158e-af9e-4332-b7ed-a9acc540b186
function addStack(stack::Stack{State}, state::State, cost::Int64)
    push!(stack, state)
    return stack
end

# ╔═╡ 094302dc-019b-4d63-bd56-2d5a0b58030e
function removeQueue(queue::Queue{State})
    removed = dequeue!(queue)
    return (removed, queue)
end

# ╔═╡ 2666f51c-9c09-4ebe-9cd1-506e376e587a
function removeStack(stack::Stack{State})
    removed = pop!(stack)
    return (removed, stack)
end

# ╔═╡ b0f1fa4f-9ff6-4206-8d8e-eab6a4473fc2
findSearch(State1, TransitionModel, goalT, Queue{State}(), addQueue, 
removeQueue)

# ╔═╡ 096771fb-e32d-4df5-8054-4d91b4707f69
function astar(rowStoreys,colOffices)
 rowStoreys, colOffices = 0
 companybuilding = [(i,j) 
  for i = 0:rowStoreys  
   for j = 0:colOffices]
 return companybuilding
end

# ╔═╡ 2c201c37-8364-4328-ada7-14c35c7ff02b
function astar(2,3)

# ╔═╡ c874d26c-fd1f-421b-84f6-547348f2165a
begin
 row = 5
 col = 4
 companybuilding = [(i,j) 
  for i = 0:row  
   for j = 0:col]
end

# ╔═╡ 4ecf4fbf-e5a6-438e-8b48-8c19011f6a7d
with_terminal() do
 println()
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DataStructures = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
InteractiveUtils = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
DataStructures = "~0.18.13"
PlutoUI = "~0.7.39"
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
git-tree-sha1 = "0f4e115f6f34bbe43c19751c90a38b2f380637b9"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.3"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "924cdca592bc16f14d2f7006754a621735280b74"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.1.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

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
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

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
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

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

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

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
# ╠═18179b21-2698-4b3b-8fac-afa94e7ec3d4
# ╠═18986a7e-64cc-4b4b-9674-78a36064e1d6
# ╠═e042c57e-d63b-45f3-809f-e875c083bc45
# ╠═5a10bfee-27f5-472f-a711-1cde2c34524a
# ╠═bb73a4b4-8f44-4e65-98c2-bff5ec34e7f0
# ╠═7ad937d3-2d5d-4a49-b4f0-9a8285c80c4d
# ╠═c03a8564-0142-46fd-97db-38c7cad5e54f
# ╠═86d21837-7aac-4a4b-848f-7a50902ef4db
# ╠═01156fce-ab06-418c-98ee-eeea56aa6895
# ╠═8ab287ff-02f5-4e48-b2ec-067ab60df509
# ╠═c41e1f9d-9152-4e49-b399-a3518b272e20
# ╠═b652f3c6-1917-44e0-81d7-660049b6372a
# ╠═08f25ba7-0932-4aaf-8531-f22fbd438659
# ╠═d79b64d2-0ebe-419f-b335-e652f90176f2
# ╠═fb0fc01c-4701-44e7-9b2a-4415f49ba7e6
# ╠═94c8c32f-ab9b-4357-8f77-0fad7be3c13d
# ╠═f4ff0ba3-2747-4413-80cd-3d71cf1e0c96
# ╠═91a0b65c-7954-4a04-a12b-8c9ae2a7760b
# ╠═27d20346-20bd-44af-80c6-9a01ac8e4b42
# ╠═6584e0be-2bb1-449f-a823-e75b5b85bd0b
# ╠═14ef6b44-917d-4bc7-b385-712e12415237
# ╠═ab9845eb-a61d-4b2a-a7c2-8dfc0e3ff8c6
# ╠═950cace7-4051-4dc1-9a22-cf7619f9c0db
# ╠═e4b78b2c-a0b1-44de-9ef7-9fce9a925d62
# ╠═c4be3a33-2017-4923-be9e-05226e5277e2
# ╠═543dd83d-c2db-4697-b686-fc36ffc4f6d3
# ╠═2a58a7ad-4ddb-4e0b-ae52-ef7e787e499a
# ╠═fab6499d-e38e-4615-8c0b-af7134c8a8a5
# ╠═872f2aab-7815-455c-b9e4-5be4b403e4c7
# ╠═3fcba19d-3923-4ac0-b1c6-21ff23bbd858
# ╠═0276ed2b-abb8-47f3-b907-5c509bb7769e
# ╠═3a547a63-2f3b-4dd4-9d4a-65c6d6e7c89a
# ╠═ddcaa01d-5322-47fc-9482-ceee6cc49cfd
# ╠═4115a34f-5e1c-404a-bdf2-ee6dfff42cd5
# ╠═59f6bf66-3f4b-4285-9ec1-c13751b23f7c
# ╠═b295158e-af9e-4332-b7ed-a9acc540b186
# ╠═094302dc-019b-4d63-bd56-2d5a0b58030e
# ╠═2666f51c-9c09-4ebe-9cd1-506e376e587a
# ╠═b0f1fa4f-9ff6-4206-8d8e-eab6a4473fc2
# ╠═096771fb-e32d-4df5-8054-4d91b4707f69
# ╠═2c201c37-8364-4328-ada7-14c35c7ff02b
# ╠═c874d26c-fd1f-421b-84f6-547348f2165a
# ╠═4ecf4fbf-e5a6-438e-8b48-8c19011f6a7d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
