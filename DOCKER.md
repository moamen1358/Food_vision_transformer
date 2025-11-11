# ViT Food Vision - Docker Setup

This directory contains Docker configurations for running the ViT Food Vision transformer project.

## Prerequisites

- **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose**: [Install Docker Compose](https://docs.docker.com/compose/install/)
- **NVIDIA Docker Runtime** (for GPU support): [Install NVIDIA Docker](https://github.com/NVIDIA/nvidia-docker)

## Quick Start

### 1. Build the Docker Image

```bash
# Build the training image
docker build -t vit-food-vision:latest .

# Or use docker-compose (automatically builds)
docker-compose up --build
```

### 2. Run with Docker Compose (Recommended)

```bash
# Start all services (Jupyter Lab, TensorBoard, optional Gradio demo)
docker-compose up -d

# View logs
docker-compose logs -f vit-training

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### 3. Run with Docker (Manual)

```bash
# With GPU support
docker run --gpus all -it \
  -p 8888:8888 \
  -p 7860:7860 \
  -p 6006:6006 \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/models:/app/models \
  -v $(pwd)/outputs:/app/outputs \
  -v $(pwd)/logs:/app/logs \
  vit-food-vision:latest

# Without GPU
docker run -it \
  -p 8888:8888 \
  -p 7860:7860 \
  -p 6006:6006 \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/models:/app/models \
  vit-food-vision:latest
```

## Services

### Jupyter Lab (Port 8888)
- **URL**: http://localhost:8888
- **Purpose**: Interactive notebook environment for training and experimentation
- **Token**: No authentication (can be configured in Dockerfile)

### Gradio Demo (Port 7860)
- **URL**: http://localhost:7860
- **Purpose**: Web UI for model inference and food classification
- **Build**: `docker build -f Dockerfile.demo -t vit-demo:latest .`

### TensorBoard (Port 6006)
- **URL**: http://localhost:6006
- **Purpose**: Training metrics visualization
- **Logs**: Auto-synced from `./logs/` directory

## Directory Structure in Container

```
/app/
├── data/              # CIFAR-100 dataset
├── models/            # Trained model weights
├── outputs/           # Inference results
├── logs/              # Training logs & TensorBoard events
├── helper_pytorch/    # Helper functions and engine
└── Food101_pytorch_vit_effnet.ipynb
```

## GPU Support

### Check GPU in Container

```bash
# From inside the container
docker exec vit-training nvidia-smi

# Or in docker-compose
docker-compose exec vit-training nvidia-smi
```

### Troubleshooting GPU

1. **Check host GPU**:
   ```bash
   nvidia-smi
   ```

2. **Check Docker GPU support**:
   ```bash
   docker run --rm --gpus all nvidia/cuda:11.8.0-runtime-ubuntu22.04 nvidia-smi
   ```

3. **If GPU not detected**, ensure NVIDIA Docker runtime is installed:
   ```bash
   docker run --rm --gpus all ubuntu nvidia-smi
   ```

## Workflow Examples

### Example 1: Train ViT Model

```bash
# Start container
docker-compose up -d

# Access Jupyter Lab
# http://localhost:8888

# Open Food101_pytorch_vit_effnet.ipynb
# Run training cells
# Model saved to /app/models/
```

### Example 2: Run Inference

```bash
# Enter container shell
docker-compose exec vit-training bash

# Run prediction script (if available)
python predictions.py --image path/to/image.jpg

# Or use Gradio demo
docker build -f Dockerfile.demo -t vit-demo:latest .
docker run -p 7860:7860 vit-demo:latest
```

### Example 3: Persistent Data

```bash
# Data persists in ./data, ./models, ./logs directories
# Even after stopping the container

docker-compose down  # Stops container but keeps data
docker-compose up -d # Resumes with saved data

# To remove all data
docker-compose down -v  # Removes volumes
```

## Environment Variables

Edit `docker-compose.yml` to set:

```yaml
environment:
  - CUDA_VISIBLE_DEVICES=0      # GPU ID
  - PYTHONUNBUFFERED=1          # Real-time logs
  - JUPYTER_ENABLE_LAB=yes      # Use JupyterLab instead of Notebook
```

## Common Commands

```bash
# View running containers
docker ps

# View all containers (including stopped)
docker ps -a

# View logs
docker logs vit-training
docker-compose logs -f

# Enter container shell
docker exec -it vit-training bash
docker-compose exec vit-training bash

# Stop container
docker stop vit-training
docker-compose stop

# Remove container
docker rm vit-training
docker-compose down

# Clean up unused images/volumes
docker system prune -a
```

## Performance Tips

1. **Increase Docker resources** in Docker Desktop:
   - Settings → Resources
   - CPUs: 8+
   - Memory: 16GB+
   - GPU: Enable if available

2. **Batch size optimization** in notebook:
   - Start with batch_size=32
   - Increase to 128, 256 if VRAM allows

3. **Use volume mounts** for data persistence:
   - Large datasets stay on host
   - Faster access than copying

## Troubleshooting

### Container exits immediately

```bash
# Check logs
docker logs vit-training

# Run with interactive terminal
docker run -it vit-food-vision:latest /bin/bash
```

### Out of memory (OOM)

```bash
# Increase Docker memory limit
docker run -m 16g ...

# Or reduce batch size in notebook
```

### GPU not detected

```bash
# Verify host GPU
nvidia-smi

# Verify Docker GPU support
docker run --rm --gpus all nvidia/cuda:11.8.0-runtime-ubuntu22.04 nvidia-smi

# Restart Docker daemon
sudo systemctl restart docker
```

### Port conflicts

```bash
# Change port mapping in docker-compose.yml
# 8888:8888 → 9999:8888  (access at localhost:9999)
```

## Production Deployment

For production, consider:

1. **Use specific image tags** (not `latest`)
2. **Set resource limits** in docker-compose
3. **Use environment files** for secrets
4. **Enable authentication** in Jupyter Lab
5. **Use reverse proxy** (nginx) for HTTPS
6. **Run on Docker Swarm or Kubernetes** for scaling

## Support

For issues:
1. Check logs: `docker-compose logs`
2. Verify GPU: `nvidia-smi` on host and container
3. Test container: `docker run -it vit-food-vision:latest bash`

## References

- [PyTorch Docker Images](https://hub.docker.com/r/pytorch/pytorch)
- [Docker Documentation](https://docs.docker.com/)
- [NVIDIA Docker](https://github.com/NVIDIA/nvidia-docker)
- [Docker Compose](https://docs.docker.com/compose/)
