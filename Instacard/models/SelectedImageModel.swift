//
//  ImageModel.swift
//  Instacard
//
//  Adapted from Apple's sample code: Bringing Photos picker to your SwiftUI app
//  see: https://developer.apple.com/documentation/photokit/bringing_photos_picker_to_your_swiftui_app
//

import SwiftUI
import PhotosUI
import CoreTransferable

/**
 Models the async process of selecting an image from the photo picker.
 */
@MainActor
class SelectedImageModel: ObservableObject {
    enum SelectedImageState {
        case empty
        case loading(Progress)
        case success(Image, CGImage)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct SelectedImage: Transferable {
        let image: Image
        let cgImage: CGImage
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                
                guard let cgImage = uiImage.cgImage else {
                    throw TransferError.importFailed
                }
                return SelectedImage(image: image, cgImage: cgImage)
            }
        }
    }
    
    @Published private(set) var selectedImageState: SelectedImageState = .empty
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                selectedImageState = .loading(progress)
            } else {
                selectedImageState = .empty
            }
        }
    }
    // Michael Gall:
    // Handles UIImage selection from camera instead of photopicker
    @Published var uiImageSelection: UIImage? = nil {
        didSet {
            if let uiImageSelection {
                selectedImageState = .success(Image(uiImage: uiImageSelection), uiImageSelection.cgImage!)
            } else {
                selectedImageState = .empty
            }
        }
    }
    
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: SelectedImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected image.")
                    return
                }
                switch result {
                case .success(let selectedImage?):
                    self.selectedImageState = .success(selectedImage.image, selectedImage.cgImage)
                case .success(nil):
                    self.selectedImageState = .empty
                case .failure(let error):
                    self.selectedImageState = .failure(error)
                }
            }
        }
    }
}
