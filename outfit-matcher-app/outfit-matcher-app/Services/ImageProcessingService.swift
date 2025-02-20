import UIKit
import CoreImage
import Vision
import Accelerate

class ImageProcessingService {
    static let shared = ImageProcessingService()
    private let context = CIContext()
    
    // Görüntüyü ML modeli için hazırla
    func prepareImageForML(_ image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        // 1. Gürültü azaltma
        guard let denoisedImage = applyNoiseReduction(to: ciImage) else { return nil }
        
        // 2. Kontrast iyileştirme
        guard let enhancedImage = applyContrastEnhancement(to: denoisedImage) else { return nil }
        
        // 3. Renk normalizasyonu
        guard let normalizedImage = applyColorNormalization(to: enhancedImage) else { return nil }
        
        // CIImage'i UIImage'e dönüştür
        guard let outputImage = context.createCGImage(normalizedImage, from: normalizedImage.extent) else { return nil }
        return UIImage(cgImage: outputImage)
    }
    
    // Gürültü azaltma filtresi
    private func applyNoiseReduction(to image: CIImage) -> CIImage? {
        let noiseReductionFilter = CIFilter(name: "CINoiseReduction")
        noiseReductionFilter?.setValue(image, forKey: kCIInputImageKey)
        noiseReductionFilter?.setValue(0.02, forKey: "inputNoiseLevel")
        noiseReductionFilter?.setValue(0.40, forKey: "inputSharpness")
        return noiseReductionFilter?.outputImage
    }
    
    // Kontrast iyileştirme
    private func applyContrastEnhancement(to image: CIImage) -> CIImage? {
        let contrastFilter = CIFilter(name: "CIColorControls")
        contrastFilter?.setValue(image, forKey: kCIInputImageKey)
        contrastFilter?.setValue(1.1, forKey: kCIInputContrastKey) // Hafif kontrast artışı
        contrastFilter?.setValue(0.0, forKey: kCIInputBrightnessKey) // Parlaklık sabit
        contrastFilter?.setValue(1.0, forKey: kCIInputSaturationKey) // Doygunluk sabit
        return contrastFilter?.outputImage
    }
    
    // Renk normalizasyonu
    private func applyColorNormalization(to image: CIImage) -> CIImage? {
        let colorControlsFilter = CIFilter(name: "CIColorControls")
        colorControlsFilter?.setValue(image, forKey: kCIInputImageKey)
        colorControlsFilter?.setValue(1.0, forKey: kCIInputSaturationKey)
        return colorControlsFilter?.outputImage
    }
    
    // Görüntüyü belirli bir boyuta yeniden boyutlandır
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        var format = vImage_CGImageFormat(
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            colorSpace: nil,
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
            version: 0,
            decode: nil,
            renderingIntent: .defaultIntent
        )
        
        var sourceBuffer = vImage_Buffer()
        var destinationBuffer = vImage_Buffer()
        
        guard let sourceImage = image.cgImage else { return nil }
        
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, sourceImage, vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        error = vImageBuffer_Init(&destinationBuffer, vImagePixelCount(targetSize.height), vImagePixelCount(targetSize.width), format.bitsPerPixel, vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        error = vImageScale_ARGB8888(&sourceBuffer, &destinationBuffer, nil, vImage_Flags(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }
        
        guard let resizedImage = try? destinationBuffer.createCGImage(format: format) else { return nil }
        
        free(sourceBuffer.data)
        free(destinationBuffer.data)
        
        return UIImage(cgImage: resizedImage)
    }
} 
