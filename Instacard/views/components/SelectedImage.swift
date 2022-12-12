//
//  SelectImageFromAlbumView.swift
//  Instacard
//
//  Created by Nick Kenyeres on 2022-11-04.
//

import SwiftUI
import PhotosUI

struct SelectedImage: View {
    let selectedImageState: SelectedImageModel.SelectedImageState
    
    var body: some View {
        switch selectedImageState {
        case .success(let image, let cgImage):
            VStack {
                image.resizable()
                NavigationLink {
                    ExtractTextView(cgImage: cgImage)
                } label: {
                    Image(systemName: "rectangle.and.text.magnifyingglass")
                    Text("Extract text")
                }
                .buttonStyle(.borderedProminent)
            }
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
        case .empty:
            VStack {
                Image(systemName: "photo")
                    .font(.system(size: 80))
                    .foregroundColor(.black)
                SelectImageInstructionCard()
            }

        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 80))
                .foregroundColor(.black)
        }
    }
}

struct SelectedImagePreview: View {
    let selectedImageState: SelectedImageModel.SelectedImageState
    
    var body: some View {
        SelectedImage(selectedImageState: selectedImageState)
            .scaledToFit()
            .clipShape(Rectangle())
    }
}

struct SelectImageFromAlbum: View {
    @ObservedObject var viewModel: SelectedImageModel
    
    var body: some View {
        PhotosPicker(selection: $viewModel.imageSelection, matching: .images, photoLibrary: .shared()) {
            Image(systemName: "photo")
            Text("Select image")
                .frame(maxWidth: .infinity)
                .offset(x: -20, y: 0)  // Offset by icon width so text is centered
        }
        .buttonStyle(.bordered)
    }
}

// For taking images, rather than picking from a user's album.
struct SelectImageByTaking: View {
    @ObservedObject var viewModel: SelectedImageModel
    @Binding var selectedImage: UIImage
    
    var body: some View {
        ImagePicker(viewModel: viewModel, selectedImage: self.$selectedImage)
    }
}

// Michael Gall:
// Adapted an "ImagePicker" for taking photos from a camera, based off this.
// https://designcode.io/swiftui-advanced-handbook-imagepicker

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: SelectedImageModel
    @Binding var selectedImage: UIImage
    var photoSource: UIImagePickerController.SourceType = .camera
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = photoSource
        imagePicker.delegate = context.coordinator

        return imagePicker
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.presentationMode.wrappedValue.dismiss()
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                // Add the selected image to the main view model, and update the selection
                parent.selectedImage = image
                parent.viewModel.uiImageSelection = image
                
            }
        }
    }
    
    
}
