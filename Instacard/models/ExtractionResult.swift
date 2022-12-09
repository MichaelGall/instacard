//
//  ExtractedTextState.swift
//  Instacard
//
//  Created by Nick Kenyeres on 2022-12-09.
//

import Foundation

/**
 Models the result of text extraction and classification from an image.
 */
struct ExtractionResult {
    // The extracted company names in order of most likely
    // company name first.
    let companies: [String]
    
    // The extracted emails in order of first appearance.
    let emails: [String]
    
    // The extracted job titles in order of most likely
    // job title first.
    let jobs: [String]
    
    // The extracted names in order of most likely name
    // first.
    let names: [String]
    
    // The extracted phone numbers in order of first
    // appearance.
    let phoneNumbers: [String]
    
    // The extracted websites in order of first appearance.
    let websites: [String]
    
    // Other extracted strings that could not be classified.
    let other: [String]
    
    /**
     Suggest the most ikely company name for the extracted contact.
     */
    func suggestCompany() -> String {
        if !companies.isEmpty {
            return companies[0]
        }
        return ""
    }
    
    /**
     Suggest the most likely email address for the contact.
     */
    func suggestEmail() -> String {
        if emails.isEmpty {
            return ""
        }
        return emails[0]
    }
    
    /**
     Suggest the most likely job title for the contact.
     */
    func suggestJob() -> String {
        if !jobs.isEmpty {
            return jobs[0]
        }
        return ""
    }
    
    /**
     Suggest the most likely name for the contact.
     */
    func suggestName() -> String {
        if !names.isEmpty {
            return names[0]
        }
        return ""
    }
    
    /**
     Suggest the most likely phone number for the contact.
     */
    func suggestPhoneNumber() -> String {
        if phoneNumbers.isEmpty {
            return ""
        }
        return phoneNumbers[0]
    }
    
    /**
     Suggest the most likely website for the contact.
     */
    func suggestWebsite() -> String {
        if websites.isEmpty {
            return ""
        }
        return websites[0]
    }
}
