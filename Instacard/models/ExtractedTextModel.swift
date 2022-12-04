//
//  ExtractableImageModel.swift
//  Instacard
//
//  Created by Nick Kenyeres on 2022-12-03.
//

import Foundation
import PhotosUI
import Vision

class ExtractedTextModel: ObservableObject {
    let cgImage: CGImage
    
    enum ExtractedTextState {
        case loading
        case success([String])
        case failure(Error)
    }
    
    enum ExtractionError: Error {
        case extractionFailed
        case textNotFound
    }
    
    @Published private(set) var extractedTextState: ExtractedTextState = .loading
    
    init(cgImage: CGImage) {
        self.cgImage = cgImage
        extractText()
    }
    
    private func extractText() {
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        do {
            try requestHandler.perform([request])
        } catch {
            extractedTextState = .failure(ExtractionError.extractionFailed)
        }
    }
    
    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            extractedTextState = .failure(ExtractionError.textNotFound)
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }
        extractedTextState = .success(recognizedStrings)
    }
}
