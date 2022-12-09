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

/**
 Models the text extraction process using ML computer vision and natural language model.
 */
class ExtractedTextModel: ObservableObject {
    // Property to store image which text will be extracted from.
    let cgImage: CGImage
    
    // Properties used to store extracted text from image after processing and
    // classification.
    var companies: [Prediction] = []
    var emails: [String] = []
    var jobs: [Prediction] = []
    var names: [Prediction] = []
    var phoneNumbers: [String] = []
    var websites: [String] = []
    var other: [String] = []
    
    // States of async process for extracting text from image.
    enum ExtractedTextState {
        case loading
        case success(ExtractionResult)
        case failure(Error)
    }
    
    // Types of errors encountered on failure to extract text from image.
    enum ExtractionError: Error {
        case extractionFailed
        case textNotFound
    }
    
    // A prediction.
    struct Prediction {
        let str: String
        let score: Double
    }
    
    // Track state of async process to extract text from image.
    @Published private(set) var extractedTextState: ExtractedTextState = .loading
    
    /**
     Initializes an ExtractedTextModel with an image that will be used for text extraction.
     */
    init(cgImage: CGImage) {
        self.cgImage = cgImage
    }
    
    /**
     Make a request via vision framework to extract text from an image.
     */
    public func startTextExtraction() {
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest(completionHandler: handleTextExtraction)
        do {
            try requestHandler.perform([request])
        } catch {
            extractedTextState = .failure(ExtractionError.extractionFailed)
        }
    }

    /**
     Handles text extraction.
     
     - Parameter request: The text extraction request
     - Parameter error: An error from text extraction
     */
    private func handleTextExtraction(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            extractedTextState = .failure(ExtractionError.textNotFound)
            return
        }
        let strings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }
        processStrings(strings: strings)
    }
    

    /**
     Processes strings extracted from an image in order to create an extraction result containing
     contact information that was embedded in the image.
     
     - Parameter strings: The strings extracted from an image.
     */
    private func processStrings(strings: [String]) {
        let mlModel = try? ContactClassifier2(configuration: MLModelConfiguration())
            .model
        let predictor = try? NLModel(mlModel: mlModel!)
        
        for str in strings {
            let didExtractContactInfo = extractContactInfo(str: str)
            if (!didExtractContactInfo) {
                predictContactInfo(str: str, predictor: predictor!)
            }
        }
        
        let result = ExtractionResult(companies: predictionsToStrings(predictions: companies),
                                      emails: emails,
                                      jobs: predictionsToStrings(predictions: jobs),
                                      names: predictionsToStrings(predictions: names),
                                      phoneNumbers: phoneNumbers,
                                      websites: websites,
                                      other: other)
        
        extractedTextState = .success(result)
    }
    
    /**
     Extracts contact information (i.e. email, phone number, website) by extracting it from a string.
     
     - Parameter str: The string to try and extract contact information from.
     
     - Returns: True if any contact information was extracted. False otherwise.
    */
    private func extractContactInfo(str: String) -> Bool {
        let email = str.extractedEmail
        let phoneNumber = str.extractedPhoneNumber
        let website = str.extractedWebsite
        
        if (!email.isEmpty) {
            emails.append(email)
            return true // extracted email
        }
        
        if (!phoneNumber.isEmpty) {
            phoneNumbers.append(phoneNumber)
            return true // extracted phone number
        }
        
        if (!website.isEmpty) {
            websites.append(website)
            return true // extracted website
        }
        
        return false // Failed to extract anything from string
    }
    
    /**
     Predicts what type of contact information (i.e. name, job, company) a string is by using a natural language model.
     
     - Parameter str: The string to try to predict what type of contact information it is.
     - Parameter predictor: The natural language model to use for prediction.
     */
    private func predictContactInfo(str: String, predictor: NLModel) {
        let hypotheses = predictor.predictedLabelHypotheses(for: str,
                                                            maximumCount: 10)
        for (label, score) in hypotheses {
            switch label {
            case "name":
                names.append(Prediction(str: str, score: score))
                break
            case "job":
                jobs.append(Prediction(str: str, score: score))
                break
            case "company":
                companies.append(Prediction(str: str, score: score))
                break
            default:
                other.append(str)
                break
            }
        }
    }
    
    /**
     Sorts predictions from highest to lowest and then convers them to strings such that the first
     string in the array is the best prediction.
     
     - Parameter predictions: The predictions.
     
     - Returns: The sorted string values of the predictions.
     */
    private func predictionsToStrings(predictions: [Prediction]) -> [String] {
        // Highest predictions first.
        let sortedPredictions = predictions.sorted {
            $0.score > $1.score
        }
        
        return sortedPredictions.map { $0.str }
    }
}
