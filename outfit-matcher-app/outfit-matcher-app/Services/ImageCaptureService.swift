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
    
    func captureImage(from source: ImageSource) {
        imageSource = source
        isImagePickerPresented = true
    }
    
    func processImage(_ image: UIImage) {
        // Görüntü boyutunu optimize et (max 1024x1024)
        let maxDimension: CGFloat = 1024.0
        let scale = min(maxDimension / image.size.width, maxDimension / image.size.height)
        
        if scale < 1.0 {
            let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            selectedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        } else {
            selectedImage = image
        }
    }
} 