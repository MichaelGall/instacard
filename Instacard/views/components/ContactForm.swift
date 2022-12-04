//
//  ContactForm.swift
//  Instacard
//
//  Created by Nick Kenyeres on 2022-12-04.
//

import SwiftUI

struct ContactForm: View {
    let extractionResult: ExtractedTextModel.ExtractionResult
    
    @State private var name: String
    @State private var title: String
    @State private var company: String
    @State private var email: String
    @State private var phoneNumber: String
    @State private var website: String
    
    @State private var nameIndex = 0
    @State private var titleIndex = 0
    @State private var companyIndex = 0
    
    init(extractionResult: ExtractedTextModel.ExtractionResult) {
        self.extractionResult = extractionResult
        
        name = extractionResult.suggestedName()
        title = extractionResult.suggestedTitle()
        company = extractionResult.suggestedCompany()
        email = extractionResult.suggestedEmail()
        phoneNumber = extractionResult.suggestedPhoneNumber()
        website = extractionResult.suggestedWebsite()
    }
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $name)
                    .padding(.vertical, 10)
                if extractionResult.other.count > 1 {
                    Button {
                        name = anotherName()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Try another")
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
            Section(header: Text("Title")) {
                TextField("Title", text: $title)
                    .padding(.vertical, 10)
                if extractionResult.other.count > 1 {
                    Button {
                        title = anotherTitle()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Try another")
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
            Section(header: Text("Company")) {
                TextField("Company", text: $company)
                    .padding(.vertical, 10)
                if extractionResult.other.count > 1 {
                    Button {
                        company = anotherCompany()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Try another")
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
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
    
    private func anotherName() -> String {
        if extractionResult.other.count == 0 {
            return ""
        } else if (nameIndex < extractionResult.other.count - 1) {
            nameIndex = nameIndex + 1
        } else {
            nameIndex = 0
        }
        return extractionResult.other[nameIndex]
    }
    
    private func anotherTitle() -> String {
        if extractionResult.other.count == 0 {
            return ""
        } else if (titleIndex < extractionResult.other.count - 1) {
            titleIndex = titleIndex + 1
        } else {
            titleIndex = 0
        }
        return extractionResult.other[titleIndex]
    }
    
    private func anotherCompany() -> String {
        if extractionResult.other.count == 0 {
            return ""
        } else if (companyIndex < extractionResult.other.count - 1) {
            companyIndex = companyIndex + 1
        } else {
            companyIndex = 0
        }
        return extractionResult.other[companyIndex]
    }
}
