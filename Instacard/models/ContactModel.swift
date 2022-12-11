//
//  ContactModel.swift
//  Instacard
//
//  Created by Nick Kenyeres on 2022-12-11.
//

import Foundation
import Contacts

/**
 Models the process of saving a contact.
 
 Based on: https://developer.apple.com/documentation/contacts
 */
struct ContactModel {
    /** Full name of contact (i.e. given and surname). */
    let fullName: String
    
    /** Job title of contact. */
    let jobTitle: String
    
    /** Organization contact belongs to. */
    let organizationName: String
    
    /** Email address of contact or organization contact belongs to. */
    let emailAddress: String
    
    /** Phone number of contact or organization contact belongs to. */
    let phoneNumber: String
    
    /** Website of contact or organization contact belongs to. */
    let urlAddress: String
    
    /** Read-only computed property to get given name of contact. */
    var givenName: String {
        return fromFullName(extract: "givenName")
    }
    
    /** Read-only computed property to surname of contact. */
    var familyName: String {
        return fromFullName(extract: "familyName")
    }
    
    /** Read-only computed property to get label (i.e. "home" or "work") for value. */
    var valueLabel: String {
        return organizationName.isEmpty && jobTitle.isEmpty
            ? CNLabelHome : CNLabelWork
    }
    
    /**
     Save a contact to the user's contacts store.
     
     - Parameters handleCompletion: Closure to be invoked on completion. Passed true if successful; false otherwise.
     */
    func save(handleCompletion: ((_: Bool) -> Void)) {
        let contact = CNMutableContact()
        
        contact.givenName = givenName
        contact.familyName = familyName
        contact.jobTitle = jobTitle
        contact.organizationName = organizationName
        
        if (!emailAddress.isEmpty) {
            contact.emailAddresses = [
                CNLabeledValue(label: valueLabel,
                               value: emailAddress as NSString)
            ]
        }
        
        if (!phoneNumber.isEmpty) {
            contact.phoneNumbers = [
                CNLabeledValue(label: valueLabel,
                               value: CNPhoneNumber(stringValue: phoneNumber))
            ]
        }
        
        if (!urlAddress.isEmpty) {
            contact.urlAddresses = [
                CNLabeledValue(label: valueLabel,
                               value: urlAddress as NSString)
            ]
        }
        
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        
        do {
            try store.execute(saveRequest)
            handleCompletion(true)
        } catch {
            print("Saving contact failed, error: \(error)")
            handleCompletion(false)
        }
    }
    
    /**
     Get part of a name from the full name.
     
     - Parameter extract: The part of the full name to extract.
     
     - Returns: The extracted part of the name or an empty string if not able to extract.
     */
    private func fromFullName(extract: String) -> String {
        guard extract == "familyName" || extract == "givenName" else {
            return ""
        }
        
        let nameParts = fullName.components(separatedBy: .whitespaces)
        
        guard !nameParts.isEmpty else {
            return ""
        }
        
        // Assume given name is first part of the name.
        if (extract == "givenName") {
            return nameParts[0]
        }
        
        // Assume family name is everything after the given name.
        guard nameParts.count > 1 else {
            return ""
        }
        var familyName = ""
        for (index, namePart) in nameParts.enumerated() {
            guard index > 0 else {
                continue
            }
            familyName = familyName + namePart + " "
        }
        return familyName.trimmingCharacters(in: .whitespaces)
    }
}
