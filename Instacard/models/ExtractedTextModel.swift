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
    var recognizedEmails: [String] = []
    var recognizedNames: [String] = []
    var recognizedPhoneNumbers: [String] = []
    var recognizedWebsites: [String] = []
    var unrecognizedStrings: [String] = []
    
    enum ExtractedTextState {
        case loading
        case success(ExtractionResult)
        case failure(Error)
    }
    
    enum ExtractionError: Error {
        case extractionFailed
        case textNotFound
    }
    
    struct ExtractionResult {
        let emails: [String]
        let names: [String]
        let phoneNumbers: [String]
        let websites: [String]
        let other: [String]
    }
    
    @Published private(set) var extractedTextState: ExtractedTextState = .loading
    
    init(cgImage: CGImage) {
        self.cgImage = cgImage
    }
    
    public func startTextExtraction() {
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
        processRecognizedStrings(recognizedStrings: recognizedStrings)
    }
    
    private func processRecognizedStrings(recognizedStrings: [String]) {
        for recognizedString in recognizedStrings {
            // TODO: Finish this logic
            // if (recognizedString looks like an email) {
            //      recognizedEmails.append(recognizedString)
            // } else if (recognizedString looks like a phone number) {
            //      recognizedPhoneNumbers.append(recognizedString)
            // } else if (recognizedString looks like a website) {
            //      recognizedWebsites.append(recognizedString) {
            // } else if (recognizedString looks likes a name) {
            //      recognizedNames.append(recognizedName)
            // } else {
            //      unrecognizedStrings.append(recognizedString)
            // }
            
            // TODO: Remove this line after above commented-out logic is finished
            unrecognizedStrings.append(recognizedString)
        }
        let extractionResult = ExtractionResult(emails: recognizedEmails, names: recognizedNames, phoneNumbers: recognizedPhoneNumbers, websites: recognizedWebsites, other: unrecognizedStrings)
        extractedTextState = .success(extractionResult)
    }
}
