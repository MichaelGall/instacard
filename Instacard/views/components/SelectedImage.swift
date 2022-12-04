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
