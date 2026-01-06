#!/bin/bash

# Start Ollama in the background
/bin/ollama serve &

# Get ollama pid
pid=$!

# Pause for Ollama to startup
sleep 5

echo "Retrieving model"
ollama pull llama3
echo "Done"

# Wait for Ollama to finish
wait $pid
