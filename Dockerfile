# Use official PyTorch CUDA image as base
FROM pytorch/pytorch:2.0.1-cuda11.8-cudnn8-runtime

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy project files
COPY Food101_pytorch_vit_effnet.ipynb .
COPY helper_pytorch/ ./helper_pytorch/
COPY .gitignore .

# Create directories for data, models, and outputs
RUN mkdir -p data models outputs logs

# Expose Jupyter port
EXPOSE 8888

# Expose Gradio port (for the demo app)
EXPOSE 7860

# Set environment variables
ENV JUPYTER_ENABLE_LAB=yes
ENV PYTHONUNBUFFERED=1

# Default command: start Jupyter Lab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
