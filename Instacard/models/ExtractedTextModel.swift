//
//  ExtractableImageModel.swift
//  Instacard
//
//  Created by Nick Kenyeres on 2022-12-03.
//

import Foundation
import PhotosUI
import Vision
import NaturalLanguage
import CoreML

class ExtractedTextModel: ObservableObject {
    let cgImage: CGImage
    var recognizedCompanies: [String] = []
    var recognizedEmails: [String] = []
    var recognizedJobs: [String] = []
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
        let companies: [String]
        let emails: [String]
        let jobs: [String]
        let names: [String]
        let phoneNumbers: [String]
        let websites: [String]
        let other: [String]
        
        func suggestedEmail() -> String {
            if emails.isEmpty {
                return ""
            }
            return emails[0]
        }
        
        func suggestedPhoneNumber() -> String {
            if phoneNumbers.isEmpty {
                return ""
            }
            return phoneNumbers[0]
        }
        
        func suggestedWebsite() -> String {
            if websites.isEmpty {
                return ""
            }
            return websites[0]
        }
        
        func suggestedName() -> String {
            if !names.isEmpty {
                return names[0]
            } else if !other.isEmpty {
                return other[0]
            }
            return ""
        }
        
        func suggestedTitle() -> String {
            if !jobs.isEmpty {
                return jobs[0]
            } else if !other.isEmpty {
                return other[0]
            }
            return ""
        }
        
        func suggestedCompany() -> String {
            if !companies.isEmpty {
                return companies[0]
            } else if !other.isEmpty {
                return other[0]
            }
            return ""
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
        let mlModel = try? ContactClassifier(configuration: MLModelConfiguration()).model
        let contactPredictor =  try? NLModel(mlModel: mlModel!)
        
        for recognizedString in recognizedStrings {
            let extractedEmail = recognizedString.extractedEmail
            let extractedWebsite = recognizedString.extractedWebsite
            let extractedPhoneNumber = recognizedString.extractedPhoneNumber
            
            if (!extractedEmail.isEmpty) {
                recognizedEmails.append(extractedEmail)
            } else if (!extractedWebsite.isEmpty) {
                recognizedWebsites.append(extractedWebsite)
            } else if (!extractedPhoneNumber.isEmpty) {
                recognizedPhoneNumbers.append(extractedPhoneNumber)
            } else {
                let label = contactPredictor?.predictedLabel(for: recognizedString)
                switch label {
                case "name":
                    recognizedNames.append(recognizedString)
                    break
                case "job":
                    recognizedJobs.append(recognizedString)
                    break
                case "company":
                    recognizedCompanies.append(recognizedString)
                    break
                default:
                    unrecognizedStrings.append(recognizedString)
                    break
                }
            }
        }
        let extractionResult = ExtractionResult(companies: recognizedCompanies,
                                                emails: recognizedEmails,
                                                jobs: recognizedJobs,
                                                names: recognizedNames,
                                                phoneNumbers: recognizedPhoneNumbers,
                                                websites: recognizedWebsites,
                                                other: unrecognizedStrings)
        extractedTextState = .success(extractionResult)
    }
}
