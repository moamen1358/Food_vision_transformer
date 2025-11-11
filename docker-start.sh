#!/bin/bash

# ViT Food Vision - Gradio Demo Docker

set -e

echo "🚀 ViT Food Vision - Gradio Demo"
echo ""

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed."
    exit 1
fi

# Detect compose command
if docker compose version &> /dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
elif command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
else
    echo "❌ Docker Compose not found"
    exit 1
fi

# Start Gradio
echo "Starting Gradio demo..."
sudo $COMPOSE_CMD up -d

echo ""
echo "✅ Gradio demo started!"
echo ""
echo "🎨 Access: http://localhost:7860"
echo ""
echo "Commands:"
echo "  View logs:    sudo docker compose logs -f"
echo "  Stop:         sudo docker compose down"
echo "  Restart:      sudo docker compose restart"
echo ""

