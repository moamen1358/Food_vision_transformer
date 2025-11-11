#!/bin/bash

# ViT Food Vision - Docker Quick Start
# Simply runs: docker compose up -d

set -e

echo "🚀 ViT Food Vision - Starting Docker..."
echo ""

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Install it first:"
    echo "   https://docs.docker.com/get-docker/"
    exit 1
fi

# Detect compose command (v2 uses "docker compose", v1 uses "docker-compose")
if docker compose version &> /dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
elif command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
else
    echo "❌ Docker Compose not found"
    exit 1
fi

# Start services
echo "Starting containers..."
$COMPOSE_CMD up -d

echo ""
echo "✅ Services started!"
echo ""
echo "📌 Access points:"
echo "   🖥️  Jupyter Lab:  http://localhost:8888"
echo "   📊 TensorBoard:  http://localhost:6006"
echo "   🎨 Gradio Demo:  http://localhost:7860"
echo ""
echo "📝 Useful commands:"
echo "   View logs:       docker compose logs -f"
echo "   Enter shell:     docker compose exec vit-training bash"
echo "   Stop services:   docker compose down"
echo "   Restart:         docker compose restart"
echo ""
