//
//  ContentView.swift
//  Instacard
//
//  Created by Michael Gall on 2022-11-02.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Instacard!")
            Button("Take Image") {
                // Open camera to take a picture.
            }
            Button("Load Image") {
                // Load an image from the album.
            }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
