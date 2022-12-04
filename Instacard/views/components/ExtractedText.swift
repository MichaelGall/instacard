//
//  ExtractedTextView.swift
//  Instacard
//
//  Created by Nick Kenyeres on 2022-12-03.
//

import SwiftUI

struct ExtractedText: View {
    let extractedTextState: ExtractedTextModel.ExtractedTextState
    
    var body: some View {
        switch extractedTextState {
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
        case .success(let extractionResult):
            ForEach(extractionResult.other, id: \.self) { otherString in
                Text(otherString)
            }
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
