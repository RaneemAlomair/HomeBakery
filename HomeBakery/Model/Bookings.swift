//
//  Bookings.swift
//  HomeBakery
//
//  Created by Raneem Alomair on 29/07/1446 AH.
//

import Foundation

// Define the structure for a single record
struct AirtableRecord: Codable {
    let id: String
    let createdTime: String
    let fields: RecordFields
}

// Define the fields inside each record
struct RecordFields: Codable {
    let courseID: String
    let userID: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case courseID = "course_id"
        case userID = "user_id"
        case status
    }
}

// Define the structure for the top-level JSON response
struct AirtableResponse: Codable {
    let records: [AirtableRecord]
}
