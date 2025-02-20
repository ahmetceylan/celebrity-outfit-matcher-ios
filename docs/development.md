# Celebrity Outfit Matching App - Initial Development Steps

proje dosyası olarak bu dizindeki "outfit-matcher-app" dosyasını kullan ve 15+ yıl tecrübeli bir ios developer, mobil uygulama ve ML/AI mimarı olarak düşün. Son versiyon swift mimarisini kullan.

proje ile ilgili bir not: info.plist dosyası build hatasına sebep olduğu için onu ignore edebilirsin, ben manuel olarak gerekli izinleri gireceğim, sen sadece eklenmesi gereken izinleri bana listele

## 1. Camera Integration

### Requirements:

- Capture photos using the device camera.
- Select images from the gallery.
- Request necessary permissions for camera and storage access.
- Ensure efficient image handling to avoid memory issues.

### Recommended Free Tools & Libraries:

- **AVFoundation** (Native Swift framework for camera integration)
- **UIImagePickerController** (For selecting images from gallery)
- **PhotoKit** (For handling image permissions and storage efficiently)

### Implementation Steps:

1. Request camera and gallery permissions in `Info.plist`.
2. Use `UIImagePickerController` to allow photo capture and gallery selection.
3. Optimize image size before processing to improve performance.

## 2. Basic Image Processing

### Requirements:

- Resize images for efficient ML processing.
- Apply basic pre-processing like noise reduction and cropping.
- Convert images to a suitable format for ML inference.

### Recommended Free Tools & Libraries:

- **Core Image (CIImage)** (Native image processing in Swift)
- **Vision Framework** (For preprocessing images)
- **Accelerate Framework** (Optimized image processing using SIMD)

### Implementation Steps:

1. Convert `UIImage` to `CIImage` for further processing.
2. Resize the image to match ML model input requirements.
3. Apply basic preprocessing steps like color normalization.

## 3. ML Model Integration

### Requirements:

- Run on-device inference with a lightweight ML model.
- Optimize for fast execution with CoreML.
- Ensure the model is small to reduce storage and memory footprint.

### Recommended Free Tools & Libraries:

- **CoreML** (Apple’s on-device ML framework)
- **TensorFlow Lite** (Optimized ML models for mobile)
- **ML Kit by Google** (Lightweight and efficient ML models)

### Implementation Steps:

1. Choose a pre-trained model or train a custom one for outfit feature extraction.
2. Convert TensorFlow/PyTorch models to CoreML using `coremltools`.
3. Integrate CoreML with Swift and optimize performance with `VNCoreMLRequest`.

## 4. Style Info Extraction

### Requirements:

- Extract clothing features (color, pattern, type) using ML.
- Convert image features into a numerical style vector.
- Store and compare vectors efficiently.

### Recommended Free Tools & Libraries:

- **MediaPipe by Google** (Pre-trained models for clothing segmentation)
- **OpenCV** (For color and texture feature extraction)
- **FAISS (Facebook AI Similarity Search)** (For fast vector comparison)

### Implementation Steps:

1. Use MediaPipe to detect clothing regions in the image.
2. Extract color and texture features with OpenCV.
3. Convert extracted features into a normalized vector.
4. Store the vector locally for comparison with celebrity style vectors.
