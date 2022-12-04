//
//  SelectImageInstructionCardView.swift
//  Instacard
//
//  Created by Nick Kenyeres on 2022-12-03.
//

import SwiftUI

struct SelectImageInstructionCardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Got a business card?")
                .font(.headline)
                .padding(.bottom)
            Text("Take a picture of a business card or select one from your photo library. Instacard will recognize and extract a contact.")
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .background(.white)
        .padding()
        
    }
}

struct SelectImageInstructionCardView_Previews: PreviewProvider {
    static var previews: some View {
        SelectImageInstructionCardView()
    }
}
