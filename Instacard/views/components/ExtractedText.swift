//
//  ExtractedTextView.swift
//  Instacard
//

import SwiftUI

/** Shows contact extracted from app and provides user with ability to edit/save.  */
struct ExtractedText: View {
    let extractedTextState: ExtractedTextModel.ExtractedTextState
        
    var body: some View {
        switch extractedTextState {
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
        case .success(let extractionResult):
            VStack {
                ContactForm(extractionResult: extractionResult)
            }
            .background(Color(UIColor.secondarySystemBackground))
        case .failure:
            Image(systemName: "exclationmark.triangle.fill")
                .font(.system(size: 80))
                .foregroundColor(.black)
        }
    }
}

struct ExtractedText_Previews: PreviewProvider {
    static var previews: some View {
        ExtractedText(extractedTextState: ExtractedTextModel.ExtractedTextState.loading)
    }
}
