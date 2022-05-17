### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ da22e027-2d62-4865-ac7a-3b34ede564e6
using Pkg

# ╔═╡ e09d7ad0-d3b2-11ec-2e16-a55460c81a7b
using Markdown

# ╔═╡ 3a7bb504-bee2-41bf-bd9d-73c0d455b55d
using InteractiveUtils

# ╔═╡ cd79415e-8b79-40e4-b675-76821014ed5d
using PlutoUI

# ╔═╡ 3385eae4-28d4-48df-95a1-24f28d153922
using DataStructures

# ╔═╡ 46dd7f03-c1a6-4ba8-b28f-7bfe39086513
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ dabf6e77-c88c-42bf-8e59-b7031762c5a7
md"## State definitions "

# ╔═╡ 72bcbfdc-e97a-4c04-b31c-63dbfc3f474f
struct State
name::String
position::Int64
parcel::Vector{Bool}
end

# ╔═╡ f0c19a24-14a9-4706-bf4a-93e245b5ba41
md"## Action Definition "

# ╔═╡ 986a11c5-09f3-4d4a-b80b-3201a2971230
struct Action
name::String
cost::Int64
end

# ╔═╡ c84f8e87-6c7d-4982-8f05-1fc44877cbf7
A1 = Action("Left", 2)

# ╔═╡ cd35acf5-b952-46fc-8110-07fea910f9d5
A2 = Action("Right", 2)

# ╔═╡ 7b249c6e-31b7-4a2b-a4ed-e7c7abc828db
A3 = Action("Move_Up", 1)

# ╔═╡ 045a705a-8117-472f-9e05-4d1499850532
A4 = Action("Move_Down", 1)

# ╔═╡ e6b53d64-a611-4945-9c65-7f7a3d6fcfce
A5 = Action("Collect", 5)

# ╔═╡ 001d6304-48e1-4b16-9ab9-ddb9464fca28
"md States"

# ╔═╡ fbca9fe1-d930-46c4-b54d-21d0591752b1
S1 = State("State one", 1, [true, true, true])

# ╔═╡ 01c5ac00-d47d-47ab-8b47-e7da44e4c147
S2 = State("State two", 2, [true, true, true])

# ╔═╡ 5f46b7f1-8177-4bec-b191-46b39f2fe837
S3 = State("State three", 3, [true, true, true])

# ╔═╡ d005bf2b-f317-486d-b842-14a7c9ef5ba2
S4 = State("State four", 1, [false, true, true])

# ╔═╡ b7867da5-da37-49da-9884-06c160f9822d
S5 = State("State five", 2, [false, true, true])

# ╔═╡ 95b35f04-45fa-41ce-a83d-0f8c22bf468a
S6 = State("State six", 3, [false, true, true])

# ╔═╡ d2ce109e-e2e2-4f91-9c4d-54431e0be210
S7 = State("State seven", 3, [false, false, false])

# ╔═╡ 562a4b16-ea90-4460-80c7-d5a8dfd8a37d
md"## Create transition model"

# ╔═╡ 78a7e766-e56d-4a2f-a109-03260cf445ce
Transition_Mod = Dict()

# ╔═╡ d4d6bb93-0dc4-4b0f-bf9b-753df45cbf49
push!(Transition_Mod, S1 => [(A2, S2), (A1, S1), (A3, S4)])

# ╔═╡ 088a2793-716a-4d66-bff2-98a2816d7b5a
push!(Transition_Mod, S2 => [(A2, S3), (A1, S1)])

# ╔═╡ d1af5ab6-5711-42c4-9486-4a15adabc2c2
push!(Transition_Mod, S3 => [(A2, S3), (A1, S2)])

# ╔═╡ 0bf6976f-a1e3-4211-a027-2d792dbcf9bf
push!(Transition_Mod, S4 => [(A1, S4), (A2, S5)])

# ╔═╡ 55c0dfe4-15cf-4ad3-9296-e4472bb5466f
push!(Transition_Mod, S5 => [(A1, S4), (A2, S6)])

# ╔═╡ e77e54ee-1f04-4457-bbe3-fefa5cbde80d
push!(Transition_Mod, S6 => [(A1, S5), (A2, S6), (A3, S7)])

# ╔═╡ dd20a371-0058-4dfb-ad98-634ec5318efd
push!(Transition_Mod, S7 => [(A1, S5), (A2, S6), (A5, S7)])

# ╔═╡ df0cd65e-1a4d-4cb3-9690-8813a853dd3b
Transition_Mod

# ╔═╡ a04f9ad1-c84a-47a1-98af-48c0798ddb7f
function heuristic(S1, goalState)
    return distance(S1[1] - goalState[1]) + distance(cell[2] - goalState[2])
end

# ╔═╡ 200b9264-8e75-4a81-b9c3-688da0db940e
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

# ╔═╡ 4bbeb8e3-a395-4ad4-aadd-24afa4c75316
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

# ╔═╡ a12c9086-25f0-4bc9-b775-228d2373a3e1
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

# ╔═╡ c49c0999-7cf5-493c-978a-b3d2a079d121
function goal_test(currentState::State)
    return ! (currentState.parcel[1] || currentState.parcel[2])
end

# ╔═╡ df2f5d9a-24f5-4777-8fde-c251c925078b
function add_to_queue(queue::Queue{State}, state::State, cost::Int64)
    enqueue!(queue, state)
    return queue
end

# ╔═╡ 01b73655-0cfc-4421-8e20-d919a4fbcdf2
function add_to_stack(stack::Stack{State}, state::State, cost::Int64)
    push!(stack, state)
    return stack
end

# ╔═╡ 1ea81f66-cd09-4b78-9957-7018022656d4
function remove_from_queue(queue::Queue{State})
    removed = dequeue!(queue)
    return (removed, queue)
end

# ╔═╡ 3ae33b6f-c19f-4c77-a3e0-2717deb65595
function remove_from_stack(stack::Stack{State})
    removed = pop!(stack)
    return (removed, stack)
end

# ╔═╡ 5fcf2e81-ce42-4eeb-973a-777a5728067d
"#md Calling A Star Search"

# ╔═╡ 8ff45816-be9d-4846-ba82-3173ced5adfc
search(S1, Transition_Mod, goal_test, Stack{State}(), add_to_stack,
remove_from_stack)

# ╔═╡ 076d6d2f-1c74-4d27-93c1-dd22c023b6e7


# ╔═╡ c9e84510-b151-4559-8420-36b8ab1081f5


# ╔═╡ d71338b3-31e1-40f6-b620-d72bb94619b4


# ╔═╡ 9166fe56-77d9-4a7d-9939-5e7bdaaa2bfe


# ╔═╡ 18d618c0-00dd-4ae3-a5f9-4c9d68fec587


# ╔═╡ 72e248f1-6192-4bea-8abd-07b935302781


# ╔═╡ 840ab735-b4a8-4046-b5b8-6946a4fb8758


# ╔═╡ 0f8ad1ef-4e11-48a6-89b9-e3386f214a1f


# ╔═╡ ebc38a58-5ee4-4478-b024-87a8dd7e2e55


# ╔═╡ 7568085e-1c00-4447-a1ca-939990478922


# ╔═╡ 0286ee0f-da86-4ff3-9ea3-35b6da945677


# ╔═╡ c2afd294-6faa-4d93-8188-14b14d59f7bc


# ╔═╡ c23b6333-b0bc-4dd3-afac-f160ef7a8074


# ╔═╡ fcb42e7d-e82a-4334-8189-ee6afcf077d1


# ╔═╡ 2727d07a-abb4-44f4-88aa-7d2d950e5384


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DataStructures = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
InteractiveUtils = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
DataStructures = "~0.18.12"
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
git-tree-sha1 = "63d1e802de0c4882c00aee5cb16f9dd4d6d7c59c"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.1"

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
git-tree-sha1 = "cc1a8e22627f33c789ab60b36a9132ac050bbf75"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.12"

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
# ╠═e09d7ad0-d3b2-11ec-2e16-a55460c81a7b
# ╠═3a7bb504-bee2-41bf-bd9d-73c0d455b55d
# ╠═da22e027-2d62-4865-ac7a-3b34ede564e6
# ╠═cd79415e-8b79-40e4-b675-76821014ed5d
# ╠═3385eae4-28d4-48df-95a1-24f28d153922
# ╠═46dd7f03-c1a6-4ba8-b28f-7bfe39086513
# ╠═dabf6e77-c88c-42bf-8e59-b7031762c5a7
# ╠═72bcbfdc-e97a-4c04-b31c-63dbfc3f474f
# ╠═f0c19a24-14a9-4706-bf4a-93e245b5ba41
# ╠═986a11c5-09f3-4d4a-b80b-3201a2971230
# ╠═c84f8e87-6c7d-4982-8f05-1fc44877cbf7
# ╠═cd35acf5-b952-46fc-8110-07fea910f9d5
# ╠═7b249c6e-31b7-4a2b-a4ed-e7c7abc828db
# ╠═045a705a-8117-472f-9e05-4d1499850532
# ╠═e6b53d64-a611-4945-9c65-7f7a3d6fcfce
# ╠═001d6304-48e1-4b16-9ab9-ddb9464fca28
# ╠═fbca9fe1-d930-46c4-b54d-21d0591752b1
# ╠═01c5ac00-d47d-47ab-8b47-e7da44e4c147
# ╠═5f46b7f1-8177-4bec-b191-46b39f2fe837
# ╠═d005bf2b-f317-486d-b842-14a7c9ef5ba2
# ╠═b7867da5-da37-49da-9884-06c160f9822d
# ╠═95b35f04-45fa-41ce-a83d-0f8c22bf468a
# ╠═d2ce109e-e2e2-4f91-9c4d-54431e0be210
# ╠═562a4b16-ea90-4460-80c7-d5a8dfd8a37d
# ╠═78a7e766-e56d-4a2f-a109-03260cf445ce
# ╠═d4d6bb93-0dc4-4b0f-bf9b-753df45cbf49
# ╠═088a2793-716a-4d66-bff2-98a2816d7b5a
# ╠═d1af5ab6-5711-42c4-9486-4a15adabc2c2
# ╠═0bf6976f-a1e3-4211-a027-2d792dbcf9bf
# ╠═55c0dfe4-15cf-4ad3-9296-e4472bb5466f
# ╠═e77e54ee-1f04-4457-bbe3-fefa5cbde80d
# ╠═dd20a371-0058-4dfb-ad98-634ec5318efd
# ╠═df0cd65e-1a4d-4cb3-9690-8813a853dd3b
# ╠═a04f9ad1-c84a-47a1-98af-48c0798ddb7f
# ╠═200b9264-8e75-4a81-b9c3-688da0db940e
# ╠═4bbeb8e3-a395-4ad4-aadd-24afa4c75316
# ╠═a12c9086-25f0-4bc9-b775-228d2373a3e1
# ╠═c49c0999-7cf5-493c-978a-b3d2a079d121
# ╠═df2f5d9a-24f5-4777-8fde-c251c925078b
# ╠═01b73655-0cfc-4421-8e20-d919a4fbcdf2
# ╠═1ea81f66-cd09-4b78-9957-7018022656d4
# ╠═3ae33b6f-c19f-4c77-a3e0-2717deb65595
# ╠═5fcf2e81-ce42-4eeb-973a-777a5728067d
# ╠═8ff45816-be9d-4846-ba82-3173ced5adfc
# ╠═076d6d2f-1c74-4d27-93c1-dd22c023b6e7
# ╠═c9e84510-b151-4559-8420-36b8ab1081f5
# ╠═d71338b3-31e1-40f6-b620-d72bb94619b4
# ╠═9166fe56-77d9-4a7d-9939-5e7bdaaa2bfe
# ╠═18d618c0-00dd-4ae3-a5f9-4c9d68fec587
# ╠═72e248f1-6192-4bea-8abd-07b935302781
# ╠═840ab735-b4a8-4046-b5b8-6946a4fb8758
# ╠═0f8ad1ef-4e11-48a6-89b9-e3386f214a1f
# ╠═ebc38a58-5ee4-4478-b024-87a8dd7e2e55
# ╠═7568085e-1c00-4447-a1ca-939990478922
# ╠═0286ee0f-da86-4ff3-9ea3-35b6da945677
# ╠═c2afd294-6faa-4d93-8188-14b14d59f7bc
# ╠═c23b6333-b0bc-4dd3-afac-f160ef7a8074
# ╠═fcb42e7d-e82a-4334-8189-ee6afcf077d1
# ╠═2727d07a-abb4-44f4-88aa-7d2d950e5384
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
