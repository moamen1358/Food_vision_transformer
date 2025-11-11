# Docker Setup Complete! 🐳

Your ViT Food Vision project is now fully containerized. Here's what was created:

## 📁 Files Created

### Core Docker Files
- **`Dockerfile`** - Main training environment with PyTorch, Jupyter Lab, and all dependencies
- **`Dockerfile.demo`** - Separate container for Gradio demo app
- **`docker-compose.yml`** - Orchestrates all services (training, Jupyter, TensorBoard, optional Gradio)
- **`.dockerignore`** - Optimizes build by excluding unnecessary files

### Scripts
- **`docker-start.sh`** - Interactive Linux/Mac startup script
- **`docker-start.bat`** - Interactive Windows startup script

### Configuration
- **`requirements.txt`** - Python dependencies for the main container
- **`DOCKER.md`** - Comprehensive Docker documentation

## 🚀 Quick Start

### Linux/Mac
```bash
chmod +x docker-start.sh
./docker-start.sh
```

### Windows
```cmd
docker-start.bat
```

### Or use docker-compose directly
```bash
# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## 🌐 Access Points

Once running:

| Service | URL | Purpose |
|---------|-----|---------|
| **Jupyter Lab** | http://localhost:8888 | Interactive notebook training |
| **TensorBoard** | http://localhost:6006 | Training metrics visualization |
| **Gradio Demo** | http://localhost:7860 | Web UI for food classification |

## 💾 Data Persistence

Your data is automatically mounted in these directories:
- `./data/` - Dataset (CIFAR-100)
- `./models/` - Trained model weights
- `./outputs/` - Inference results
- `./logs/` - Training logs & TensorBoard events

All changes are saved locally, even when containers stop.

## 🎮 Available Commands

```bash
# View logs
docker-compose logs -f vit-training

# Enter container shell
docker-compose exec vit-training bash

# Run a single command
docker-compose exec vit-training nvidia-smi

# Stop services
docker-compose stop

# Restart services
docker-compose restart

# Remove everything (keep data)
docker-compose down

# Remove everything (delete all data)
docker-compose down -v
```

## 🔧 Customization

### GPU Configuration
Edit `docker-compose.yml` if you have multiple GPUs:
```yaml
environment:
  - CUDA_VISIBLE_DEVICES=0  # Change to GPU ID
```

### Jupyter Token
To require a password, edit `Dockerfile`:
```dockerfile
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
# Add: --token=your_token_here
```

### Resource Limits
Edit `docker-compose.yml` to limit CPU/RAM:
```yaml
deploy:
  resources:
    limits:
      cpus: '4'
      memory: 16G
```

## 📋 Typical Workflow

1. **Start services**
   ```bash
   docker-compose up -d
   ```

2. **Access Jupyter Lab**
   - Open http://localhost:8888
   - Upload or create notebooks

3. **Train model**
   - Run `Food101_pytorch_vit_effnet.ipynb`
   - Models saved to `./models/`

4. **Monitor training**
   - Open http://localhost:6006 for TensorBoard
   - View GPU usage: `docker-compose exec vit-training nvidia-smi -l 1`

5. **Run inference**
   - Use Gradio demo on http://localhost:7860
   - Or use prediction scripts in Jupyter

6. **Stop when done**
   ```bash
   docker-compose down  # Keep data
   # or
   docker-compose down -v  # Delete all data
   ```

## 🔍 Troubleshooting

### GPU Not Detected
```bash
# Check on host
nvidia-smi

# Check in container
docker-compose exec vit-training nvidia-smi

# Verify Docker GPU support
docker run --rm --gpus all nvidia/cuda:11.8.0-runtime-ubuntu22.04 nvidia-smi
```

### Out of Memory
```bash
# Reduce batch size in notebook (32 → 16)
# Or increase Docker resource limits
```

### Port Already in Use
Edit `docker-compose.yml`:
```yaml
ports:
  - "9999:8888"  # Use port 9999 instead of 8888
```

### Container Won't Start
```bash
# Check logs
docker-compose logs vit-training

# Start with interactive shell to debug
docker-compose exec vit-training bash
```

## 📚 More Information

- See `DOCKER.md` for detailed documentation
- Read `requirements.txt` for all installed packages
- Check `docker-compose.yml` for service configuration

## 🎯 Next Steps

1. Start the services: `docker-compose up -d`
2. Open http://localhost:8888 in your browser
3. Open the Jupyter notebook and run training cells
4. Monitor training on http://localhost:6006
5. Save trained models (they'll be in `./models/`)

Enjoy training your ViT model with GPU acceleration! 🚀
