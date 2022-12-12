//
//  ContentView.swift
//  Instacard
//

import SwiftUI
import PhotosUI

/** View to corrdinate getting an image  from which to extract the contact. */
struct SelectImageView: View {
    @StateObject var viewModel = SelectedImageModel()
    // "selected" image by camera
    @State private var image = UIImage()
    // Whether to show the photo taking view or not
    @State private var showPhotoTaker = false
    
    var body: some View {
        VStack {
            SelectedImagePreview(selectedImageState: viewModel.selectedImageState)
                .frame(maxHeight: .infinity)
            VStack {
                // Taking an image
                Button {
                    showPhotoTaker = true
                } label: {
                    HStack {
                        Image(systemName: "camera")
                        Text("Take photo")
                            .frame(maxWidth: .infinity)
                            .offset(x: -20, y: 0) // Offset by icon width so text is centered
                    }
                }
                .buttonStyle(.bordered)
                .sheet(isPresented: $showPhotoTaker) {
                    SelectImageByTaking(viewModel: viewModel, selectedImage: $image)
                
                }
                // Album images
                SelectImageFromAlbum(viewModel: viewModel)
            }
        }
        .padding()
        .navigationTitle("Business Card")
    }
}

struct SelectImageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectImageView()
    }
}
