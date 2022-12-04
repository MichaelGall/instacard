//
//  ExtractedTextView.swift
//  Instacard
//
//  Created by Nick Kenyeres on 2022-12-03.
//

import SwiftUI

struct ExtractedTextView: View {
    let extractedTextState: ExtractedTextModel.ExtractedTextState
    
    var body: some View {
        switch extractedTextState {
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
        case .success(let recognizedStrings):
            ForEach(recognizedStrings, id: \.self) { recognizedString in
                Text(recognizedString)
            }
        case .failure:
            Image(systemName: "exclationmark.triangle.fill")
                .font(.system(size: 80))
                .foregroundColor(.black)
        }
    }
}

struct ExtractedTextView_Previews: PreviewProvider {
    static var previews: some View {
        ExtractedTextView(extractedTextState: ExtractedTextModel.ExtractedTextState.loading)
    }
}
