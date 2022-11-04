//
//  ContentView.swift
//  Instacard
//
//  Created by Michael Gall on 2022-11-02.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject var viewModel = SelectedImageModel()
    
    var body: some View {
        VStack {
            SelectedImagePreview(selectedImageState: viewModel.selectedImageState)
            Text("Instacard!")
            Button("Take Image") {
                // Open camera to take a picture.
            }
            SelectImageFromAlbum(viewModel: viewModel)
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
