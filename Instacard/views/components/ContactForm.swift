//
//  ContactForm.swift
//  Instacard
//

import SwiftUI

/** Handles editing an extracted contact and saving it to the user's contacts. */
struct ContactForm: View {
    /** The result of extracting the contact from the image. */
    let extractionResult: ExtractionResult
    
    /** The result of adding the contact to the user's contacts. */
    struct ContactResult: Identifiable {
        var id: String
        let message: String
    }
    
    @State private var name: String
    @State private var job: String
    @State private var company: String
    @State private var email: String
    @State private var phoneNumber: String
    @State private var website: String
    
    @State private var nameIndex = 0
    @State private var titleIndex = 0
    @State private var companyIndex = 0
    
    @State private var contactResult: ContactResult?
    
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
        VStack {
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
            VStack {
                Button {
                    contactResult = nil
                    ContactModel(fullName: $name.wrappedValue,
                                 jobTitle: $job.wrappedValue,
                                 organizationName: $company.wrappedValue,
                                 emailAddress: $email.wrappedValue,
                                 phoneNumber: $phoneNumber.wrappedValue,
                                 urlAddress: $website.wrappedValue)
                    .save() { success in
                        if (success) {
                            contactResult = ContactResult(id: "Success",
                                                          message: "Contact was saved! You should see it in your Contacts app.")
                        } else {
                            contactResult = ContactResult(id: "Failed",
                                                          message: "Contact was not saved. Try again!")
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "person.text.rectangle")
                        Text("Save contact")
                            .frame(maxWidth: .infinity)
                            .offset(x: -20, y: 0) // Offset by icon width so text is centered
                    }
                }
                .buttonStyle(.bordered)
            }.padding(20)
        }
        .alert(item: $contactResult) { result in
            Alert(title: Text(result.id),
                  message: Text(result.message),
                  dismissButton: .default(Text("OK")))
        }
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
