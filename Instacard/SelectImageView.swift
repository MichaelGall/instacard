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
            Text("")
            SelectedImagePreview(selectedImageState: viewModel.selectedImageState)
            Spacer()
            HStack {
                Button("Take Image") {
                    // Open camera to take a picture.
                }
                Spacer()
                SelectImageFromAlbum(viewModel: viewModel)
            }

            
        }
        .padding()
        .navigationTitle("Instacard")
    }
}

struct SelectImageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectImageView()
    }
}
