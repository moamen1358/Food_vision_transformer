import gradio as gr
import torch
import torchvision
from pathlib import Path
from model import create_vit_model
from timeit import default_timer as timer
from typing import Tuple, Dict

# Setup
device = "cuda" if torch.cuda.is_available() else "cpu"

# Load model
print("Loading ViT model...")
model, transforms = create_vit_model(num_classes=100)
model = model.to(device)

# Load class names
class_names_path = Path(__file__).parent / "class_names.txt"
if class_names_path.exists():
    with open(class_names_path, "r") as f:
        class_names = [name.strip() for name in f.readlines()]
else:
    # Default CIFAR-100 classes if file not found
    class_names = [f"class_{i}" for i in range(100)]

# Load model weights if they exist
model_path = Path(__file__).parent / "models" / "vit_model.pth"
if model_path.exists():
    print(f"Loading weights from {model_path}")
    model.load_state_dict(torch.load(model_path, map_location=device))
else:
    print("⚠️  No model weights found. Using pretrained weights only.")

model.eval()

# Prediction function
def predict(image) -> Tuple[Dict, float]:
    """Predict on image."""
    start_time = timer()
    
    # Transform image
    image_tensor = transforms(image).unsqueeze(0).to(device)
    
    # Predict
    with torch.inference_mode():
        logits = model(image_tensor)
        probs = torch.softmax(logits, dim=1)
    
    # Create prediction dict
    pred_dict = {class_names[i]: float(probs[0][i]) for i in range(len(class_names))}
    
    # Time
    pred_time = round(timer() - start_time, 4)
    
    return pred_dict, pred_time

# Gradio interface
title = "🍔 ViT Food Vision"
description = "Classify 100 different food categories using Vision Transformer (ViT-B/16)"
examples_dir = Path(__file__).parent / "examples"

examples = []
if examples_dir.exists():
    examples = [[str(img)] for img in list(examples_dir.glob("*.jpg"))[:5]]

demo = gr.Interface(
    fn=predict,
    inputs=gr.Image(type="pil", label="Upload Food Image"),
    outputs=[
        gr.Label(num_top_classes=5, label="Predictions"),
        gr.Number(label="Prediction Time (s)")
    ],
    examples=examples if examples else None,
    title=title,
    description=description,
    theme="soft"
)

if __name__ == "__main__":
    demo.launch(server_name="0.0.0.0", server_port=7860, share=False)
