//
//  ContentView.swift
//  Instacard
//
//  Created by Michael Gall on 2022-11-02.
//

import SwiftUI
import PhotosUI

struct SelectImageView: View {
    @StateObject var viewModel = SelectedImageModel()
    
    var body: some View {
        VStack {
            SelectedImagePreview(selectedImageState: viewModel.selectedImageState)
                .frame(maxHeight: .infinity)
            VStack {
                Button {
                    print("'Take Photo' button clicked")
                } label: {
                    HStack {
                        Image(systemName: "camera")
                        Text("Take photo")
                            .frame(maxWidth: .infinity)
                            .offset(x: -20, y: 0) // Offset by icon width so text is centered
                    }
                }
                .buttonStyle(.bordered)
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
