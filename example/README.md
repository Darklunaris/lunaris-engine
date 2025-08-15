# lunaris engine Examples

This directory contains examples organized by algorithm categories. Each subdirectory contains examples related to a specific type of algorithm.

## Directory Structure

### `lunaris_engine_example.dart`
Main example file demonstrating the core functionality of the lunaris_engine library.

### `consensus_algorithms/`
Examples of consensus algorithms used in distributed systems:
- **BFT (Byzantine Fault Tolerance)**: `bft_example.dart`
- **PBFT (Practical Byzantine Fault Tolerance)**: `pbft_example.dart`
- **Delegated Proof of Stake**: `delegated_proof_of_stake_example.dart`
- **Proof of Authority**: `proof_of_authority_example.dart`
- **Proof of Burn**: `proof_of_burn_example.dart`
- **Proof of Capacity**: `proof_of_capacity_example.dart`
- **Proof of Elapsed Time**: `proof_of_elapsed_time_example.dart`
- **Proof of Stake**: `proof_of_stake_example.dart`
- **Proof of Work**: `proof_of_work_example.dart`
- **FBA (Federated Byzantine Agreement)**: `fba_example.dart`
- **Gossip Protocol**: `gossip_protocol_example.dart`

### `cryptographic_algorithms/`
Examples of cryptographic algorithms and data structures:
- **Cryptographic Algorithms**: `cryptographic_algorithms_example.dart`
- **Scrypt Mining**: `scrypt_mining_example.dart`
- **Merkle Tree**: `merkle_tree_example.dart`
- **Bloom Filter**: `bloom_filter_example.dart`

### `ml_algorithms/`
Examples of machine learning algorithms:
- **Neural Networks**: `ann_example.dart`, `cnn_example.dart`, `rnn_example.dart`, `lstm_example.dart`, `gru_example.dart`
- **Reinforcement Learning**: `actor_critic_example.dart`, `dqn_example.dart`, `sarsa_example.dart`, `q_learning_example.dart`, `policy_gradient_example.dart`, `ppo_example.dart`
- **Tree-based Methods**: `decision_tree_example.dart`, `random_forest_example.dart`, `gradient_boosting_example.dart`, `gradient_boosting_classifier_example.dart`
- **Clustering**: `kmeans_example.dart`, `dbscan_example.dart`, `hierarchical_clustering_example.dart`
- **Optimization**: `genetic_algorithm_example.dart`, `bayesian_optimization_example.dart`, `simulated_annealing_example.dart`, `particle_swarm_example.dart`
- **Other ML**: `svm_example.dart`, `naive_bayes_example.dart`, `linear_regression_example.dart`, `logistic_regression_example.dart`, `knn_example.dart`
- **Dimensionality Reduction**: `pca_example.dart`, `tsne_example.dart`
- **Advanced ML**: `autoencoder_example.dart`, `gan_example.dart`, `gmm_example.dart`, `transformer_example.dart`
- **Gradient Boosting Variants**: `xgboost_like_example.dart`, `lightgbm_like_example.dart`, `catboost_like_example.dart`
- **Game Theory**: `mcts_example.dart`
- **Markov Decision Processes**: `mdp_example.dart`

### `dp_algorithms/`
Examples of dynamic programming algorithms:
- Various dynamic programming problem solutions

### `linked_list_algorithms/`
Examples of linked list algorithms:
- Various linked list manipulation and problem-solving algorithms

### `backtracking_algorithms/`
Examples of backtracking algorithms:
- `backtrackingexample.dart`

### `graph_algorithms/`
Examples of graph algorithms:
- `graph_advanced_example.dart`

### `network_algorithms/`
Examples of advanced network algorithms:
- **Path Finding**: `network_algorithms_example.dart` (A* algorithm)
- **Maximum Flow**: Ford-Fulkerson, Edmonds-Karp, Dinic's algorithms
- **Connectivity Analysis**: Tarjan's algorithm for bridges and articulation points
- **Data Structures**: Union-Find/Disjoint Set with path compression

### `tree_algorithms/`
Examples of tree algorithms:
- `tree_algorithms_example.dart`

### `string_algorithms/`
Examples of string algorithms:
- `string_advancedexample.dart`

### `list_algorithms/`
Examples of list algorithms:
- `list_advanced_sortsexample.dart`

### `map_algorithms/`
Examples of map algorithms:
- `map_advancedexample.dart`

### `matrix_algorithms/`
Examples of matrix algorithms:
- `matrixexample.dart`

### `set_algorithms/`
Examples of set algorithms:
- `set_advancedexample.dart`

## Usage

Each example file demonstrates how to use specific algorithms from the lunaris_engine library. To run an example:

```bash
dart run example/[category]/[example_file].dart
```

For example:
```bash
dart run example/consensus_algorithms/proof_of_work_example.dart
```

## Organization Benefits

This organization provides several benefits:
1. **Logical Grouping**: Related algorithms are grouped together
2. **Easy Navigation**: Developers can quickly find examples for specific algorithm types
3. **Maintainability**: Easier to maintain and update examples
4. **Learning Path**: Clear structure for learning different types of algorithms
5. **Reference**: Quick reference for specific algorithm implementations
