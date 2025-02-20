import SwiftUI

struct ContentView: View {
    @StateObject private var imageCaptureService = ImageCaptureService()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Ana görüntü alanı
                if let image = imageCaptureService.selectedImage {
                    GeometryReader { geometry in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: min(geometry.size.width, 500),
                                   maxHeight: min(geometry.size.height * 0.7, 700))
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .ignoresSafeArea()
                    }
                } else {
                    Color.black
                        .ignoresSafeArea()
                    Image(systemName: "camera.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.gray)
                }
                
                // Kontrol butonları
                VStack {
                    Spacer()
                    HStack(spacing: 20) {
                        Button(action: { imageCaptureService.captureImage(from: .camera) }) {
                            Label("Fotoğraf Çek", systemImage: "camera")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                        }
                        
                        Button(action: { imageCaptureService.captureImage(from: .photoLibrary) }) {
                            Label("Galeriden Seç", systemImage: "photo.on.rectangle")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $imageCaptureService.isImagePickerPresented) {
                ImagePicker(
                    sourceType: imageCaptureService.imageSource == .camera ? .camera : .photoLibrary,
                    onImageSelected: { image in
                        imageCaptureService.processImage(image)
                    }
                )
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
} 