## [0.1.0] - 2025-08-16
# 📝 CHANGELOG — lunaris_engine

> A comprehensive, production-grade algorithms library for Dart. This changelog lists all major modules and algorithms, grouped for clarity and discoverability.

---

## 🤖 Machine Learning & AI
**Supervised, unsupervised, and deep learning models:**
- linear_regression, logistic_regression, decision_tree, random_forest, svm, knn, naive_bayes, gradient_boosting, xgboost_like, gradient_boosting_classifier, lightgbm_like, catboost_like
- ann, cnn, rnn, lstm, gru, transformer, gan
- simulated_annealing, genetic_algorithm, particle_swarm, bayesian_optimization, mdp

## 🕸️ Graph Algorithms
**Classic and advanced graph/network algorithms:**
- johnsons_algorithm, dinics_algorithm, stoer_wagner_min_cut, yens_algorithm, hierholzer, tarjans_scc
- weighted_edge, bfs, dfs, topological_sort, connected_components, cycle_detection, bipartite_graph, shortest_path, dijkstra, bellman_ford, floyd_warshall, mst_kruskal, mst_prim, kosaraju_scc, articulation_points, eulerian_path, hamiltonian_path, chinese_postman, transitive_closure, graph_coloring, spfa, bridge_finding, tree_diameter, union_find

## 📦 Dynamic Programming & Combinatorics
**DP, memoization, and combinatorial algorithms:**
- fibonacci_memoization, knapsack_01, longest_increasing_subsequence, longest_common_subsequence, edit_distance, matrix_path_sum, coin_change, subset_sum, partition_equal_subset_sum, house_robber, jump_game, alternating_subsequences, rod_cutting, minimum_path_sum, unique_paths_with_obstacles, decode_ways, interleaving_string, coin_change_bottom_up, paint_house, burst_balloons, longest_bitonic_subsequence, matrix_chain_multiplication, count_palindromic_subsequences, min_cuts_palindrome_partitioning, max_sum_increasing_subsequence, cherry_pickup, wildcard_matching, regex_matching

## 🗜️ Compression
**Classic and modern compression algorithms:**
- huffman, lzw, rle, arithmetic, bwt

## 🔐 Cryptography
**Cryptographic primitives and mining:**
- sha256, ripemd160, keccak256, scrypt, argon2, ecdsa, eddsa, bls_signatures, scrypt_mining

## ⛓️ Consensus & Blockchain
**Distributed consensus and blockchain protocols:**
- proof_of_work, proof_of_stake, delegated_proof_of_stake, proof_of_authority, proof_of_burn, proof_of_capacity, proof_of_elapsed_time, bft, pbft, fba

## 🌐 Routing & Wireless
**Network routing and wireless/P2P protocols:**
- bgp_algorithm, ospf_algorithm, rip_algorithm, link_state_routing, distance_vector_routing
- aodv, dsr, chord, kademlia

## 📋 List Algorithms
**Core list and array algorithms:**
- linear_search, binary_search, merge_sort, bubble_sort, insertion_sort, selection_sort, quick_sort, counting_sort, reverse_list, find_max_min, find_duplicates, kadanes_algorithm, max_sum_subarray_of_size_k, min_sum, average_subarray, two_sum_sorted, remove_duplicates, rotate_array_right, prefix_sum

## 🔢 Set Algorithms
**Set and multiset operations:**
- has_duplicates, disjoint_set, find_intersection, set_difference, is_frequency_unique, has_two_sum, has_unique_window, symmetric_difference, power_set, subset_check, superset_check, disjoint_check, list_to_set_preserve_order, multiset_operations

## 🗺️ Map Algorithms
**Map/dictionary algorithms:**
- frequency_count, group_by_key, first_non_repeated_element, anagram_checker, two_sum, lru_cache, most_frequent_element, top_k_frequent, length_of_longest_substring, invert_map, merge_maps_conflict, group_anagrams, word_frequency_ranking, all_pairs_with_sum, index_mapping, mru_cache, count_pairs_with_diff, find_subarrays_with_sum, min_window_substring

## 📝 String Algorithms
**String and text processing:**
- reverse_string, palindrome_checker, anagram_checker, longest_palindromic_substring, string_compression, brute_force_search, kmp_search, rabin_karp_search, longest_common_prefix, edit_distance, count_vowels_consonants, manacher_longest_palindrome, boyer_moore_search, z_algorithm, rolling_hash, longest_repeating_substring, remove_consecutive_duplicates, min_window_subsequence, atoi, integer_roman, string_permutations

## 🌳 Tree Algorithms
**Tree and binary tree algorithms:**
- binary_tree_node, tree_traversals, level_order_traversal, tree_depth, invert_tree, lowest_common_ancestor, validate_bst, tree_diameter, balanced_tree_check, tree_serialization, zigzag_traversal, morris_traversal, threaded_binary_tree_traversal, count_leaf_nodes, count_full_nodes, count_half_nodes, print_all_root_to_leaf_paths, path_sum_in_tree, vertical_order_traversal, boundary_traversal, bottom_top_view_binary_tree, construct_tree_inorder_preorder, construct_tree_inorder_postorder, convert_sorted_array_to_bst, flatten_binary_tree_to_linked_list, lowest_common_ancestor_no_bst

## 🔗 Linked List Algorithms
**Linked list operations:**
- linked_list_node, doubly_linked_list_node, insert_delete_at_position, reverse_linked_list, detect_cycle, merge_sorted_lists, remove_nth_from_end, palindrome_linked_list, intersection_of_lists, rotate_linked_list, swap_nodes_in_pairs, remove_duplicates_sorted_list, partition_list, merge_sort_linked_list, add_two_numbers_linked_list, intersection_detection_hashset, reverse_nodes_in_k_group, detect_and_remove_loop, convert_binary_linked_list_to_int

## 🧮 Matrix Algorithms
**Matrix/grid algorithms:**
- flood_fill, island_count_dfs, island_count_bfs, shortest_path_in_grid, word_search (matrix), path_sum, matrix_rotation, spiral_traversal, surrounded_regions

## 🥇 List Advanced Sorts & Selection
**Advanced sorting and selection:**
- heap_sort, shell_sort, gnome_sort, odd_even_sort, pancake_sort, cycle_sort, bucket_sort, radix_sort, pigeonhole_sort, bitonic_sort, comb_sort, stooge_sort, quickselect, lis_binary_search, max_product_subarray

## 🌊 Network / Flow Algorithms
**Network flow and optimization:**
- a_star, ford_fulkerson, edmonds_karp, dinics_algorithm (network), tarjans_algorithm, max_flow_min_cut, min_cost_flow, hungarian, edmonds_blossom

---

## 🛠️ Tooling & Testing
- Debugging helpers and example scripts in `tooling/`
- Expanded examples and onboarding in `example/`
- Comprehensive tests in `test/` for all modules

---

## 📝 Notes
- This changelog is in list format for quick reference and discoverability.
- For a machine-readable export (JSON/CSV) or a separate RELEASES log with commit dates, open an issue or PR.
	```markdown
	# CHANGELOG — Overview & Exports

	This file emphasizes the library's most advanced capabilities first, followed by a grouped export list for quick reference.

	Most advanced algorithms (highlights)

	- Graph & network
		- johnsons_algorithm
		- dinics_algorithm
		- stoer_wagner_min_cut
		- yens_algorithm
		- hierholzer
		- tarjans_scc

	- Machine Learning & Deep Learning
		- transformer
		- cnn
		- rnn
		- lstm
		- gan

	- Optimization & flow
		- min_cost_flow
		- hungarian
		- edmonds_blossom

	- Cryptography & consensus
		- bls_signatures
		- ecdsa
		- pbft
		- bft

	- Compression & coding
		- arithmetic
		- bwt
		- huffman

	Exports (grouped)

	> The following lists mirror the public exports in `lib/lunaris_engine.dart`.

	### Graph algorithms
	- weighted_edge
	- bfs
	- dfs
	- topological_sort
	- connected_components
	- cycle_detection
	- bipartite_graph
	- shortest_path
	- dijkstra
	- bellman_ford
	- floyd_warshall
	- mst_kruskal
	- mst_prim
	- kosaraju_scc
	- articulation_points
	- johnsons_algorithm
	- dinics_algorithm
	- eulerian_path
	- hamiltonian_path
	- chinese_postman
	- stoer_wagner_min_cut
	- transitive_closure
	- graph_coloring
	- spfa
	- tarjans_scc
	- bridge_finding
	- tree_diameter
	- hierholzer
	- yens_algorithm
	- union_find

	### Network / Flow algorithms
	- a_star
	- ford_fulkerson
	- edmonds_karp
	- dinics_algorithm (network)
	- tarjans_algorithm

	### Machine Learning
	- linear_regression
	- logistic_regression
	- decision_tree
	- random_forest
	- svm
	- knn
	- naive_bayes
	- gradient_boosting
	- xgboost_like
	- gradient_boosting_classifier
	- lightgbm_like
	- catboost_like
	- ann
	- cnn
	- rnn
	- lstm
	- gru
	- transformer
	- gan
	- simulated_annealing
	- genetic_algorithm
	- particle_swarm
	- bayesian_optimization
	- mdp

	### Reinforcement Learning
	- q_learning
	- dqn
	- sarsa
	- policy_gradient
	- actor_critic
	- ppo
	- mcts

	### Dynamic Programming (DP)
	- fibonacci_memoization
	- knapsack_01
	- longest_increasing_subsequence
	- longest_common_subsequence
	- edit_distance
	- matrix_path_sum
	- coin_change
	- subset_sum
	- partition_equal_subset_sum
	- house_robber
	- jump_game
	- alternating_subsequences
	- rod_cutting
	- minimum_path_sum
	- unique_paths_with_obstacles
	- decode_ways
	- interleaving_string
	- coin_change_bottom_up
	- paint_house
	- burst_balloons
	- longest_bitonic_subsequence
	- matrix_chain_multiplication
	- count_palindromic_subsequences
	- min_cuts_palindrome_partitioning
	- max_sum_increasing_subsequence
	- cherry_pickup
	- wildcard_matching
	- regex_matching

	### List algorithms
	- linear_search
	- binary_search
	- merge_sort
	- bubble_sort
	- insertion_sort
	- selection_sort
	- quick_sort
	- counting_sort
	- reverse_list
	- find_max_min
	- find_duplicates
	- kadanes_algorithm
	- max_sum_subarray_of_size_k
	- min_sum
	- average_subarray
	- two_sum_sorted
	- remove_duplicates
	- rotate_array_right
	- prefix_sum

	### Set algorithms
	- has_duplicates
	- disjoint_set
	- find_intersection
	- set_difference
	- is_frequency_unique
	- has_two_sum
	- has_unique_window
	- symmetric_difference
	- power_set
	- subset_check
	- superset_check
	- disjoint_check
	- list_to_set_preserve_order
	- multiset_operations

	### Map algorithms
	- frequency_count
	- group_by_key
	- first_non_repeated_element
	- anagram_checker
	- two_sum
	- lru_cache
	- most_frequent_element
	- top_k_frequent
	- length_of_longest_substring
	- invert_map
	- merge_maps_conflict
	- group_anagrams
	- word_frequency_ranking
	- all_pairs_with_sum
	- index_mapping
	- mru_cache
	- count_pairs_with_diff
	- find_subarrays_with_sum
	- min_window_substring

	### String algorithms
	- reverse_string
	- palindrome_checker
	- anagram_checker
	- longest_palindromic_substring
	- string_compression
	- brute_force_search
	- kmp_search
	- rabin_karp_search
	- longest_common_prefix
	- edit_distance
	- count_vowels_consonants
	- manacher_longest_palindrome
	- boyer_moore_search
	- z_algorithm
	- rolling_hash
	- longest_repeating_substring
	- remove_consecutive_duplicates
	- min_window_subsequence
	- atoi
	- integer_roman
	- string_permutations

	### Tree algorithms
	- binary_tree_node
	- tree_traversals
	- level_order_traversal
	- tree_depth
	- invert_tree
	- lowest_common_ancestor
	- validate_bst
	- tree_diameter
	- balanced_tree_check
	- tree_serialization
	- zigzag_traversal
	- morris_traversal
	- threaded_binary_tree_traversal
	- count_leaf_nodes
	- count_full_nodes
	- count_half_nodes
	- print_all_root_to_leaf_paths
	- path_sum_in_tree
	- vertical_order_traversal
	- boundary_traversal
	- bottom_top_view_binary_tree
	- construct_tree_inorder_preorder
	- construct_tree_inorder_postorder
	- convert_sorted_array_to_bst
	- flatten_binary_tree_to_linked_list
	- lowest_common_ancestor_no_bst

	### Linked list algorithms
	- linked_list_node
	- doubly_linked_list_node
	- insert_delete_at_position
	- reverse_linked_list
	- detect_cycle
	- merge_sorted_lists
	- remove_nth_from_end
	- palindrome_linked_list
	- intersection_of_lists
	- rotate_linked_list
	- swap_nodes_in_pairs
	- remove_duplicates_sorted_list
	- partition_list
	- merge_sort_linked_list
	- add_two_numbers_linked_list
	- intersection_detection_hashset
	- reverse_nodes_in_k_group
	- detect_and_remove_loop
	- convert_binary_linked_list_to_int

	### Matrix algorithms
	- flood_fill
	- island_count_dfs
	- island_count_bfs
	- shortest_path_in_grid
	- word_search (matrix)
	- path_sum
	- matrix_rotation
	- spiral_traversal
	- surrounded_regions

	### List advanced sorts & selection
	- heap_sort
	- shell_sort
	- gnome_sort
	- odd_even_sort
	- pancake_sort
	- cycle_sort
	- bucket_sort
	- radix_sort
	- pigeonhole_sort
	- bitonic_sort
	- comb_sort
	- stooge_sort
	- quickselect
	- lis_binary_search
	- max_product_subarray

	### Consensus algorithms
	- proof_of_work
	- proof_of_stake
	- delegated_proof_of_stake
	- proof_of_authority
	- proof_of_burn
	- proof_of_capacity
	- proof_of_elapsed_time
	- bft
	- pbft
	- fba

	### Cryptographic algorithms
	- sha256
	- ripemd160
	- keccak256
	- scrypt
	- argon2
	- ecdsa
	- eddsa
	- bls_signatures
	- scrypt_mining

	### Routing algorithms
	- bgp_algorithm
	- ospf_algorithm
	- rip_algorithm
	- link_state_routing
	- distance_vector_routing

	### Wireless / P2P
	- aodv
	- dsr
	- chord
	- kademlia

	### Compression algorithms
	- huffman
	- lzw
	- rle
	- arithmetic
	- bwt

	### Network optimization
	- max_flow_min_cut
	- min_cost_flow
	- hungarian
	- edmonds_blossom

	Changelog highlights

	- Major feature additions: Machine Learning modules (supervised & deep learning), expanded Graph algorithms (advanced shortest-path and flow), and a broad DP/Matrix suite.
	- Tooling: debugging helpers under `tooling/` and expanded examples under `example/` to make onboarding easier.
	- Testing: many new tests added under `test/` for the new modules.

	Notes & next steps

	- This changelog favors readability and a discoverable exports list. If you want a machine-readable export (JSON/CSV) or a separate RELEASES log with commit dates, I can add it.

	```
