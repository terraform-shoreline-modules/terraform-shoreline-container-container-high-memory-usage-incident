bash

#!/bin/bash



# Set the container name and memory limit

CONTAINER_NAME=${CONTAINER_NAME}

MEMORY_LIMIT=${NEW_MEMORY_LIMIT}

# Update the container with the new memory limit
docker update -m $MEMORY_LIMIT $CONTAINER_NAME