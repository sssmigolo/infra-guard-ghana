# MIT License - Copyright (c) 2026 InfraGuard AI Contributors
# InfraGuard AI - Road Defect Detection CNN Training Notebook
# ============================================================
# This script trains a Convolutional Neural Network to detect road defects
# (potholes, cracks, erosion, flooding) from photos taken by citizens
# and field technicians.
#
# Model Architecture: MobileNetV2 (transfer learning) → TFLite for on-device
# Dataset: Synthetic + public road defect datasets (RDD2022, etc.)
# Target: 94%+ accuracy on Ghana road conditions

# %% [markdown]
# # Road Defect Detection CNN
# ## InfraGuard AI - On-Device Computer Vision
# 
# This notebook trains a lightweight CNN for detecting road defects from
# smartphone photos. The model runs on-device via TensorFlow Lite for
# offline-first capability (critical for rural Ghana).

# %% Imports
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers, applications
from tensorflow.keras.preprocessing.image import ImageDataGenerator
import numpy as np
import os

print(f"TensorFlow version: {tf.__version__}")
print(f"GPU available: {tf.config.list_physical_devices('GPU')}")

# %% [markdown]
# ## 1. Dataset Preparation
# 
# We use a combination of:
# - **RDD2022**: Road Damage Dataset (public, 47k images)
# - **Synthetic Ghana data**: AI-generated road images for Ghana conditions
# - **Custom annotations**: Pothole, crack, erosion, flooding labels
#
# ### Ghana-Specific Considerations:
# - Red laterite roads (unpaved) common in Northern/Upper regions
# - Flooding patterns unique to Accra basin
# - Harmattan dust affecting image quality
# - Low-light conditions for night field work

# %% Dataset configuration
IMG_SIZE = 224  # MobileNetV2 input size
BATCH_SIZE = 32
NUM_CLASSES = 5  # good, pothole, crack, erosion, flooding
EPOCHS = 30

CLASS_NAMES = ['good', 'pothole', 'crack', 'erosion', 'flooding']

# Data augmentation for robustness to Ghana conditions
train_datagen = ImageDataGenerator(
    rescale=1./255,
    rotation_range=20,
    width_shift_range=0.2,
    height_shift_range=0.2,
    horizontal_flip=True,
    brightness_range=[0.6, 1.4],  # Handle varying light conditions
    zoom_range=0.2,
    fill_mode='nearest',
    validation_split=0.2,
)

# %% Generate synthetic dataset for demo
def generate_synthetic_dataset(num_samples=1000):
    """Generate synthetic training data for demonstration.
    In production, replace with real Ghana road images."""
    
    np.random.seed(42)
    X = np.random.rand(num_samples, IMG_SIZE, IMG_SIZE, 3).astype(np.float32)
    y = np.random.randint(0, NUM_CLASSES, num_samples)
    
    # Add class-specific patterns for realism
    for i in range(num_samples):
        if y[i] == 1:  # pothole - dark circular regions
            cx, cy = np.random.randint(60, 164, 2)
            r = np.random.randint(15, 40)
            yy, xx = np.ogrid[-cx:IMG_SIZE-cx, -cy:IMG_SIZE-cy]
            mask = xx**2 + yy**2 <= r**2
            X[i][mask] *= 0.3
        elif y[i] == 2:  # crack - dark lines
            for _ in range(np.random.randint(3, 8)):
                x1, x2 = sorted(np.random.randint(0, IMG_SIZE, 2))
                X[i, x1:x2, np.random.randint(0, IMG_SIZE), :] *= 0.2
        elif y[i] == 3:  # erosion - gradient dark edges
            X[i, :30, :, :] *= np.linspace(0.3, 1.0, 30).reshape(-1, 1, 1)
        elif y[i] == 4:  # flooding - blue-ish tint
            X[i, :, :, 2] = np.clip(X[i, :, :, 2] * 1.5, 0, 1)
    
    return X, tf.keras.utils.to_categorical(y, NUM_CLASSES)

X_train, y_train = generate_synthetic_dataset(800)
X_val, y_val = generate_synthetic_dataset(200)

print(f"Training samples: {X_train.shape[0]}")
print(f"Validation samples: {X_val.shape[0]}")
print(f"Class distribution: {np.argmax(y_train, axis=1).tolist()[:20]}...")

# %% [markdown]
# ## 2. Model Architecture
# 
# We use **MobileNetV2** as the backbone for:
# - Small model size (~14MB → ~4MB after TFLite quantization)
# - Fast inference on mobile devices (30ms on mid-range Android)
# - Proven accuracy on image classification tasks
# 
# ### Transfer Learning Strategy:
# 1. Load MobileNetV2 pretrained on ImageNet
# 2. Freeze base layers
# 3. Add custom classification head for 5 defect classes
# 4. Fine-tune top layers

# %% Build model
def build_model():
    """Build MobileNetV2-based road defect classifier."""
    
    base_model = applications.MobileNetV2(
        input_shape=(IMG_SIZE, IMG_SIZE, 3),
        include_top=False,
        weights='imagenet',
    )
    
    # Freeze base model
    base_model.trainable = False
    
    model = keras.Sequential([
        base_model,
        layers.GlobalAveragePooling2D(),
        layers.BatchNormalization(),
        layers.Dropout(0.3),
        layers.Dense(128, activation='relu'),
        layers.BatchNormalization(),
        layers.Dropout(0.2),
        layers.Dense(NUM_CLASSES, activation='softmax'),
    ])
    
    model.compile(
        optimizer=keras.optimizers.Adam(learning_rate=1e-3),
        loss='categorical_crossentropy',
        metrics=['accuracy'],
    )
    
    return model

model = build_model()
model.summary()

# %% [markdown]
# ## 3. Training

# %% Train
callbacks = [
    keras.callbacks.EarlyStopping(patience=5, restore_best_weights=True),
    keras.callbacks.ReduceLROnPlateau(factor=0.5, patience=3),
    keras.callbacks.ModelCheckpoint('road_defect_model_best.keras', save_best_only=True),
]

history = model.fit(
    X_train, y_train,
    validation_data=(X_val, y_val),
    epochs=EPOCHS,
    batch_size=BATCH_SIZE,
    callbacks=callbacks,
    verbose=1,
)

# %% [markdown]
# ## 4. Fine-tuning
# Unfreeze top layers of MobileNetV2 for domain adaptation

# %% Fine-tune
model.layers[0].trainable = True
for layer in model.layers[0].layers[:-30]:
    layer.trainable = False

model.compile(
    optimizer=keras.optimizers.Adam(learning_rate=1e-5),
    loss='categorical_crossentropy',
    metrics=['accuracy'],
)

history_ft = model.fit(
    X_train, y_train,
    validation_data=(X_val, y_val),
    epochs=10,
    batch_size=BATCH_SIZE,
    callbacks=callbacks,
    verbose=1,
)

# %% [markdown]
# ## 5. Convert to TFLite for On-Device Inference
# 
# Quantize for:
# - Smaller model size (14MB → ~4MB)
# - Faster inference on mobile ARM processors
# - Works offline without internet

# %% Convert to TFLite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
converter.target_spec.supported_types = [tf.float16]
tflite_model = converter.convert()

with open('road_defect_model.tflite', 'wb') as f:
    f.write(tflite_model)

print(f"TFLite model size: {len(tflite_model) / 1024 / 1024:.2f} MB")

# %% [markdown]
# ## 6. Inference Example
# 
# Simulate how the Flutter app will use this model:

# %% Inference
def predict_road_defect(image_path_or_array):
    """Run inference on a road image using the TFLite model."""
    
    interpreter = tf.lite.Interpreter(model_path='road_defect_model.tflite')
    interpreter.allocate_tensors()
    
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    
    if isinstance(image_path_or_array, str):
        img = tf.io.read_file(image_path_or_array)
        img = tf.image.decode_image(img, channels=3)
    else:
        img = tf.constant(image_path_or_array)
    
    img = tf.image.resize(img, [IMG_SIZE, IMG_SIZE])
    img = tf.cast(img, tf.float32) / 255.0
    img = tf.expand_dims(img, 0)
    
    interpreter.set_tensor(input_details[0]['index'], img.numpy())
    interpreter.invoke()
    
    output = interpreter.get_tensor(output_details[0]['index'])
    predicted_class = CLASS_NAMES[np.argmax(output)]
    confidence = float(np.max(output))
    
    return {
        'defect_type': predicted_class,
        'confidence': confidence,
        'all_scores': {c: float(s) for c, s in zip(CLASS_NAMES, output[0])},
    }

# Test with synthetic image
test_img = np.random.rand(IMG_SIZE, IMG_SIZE, 3).astype(np.float32)
result = predict_road_defect(test_img)
print(f"Prediction: {result['defect_type']} ({result['confidence']:.2%})")

# %% [markdown]
# ## Next Steps
# 
# 1. **Collect real Ghana road images** via the InfraGuard app
# 2. **Add MediaPipe** for real-time video detection
# 3. **Severity estimation** with depth estimation model
# 4. **Cost prediction** based on defect size and type
# 5. **Drone/satellite integration** for aerial road surveys
