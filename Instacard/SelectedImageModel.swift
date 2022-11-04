//
//  ImageModel.swift
//  Instacard
//
//  Created by Nick Kenyeres on 2022-11-03.
//
//  Adapted from Apple's sample code: Bringing Photos picker to your SwiftUI app
//  see: https://developer.apple.com/documentation/photokit/bringing_photos_picker_to_your_swiftui_app
//

import SwiftUI
import PhotosUI
import CoreTransferable

@MainActor
class SelectedImageModel: ObservableObject {
    enum SelectedImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct SelectedImage: Transferable {
        let image: Image
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
            #if canImport(AppKit)
                guard let nsImage = NSImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(nsImage: nsImage)
                return SelectedImage(image: image)
            #elseif canImport(UIKit)
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                return SelectedImage(image: image)
            #else
                throw TransferError.importFailed
            #endif
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
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: SelectedImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected image.")
                    return
                }
                switch result {
                case .success(let selectedImage?):
                    self.selectedImageState = .success(selectedImage.image)
                case .success(nil):
                    self.selectedImageState = .empty
                case .failure(let error):
                    self.selectedImageState = .failure(error)
                }
            }
        }
    }
}
