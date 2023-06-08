#!/bin/bash

# This script is to be run inside a docker container, or some other installation that has Yates installed with our -rrt option
# Define the lists of numbers
node_count=(50 100 200 500 1000 2000)
percentages=(7 17 )

output_file="elapsed times.txt"

# Iterate over the first numbers
for first_num in "${node_count[@]}"; do
  # Iterate over the second numbers
  for second_num in "${percentages[@]}"; do
    # Build the command with the current numbers
    command="time yates.crtl ../data/topologies/randomized/randgraph_${first_num}_nodes_${second_num}%_brs.dot ../data/demands/actual/abilene.txt ../data/demands/predicted/abilene.txt ../data/topologies/randomized/hosts/randgraph_${first_num}_nodes_${second_num}%_brs.hosts -alg rrt"
    
    # Create the folder for the current iteration
    folder_name="${first_num}_${second_num}"
    mkdir "$folder_name"
    
    # Go into the new dir
    cd "$folder_name"

    # Print the iteration information
    echo "Running command: $command"
   
    # Execute the command
    eval "$command" >> "$output_file" 2>&1
    
    # Print the elapsed time
    echo "Elapsed time: $elapsed_time seconds"
    
    #Go back to parent directory
    cd ".."
    
    # Add a newline for readability
    echo
  done
done