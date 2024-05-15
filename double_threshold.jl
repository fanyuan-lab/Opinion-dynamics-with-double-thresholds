using LightGraphs
using Random

# Create a random regular graph
function create_random_regular_graph(n, d)
    return random_regular_graph(n, d)
end

# Initialize opinions with a given ratio r of nodes starting with opinion 1
function initialize_opinions(n, r)
    opinions = zeros(Int, n)
    num_ones = round(Int, r * n)  # Calculate number of ones based on ratio
    opinions[1:num_ones] .= 1
    shuffle!(opinions)  # Randomize opinions
    return opinions
end

# Update opinions function
function update_opinions(graph, opinions, phi)
    new_opinions = copy(opinions)
    for i in 1:length(opinions)
        neighbor_nodes = neighbors(graph, i)
        if !isempty(neighbor_nodes)
            opposite_opinion_count = sum([opinions[n] for n in neighbor_nodes] .!= opinions[i])
            opposite_opinion_ratio = opposite_opinion_count / length(neighbor_nodes)
            if opposite_opinion_ratio > phi
                new_opinions[i] = 1 - opinions[i]
            end
        end
    end
    return new_opinions
end

# Main simulation function
function simulate_opinion_dynamics(n, d, phi, r, steps)
    graph = create_random_regular_graph(n, d)
    opinions = initialize_opinions(n, r)
    opinion_1_ratios = Float64[]
    for t in 1:steps
        opinions = update_opinions(graph, opinions, phi)
        opinion_1_ratio = sum(opinions) / n
        push!(opinion_1_ratios, opinion_1_ratio)
    end
    return opinions, opinion_1_ratios
end

n = 500          # Number of nodes
d = 4            # Node degree
phi = 0.1       # Threshold
r = 0.3          # Initial ratio of ones
steps = 500      # Number of time steps

final_opinions, opinion_1_ratios = simulate_opinion_dynamics(n, d, phi, r, steps)
