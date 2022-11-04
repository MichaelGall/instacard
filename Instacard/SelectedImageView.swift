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
        case .success(let image):
            image.resizable()
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
        case .empty:
            Image(systemName: "photo")
                .font(.system(size: 80))
                .foregroundColor(.black)
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
            Text("Select Image")
        }
        .buttonStyle(.borderless)
    }
}
