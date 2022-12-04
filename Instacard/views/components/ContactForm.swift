//
//  ContactForm.swift
//  Instacard
//
//  Created by Nick Kenyeres on 2022-12-04.
//

import SwiftUI

struct ContactForm: View {
    let extractionResult: ExtractedTextModel.ExtractionResult
    
    @State private var email: String
    @State private var phoneNumber: String
    @State private var website: String
    
    init(extractionResult: ExtractedTextModel.ExtractionResult) {
        self.extractionResult = extractionResult
        
        email = extractionResult.suggestedEmail()
        phoneNumber = extractionResult.suggestedPhoneNumber()
        website = extractionResult.suggestedWebsite()
    }
    
    var body: some View {
        Form {
            Section(header: Text("Email")) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .padding(.vertical, 10)
            }
            Section(header: Text("Phone number")) {
                TextField("Phone number", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .padding(.vertical, 10)
            }
            Section(header: Text("website")) {
                TextField("Website", text: $website)
                    .keyboardType(.URL)
                    .padding(.vertical, 10)
            }
        }
        .padding(20)
    }
}
