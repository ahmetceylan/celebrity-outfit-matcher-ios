import SwiftUI
import PhotosUI

enum ImageSource {
    case camera
    case photoLibrary
}

class ImageCaptureService: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var isImagePickerPresented = false
    @Published var imageSource: ImageSource = .camera
    @Published var processedImage: UIImage?
    
    func captureImage(from source: ImageSource) {
        imageSource = source
        isImagePickerPresented = true
    }
    
    func processImage(_ image: UIImage) {
        // Görüntü yönünü düzelt
        let correctedImage = image.fixOrientation()
        
        // Görüntü boyutunu optimize et
        let maxDimension: CGFloat = 1024.0
        let scale = min(maxDimension / correctedImage.size.width, maxDimension / correctedImage.size.height)
        let targetSize = CGSize(
            width: correctedImage.size.width * scale,
            height: correctedImage.size.height * scale
        )
        
        // Görüntüyü yeniden boyutlandır
        guard let resizedImage = ImageProcessingService.shared.resizeImage(correctedImage, targetSize: targetSize) else {
            selectedImage = correctedImage
            return
        }
        
        // ML için görüntüyü hazırla
        if let processedMLImage = ImageProcessingService.shared.prepareImageForML(resizedImage) {
            selectedImage = resizedImage
            processedImage = processedMLImage
        } else {
            selectedImage = resizedImage
        }
    }
} 