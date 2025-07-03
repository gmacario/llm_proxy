# llm_proxy

This project provides a simple Python proxy for interacting with Large Language Models (LLMs) via the [Ollama API](https://github.com/ollama/ollama/blob/main/docs/api.md).
The main script, `ollama_proxy.py`, acts as a lightweight HTTP proxy, forwarding requests to an Ollama server and returning the responses.
This can be useful for integrating LLM capabilities into other applications or for adding an abstraction layer between clients and the Ollama backend.

## Features

- Forwards HTTP requests to an Ollama LLM server
- Easy to configure and run
- Written in Python for simplicity and flexibility

## Requirements

- Python 3.11 or newer
- Ollama server running and accessible

## Usage

1. Install the required dependencies (see `pyproject.toml`).
2. Run `ollama_proxy.py` to start the proxy server.
3. Send requests to the proxy, which will forward them to the Ollama backend.

Example:

```bash
# Customize environment variables
cp sample.env .env
vi .env

# Run the proxy server
uv run ollama_proxy.py
```

### Running in Docker

Build the container image

```bash
docker build -t ollama_proxy .
```

Run as a service

```bash
docker run -d --rm \
    -e TARGET_URL=https://openwebui.example.com/ollama \
    -e TARGET_API_KEY=MY_BEARER_KEY \
    -p 11434:11434 \
    ollama_proxy
```

## License

See [LICENSE](LICENSE) for details.

<!-- EOF -->
