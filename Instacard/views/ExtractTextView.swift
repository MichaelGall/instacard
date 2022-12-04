//
//  ExtractTextView.swift
//  Instacard
//
//  Created by Nick Kenyeres on 2022-12-03.
//

import SwiftUI

struct ExtractTextView: View {
    // Note:
    // I first tried to do this:
    // `@StateObject var viewModel = ExtractedTextModel(cgImage: cgImage)`
    //
    // However, I got a compiler error: Cannot use instance member 'cgImage'
    // within property initializer; property initializers run before 'self'
    // is available.
    //
    // As such, I needed to move the assignment into the initializer, i.e.
    // the init() method.
    @StateObject var viewModel: ExtractedTextModel
        
    init(cgImage: CGImage) {
        // I ran into some difficulty assigning the StateObject in the
        // initializer, but found someone had a similar issue, to which
        // I was able to adapt the solution.
        // See: https://github.com/QuickBirdEng/XUI/issues/5#issuecomment-803288313
        
        // In a nutshell, it was not possible to assign:
        // `self.viewModel = ExtractedTextModel(cgImage: cgImage)`
        //
        // This is becasue `self.view` is @StateObject is a property wrapper and
        // therefore the wrapper needs to be instantiated  instead.
        self._viewModel = StateObject(wrappedValue: ExtractedTextModel(cgImage: cgImage))
    }
    
    var body: some View {
        ExtractedText(extractedTextState: viewModel.extractedTextState)
            .onAppear(perform: viewModel.startTextExtraction)
            .navigationTitle("Extracted Contact")
    }
}

struct ExtractTextView_Previews: PreviewProvider {
    static var previews: some View {
        ExtractTextView(cgImage: UIImage(named: "sampleBusinessCard.jpg").unsafelyUnwrapped.cgImage!)
    }
}
