#!/bin/bash

# ViT Food Vision - Docker Quick Start Script

set -e

echo "🚀 ViT Food Vision - Docker Setup"
echo "=================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check Docker installation
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check for NVIDIA GPU support
if command -v nvidia-smi &> /dev/null; then
    echo -e "${GREEN}✓ NVIDIA GPU detected${NC}"
    HAS_GPU=true
else
    echo -e "${BLUE}ℹ No NVIDIA GPU detected. Will use CPU${NC}"
    HAS_GPU=false
fi

# Menu
echo ""
echo "Select an option:"
echo "1) Build Docker image"
echo "2) Start services (docker-compose)"
echo "3) Start training container"
echo "4) Start demo container"
echo "5) Stop all services"
echo "6) View logs"
echo "7) Enter container shell"
echo "8) Clean up (remove images and volumes)"
echo ""
read -p "Enter choice [1-8]: " choice

case $choice in
    1)
        echo -e "${BLUE}Building Docker image...${NC}"
        docker build -t vit-food-vision:latest .
        echo -e "${GREEN}✓ Build complete${NC}"
        ;;
    
    2)
        echo -e "${BLUE}Starting services with docker-compose...${NC}"
        docker-compose up -d
        echo -e "${GREEN}✓ Services started${NC}"
        echo ""
        echo "📌 Access points:"
        echo "  - Jupyter Lab: http://localhost:8888"
        echo "  - TensorBoard: http://localhost:6006"
        echo "  - Gradio Demo: http://localhost:7860"
        echo ""
        echo "View logs: docker-compose logs -f"
        ;;
    
    3)
        echo -e "${BLUE}Starting training container...${NC}"
        if [ "$HAS_GPU" = true ]; then
            docker run --gpus all -it \
              -p 8888:8888 \
              -p 6006:6006 \
              -v $(pwd)/data:/app/data \
              -v $(pwd)/models:/app/models \
              -v $(pwd)/logs:/app/logs \
              vit-food-vision:latest
        else
            docker run -it \
              -p 8888:8888 \
              -p 6006:6006 \
              -v $(pwd)/data:/app/data \
              -v $(pwd)/models:/app/models \
              -v $(pwd)/logs:/app/logs \
              vit-food-vision:latest
        fi
        ;;
    
    4)
        echo -e "${BLUE}Building and starting demo container...${NC}"
        docker build -f Dockerfile.demo -t vit-demo:latest .
        if [ "$HAS_GPU" = true ]; then
            docker run --gpus all -p 7860:7860 -it vit-demo:latest
        else
            docker run -p 7860:7860 -it vit-demo:latest
        fi
        ;;
    
    5)
        echo -e "${BLUE}Stopping all services...${NC}"
        docker-compose down
        echo -e "${GREEN}✓ Services stopped${NC}"
        ;;
    
    6)
        echo -e "${BLUE}Viewing logs...${NC}"
        docker-compose logs -f
        ;;
    
    7)
        echo -e "${BLUE}Entering container shell...${NC}"
        docker-compose exec vit-training bash
        ;;
    
    8)
        echo -e "${BLUE}Cleaning up Docker resources...${NC}"
        read -p "⚠️  This will remove images and volumes. Continue? (y/n): " confirm
        if [ "$confirm" = "y" ]; then
            docker-compose down -v
            docker rmi vit-food-vision:latest vit-demo:latest
            docker system prune -a --volumes
            echo -e "${GREEN}✓ Cleanup complete${NC}"
        else
            echo "Cancelled."
        fi
        ;;
    
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac
