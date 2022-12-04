//
//  String.swift
//  Instacard
//
//  Created by Nick Kenyeres on 2022-12-04.
//

// Regular expressions adapted from https://digitalfortress.tech/tips/top-15-commonly-used-regex/
// unless otherwise noted.

import Foundation

extension String {
    var extractedEmail: String {
        let emailRegex = /([a-z0-9_\.\+-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/
        if let match = self.firstMatch(of: emailRegex) {
            let (email, _, _, _) = match.output
            return String(email)
        }
        return ""
    }
    
    var hasEmail: Bool {
        return !self.extractedEmail.isEmpty
    }
    
    var extractedPhoneNumber: String {
        // Regex adapted from https://www.regexpal.com/17
        let phoneRegex = /(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$/
        if let match = self.firstMatch(of: phoneRegex) {
            let (phone, _, _, _, _, _) = match.output
            return String(phone)
        }
        return ""
    }
    
    var hasPhoneNumber: Bool {
        return !self.extractedPhoneNumber.isEmpty
    }
    
    var extractedWebsite: String {
        let websiteRegex = /(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#()?&\/\/=]*)/
        if let match = self.firstMatch(of: websiteRegex) {
            let (website, _, _, _) = match.output
            return String(website)
        }
        return ""
    }
    
    var hasWebsite: Bool {
        return !self.extractedWebsite.isEmpty
    }
}
