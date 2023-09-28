
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Container High Memory Usage Incident
---

A Container High Memory Usage Incident occurs when the memory usage of a container exceeds a certain threshold, usually 90%. This can cause performance issues and potentially lead to system crashes. The incident should be resolved by identifying the root cause of the high memory usage and taking appropriate actions to reduce it.

### Parameters
```shell
export CONTAINER_NAME="PLACEHOLDER"

export PATH_TO_BINARY="PLACEHOLDER"

export PROCESS_ID="PLACEHOLDER"

export NEW_MEMORY_LIMIT="PLACEHOLDER"

export CONTAINER_ID="PLACEHOLDER"
```

## Debug

### Check overall memory usage on the host
```shell
free -m
```

### Display the top processes by memory usage
```shell
ps aux --sort=-%mem | head
```

### Check container memory usage
```shell
docker stats ${CONTAINER_NAME}
```

### Check for memory leaks in the application
```shell
valgrind --leak-check=full ${PATH_TO_BINARY}
```

### Analyze memory usage and generate a report
```shell
pmap -d ${PROCESS_ID} | tail -1
```

### Check for memory fragmentation
```shell
cat /proc/buddyinfo
```

### Check the system logs for any memory-related errors
```shell
dmesg | grep -i memory
```

### Check kernel memory usage
```shell
cat /proc/meminfo | grep -i kernel
```

### Check for any memory-related errors in the container logs
```shell
docker logs ${CONTAINER_NAME} | grep -i memory
```

### Inefficient resource allocation for the container, causing it to consume more memory than necessary.
```shell
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


```

## Repair

### Increasing the memory allocation for the container can help reduce high memory usage incidents. This ensures that the container has enough memory to handle the workload it is running.
```shell
bash

#!/bin/bash



# Set the container name and memory limit

CONTAINER_NAME=${CONTAINER_NAME}

MEMORY_LIMIT=${NEW_MEMORY_LIMIT}

# Update the container with the new memory limit
docker update -m $MEMORY_LIMIT $CONTAINER_NAME

```