//
//  User.swift
//  HomeBakery
//
//  Created by Raneem Alomair on 27/07/1446 AH.
//
import Foundation

struct UserAPIResponse: Codable {
    let records: [UserRecord]
}

struct UserRecord: Codable {
    let id: String
    let fields: User
}

struct User: Codable {
    let name: String
    let email: String
    let password: String
}

