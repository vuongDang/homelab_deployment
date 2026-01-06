# Start from ollama official image
FROM ollama/ollama:latest

# Copy the script in the container
COPY download_ollama.sh /download_ollama.sh

# Make the script executable
RUN chmod +x /download_ollama.sh

# Start the script when the container is up
ENTRYPOINT ["/download_ollama.sh"]
