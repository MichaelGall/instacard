//
//  String.swift
//  Instacard
//
//  Created by Nick Kenyeres on 2022-12-04.
//

import Foundation

/**
 Extend String type with properties that extract data from the string instance based on regular
 expressions.
 */
extension String {
    /**
     Email address extracted from string.
     */
    var extractedEmail: String {
        // Regex adapted from https://digitalfortress.tech/tips/top-15-commonly-used-regex/
        let emailRegex = /([a-z0-9_\.\+-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/
        if let match = self.firstMatch(of: emailRegex) {
            let (email, _, _, _) = match.output
            return String(email)
        }
        return ""
    }
    
    /**
     Phone number extracted from string.
     */
    var extractedPhoneNumber: String {
        // Regex adapted from https://www.regexpal.com/17
        let phoneRegex = /(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$/
        if let match = self.firstMatch(of: phoneRegex) {
            let (phone, _, _, _, _, _) = match.output
            return String(phone)
        }
        return ""
    }
    
    /**
     Website extracted from string.
     */
    var extractedWebsite: String {
        // Regex adapted from https://digitalfortress.tech/tips/top-15-commonly-used-regex/
        let websiteRegex = /(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#()?&\/\/=]*)/
        if let match = self.firstMatch(of: websiteRegex) {
            let (website, _, _, _) = match.output
            return String(website)
        }
        return ""
    }
}
