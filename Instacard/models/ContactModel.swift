//
//  ContactModel.swift
//  Instacard
//
//  Created by Nick Kenyeres on 2022-12-11.
//

import UIKit
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
     
     This operates under the assumption that every substring separated by a space
     except the last one is part of the given name. The last string is the surname.
     In cases with multiple surnames, the surnames are assumed to be hyphenated
     and not separated by spaces.
     
     - Parameter get: The part of the full name to get.
     */
    private func fromFullName(extract: String) -> String {
        guard extract == "familyName" || extract == "givenName" else {
            return ""
        }
        
        let nameParts = fullName.components(separatedBy: .whitespaces)
        
        guard !nameParts.isEmpty else {
            return ""
        }
        
        // If there is only one part, assume it is the given name.
        if (nameParts.count == 1) {
            return extract == "givenName" ? nameParts[0] : ""
        }
        
        // Assume the last name part is the family name.
        if (extract == "familyName") {
            return nameParts[nameParts.count - 1]
        }
        
        // Assume everything but the last name part is the given name.
        var givenName = ""
        for (index, namePart) in nameParts.enumerated() {
            guard index < nameParts.count - 1 else {
                break
            }
            givenName = givenName + namePart + " "
        }
        return givenName.trimmingCharacters(in: .whitespaces)
    }
}
