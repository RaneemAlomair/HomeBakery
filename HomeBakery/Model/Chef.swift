//
//  Chef.swift
//  HomeBakery
//
//  Created by Raneem Alomair on 26/07/1446 AH.
//

import Foundation

// استجابة API للطهاة
struct ChefApiResponse: Codable {
    let records: [ChefRecord]
}

// كل كائن "record" في Airtable
struct ChefRecord: Codable {
    let id: String
    let fields: Chef
}

// البيانات الفعلية لكل شيف
struct Chef: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let password: String
}
