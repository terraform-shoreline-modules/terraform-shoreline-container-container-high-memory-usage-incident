bash

#!/bin/bash



# Set the container ID

container_id=${CONTAINER_ID}



# Get the container's resource usage information

usage_info=$(docker stats $container_id --no-stream)



# Extract the memory usage value from the usage information

memory_usage=$(echo "$usage_info" | awk '{print $4}' | tail -n 1)



# Get the allocated memory for the container

allocated_memory=$(docker inspect $container_id | grep -i 'memory":' | awk '{print $2}' | sed 's/,//g')



# Calculate the memory usage percentage

memory_usage_percentage=$(awk "BEGIN {print ($memory_usage/$allocated_memory)*100}")



# Check if the memory usage percentage exceeds a certain threshold

threshold=90

if (( $(echo "$memory_usage_percentage > $threshold" | bc -l) )); then

    echo "Container $container_id is consuming more memory than necessary."

    echo "Memory usage: $memory_usage"

    echo "Allocated memory: $allocated_memory"

    echo "Memory usage percentage: $memory_usage_percentage%"

else

    echo "Container $container_id is not consuming more memory than necessary."

fi