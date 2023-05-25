#!/bin/bash

# This script is to be run inside a docker container, or some other installation that has Yates installed with our -rrt option
# Define the lists of numbers
node_count=(50 97 196 490 968 1966 4894 9819)
percentages=(5 7 10 12 15 17 20 22 25 30 35 40)

# Iterate over the first numbers
for first_num in "${node_count[@]}"; do
  # Iterate over the second numbers
  for second_num in "${percentages[@]}"; do
    # Build the command with the current numbers
    command="time yates data/topologies/randomized/randgraph_${first_num}_nodes_${second_num}%_brs.dot data/demands/actual/abilene.txt data/demands/predicted/abilene.txt data/topologies/randomized/hosts/randgraph_${first_num}_nodes_${second_num}%_brs.hosts -rrt"
    
    # Print the iteration information
    echo "Running command: $command"
    
    # Start the timer
    start_time=$(date +%s.%N)
    
    # Execute the command
    eval "$command"
    
    # Calculate the elapsed time
    end_time=$(date +%s.%N)
    elapsed_time=$(echo "$end_time - $start_time" | bc)
    
    # Print the elapsed time
    echo "Elapsed time: $elapsed_time seconds"
    
    # Create the folder for the current iteration
    folder_name="${first_num}_${second_num}"
    mkdir "$folder_name"
    
    # Copy the generated .dot files to the folder
    cp *.dot "$folder_name"    
    
    # Delete the .dot files from the current directory
    rm *.dot
    
    # Add a newline for readability
    echo
  done
done
