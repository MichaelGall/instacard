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
        var emailIndex = 0
        
        let names: [String]
        
        let phoneNumbers: [String]
        var phoneNumberIndex = 0
        
        let websites: [String]
        var websiteIndex = 0
        
        let other: [String]
        
        func suggestedEmail() -> String {
            if emails.isEmpty {
                return ""
            }
            return emails[emailIndex]
        }
        
        mutating func nextSuggestedEmail() -> String {
            if (emailIndex < emails.count - 1) {
                emailIndex += 1
            } else {
                emailIndex = 0
            }
            return suggestedEmail()
        }
        
        func suggestedPhoneNumber() -> String {
            if phoneNumbers.isEmpty {
                return ""
            }
            return phoneNumbers[phoneNumberIndex]
        }
        
        mutating func nextSuggestedPhoneNumber() -> String {
            if (phoneNumberIndex < phoneNumbers.count - 1) {
                phoneNumberIndex += 1
            } else {
                phoneNumberIndex = 0
            }
            return suggestedPhoneNumber()
        }
        
        func suggestedWebsite() -> String {
            if websites.isEmpty {
                return ""
            }
            return websites[websiteIndex]
        }
        
        mutating func nextSuggestedWebsite() -> String {
            if (websiteIndex < websites.count - 1) {
                websiteIndex += 1
            } else {
                websiteIndex = 0
            }
            return suggestedWebsite()
        }
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
            if recognizedString.hasEmail {
                recognizedEmails.append(recognizedString.extractedEmail)
            } else if recognizedString.hasPhoneNumber {
                recognizedPhoneNumbers.append(recognizedString.extractedPhoneNumber)
            } else if recognizedString.hasWebsite {
                recognizedWebsites.append(recognizedString.extractedWebsite)
            } else {
                unrecognizedStrings.append(recognizedString)
            }
        }
        let extractionResult = ExtractionResult(emails: recognizedEmails, names: recognizedNames, phoneNumbers: recognizedPhoneNumbers, websites: recognizedWebsites, other: unrecognizedStrings)
        extractedTextState = .success(extractionResult)
    }
}
