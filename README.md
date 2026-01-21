# sonar-embedding-server
Embedding server to serve sonar embeddings OpenAI API style

# Quick Start

- have docker installed
- clone the repo
- run `docker compose -f docker-compose.yml up` (add `-d` to run in background)
- server will be available at `http://localhost:8808`

You can test the server using curl:

```bash
curl http://eve:8808/v1/embeddings   
-H "Content-Type: application/json"   
-d '{"input":["Hello world","Bonjour le monde"]}'
```