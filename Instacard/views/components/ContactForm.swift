//
//  ContactForm.swift
//  Instacard
//
//  Created by Nick Kenyeres on 2022-12-04.
//

import SwiftUI

struct ContactForm: View {
    let extractionResult: ExtractionResult
    
    @State private var name: String
    @State private var job: String
    @State private var company: String
    @State private var email: String
    @State private var phoneNumber: String
    @State private var website: String
    
    @State private var nameIndex = 0
    @State private var titleIndex = 0
    @State private var companyIndex = 0
    
    init(extractionResult: ExtractionResult) {
        self.extractionResult = extractionResult
        
        name = extractionResult.suggestName()
        job = extractionResult.suggestJob()
        company = extractionResult.suggestCompany()
        email = extractionResult.suggestEmail()
        phoneNumber = extractionResult.suggestPhoneNumber()
        website = extractionResult.suggestWebsite()
    }
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $name)
                if extractionResult.names.count > 1 {
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
            Section(header: Text("Job Title")) {
                TextField("Job Title", text: $job)
                if extractionResult.jobs.count > 1 {
                    Button {
                        job = anotherTitle()
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
                if extractionResult.companies.count > 1 {
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
            }
            Section(header: Text("Phone number")) {
                TextField("Phone number", text: $phoneNumber)
                    .keyboardType(.phonePad)
            }
            Section(header: Text("website")) {
                TextField("Website", text: $website)
                    .keyboardType(.URL)
            }
        }
        .padding(20)
    }
    
    private func anotherName() -> String {
        if extractionResult.names.count == 0 {
            return ""
        } else if (nameIndex < extractionResult.names.count - 1) {
            nameIndex = nameIndex + 1
        } else {
            nameIndex = 0
        }
        return extractionResult.names[nameIndex]
    }
    
    private func anotherTitle() -> String {
        if extractionResult.jobs.count == 0 {
            return ""
        } else if (titleIndex < extractionResult.jobs.count - 1) {
            titleIndex = titleIndex + 1
        } else {
            titleIndex = 0
        }
        return extractionResult.jobs[titleIndex]
    }
    
    private func anotherCompany() -> String {
        if extractionResult.companies.count == 0 {
            return ""
        } else if (companyIndex < extractionResult.companies .count - 1) {
            companyIndex = companyIndex + 1
        } else {
            companyIndex = 0
        }
        return extractionResult.companies[companyIndex]
    }
}
