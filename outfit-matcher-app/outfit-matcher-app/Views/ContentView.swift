import SwiftUI

struct ContentView: View {
    @StateObject private var imageCaptureService = ImageCaptureService()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let image = imageCaptureService.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(10)
                } else {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.gray)
                        .frame(height: 300)
                }
                
                HStack(spacing: 20) {
                    Button(action: { imageCaptureService.captureImage(from: .camera) }) {
                        Label("Fotoğraf Çek", systemImage: "camera")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: { imageCaptureService.captureImage(from: .photoLibrary) }) {
                        Label("Galeriden Seç", systemImage: "photo.on.rectangle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Kıyafet Fotoğrafı")
            .sheet(isPresented: $imageCaptureService.isImagePickerPresented) {
                ImagePicker(
                    sourceType: imageCaptureService.imageSource == .camera ? .camera : .photoLibrary,
                    onImageSelected: { image in
                        imageCaptureService.processImage(image)
                    }
                )
            }
        }
    }
}

#Preview {
    ContentView()
} 