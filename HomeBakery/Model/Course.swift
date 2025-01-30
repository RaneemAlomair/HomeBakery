//import Foundation
//
//struct User: Codable, Identifiable {
//    let id: String
//    let name: String
//    let email: String
//}
//
//struct Chef: Codable, Identifiable {
//    let id: String
//    let name: String
//    let specialty: String
//}
//
//struct Course: Codable, Identifiable {
//    let id: String
//    let title: String
//    let difficulty: String
//    let duration: String
//    let date: String
//    let time: String
//    let location: String
//    let imageUrl: String  // تأكد من أن هذا الحقل موجود في Airtable
//}
//
//enum CodingKeys: String, CodingKey {
//    case id
//    case title
//    case difficulty
//    case duration
//    case date
//    case time
//    case location
//    case imageUrl = "image"  // تأكد من أن هذا الحقل يتوافق مع الحقل الموجود في Airtable
//}
//
//struct Booking: Codable, Identifiable {
//    let id: String
//    let course_id: String
//    let user_id: String
//    let status: String
//}
import Foundation

// MARK: - Root Object
struct ApiResponse: Codable {
    let records: [Record]
}

// MARK: - Record
struct Record: Codable {
    let id: String
    let createdTime: String
    let fields: Fields
}

// MARK: - Fields
struct Fields: Codable , Identifiable {
    let id: String
    let title: String
    let level: String
    let locationLongitude: Double
    let locationName: String
    let locationLatitude: Double
    let imageUrl: String
    let description: String
    let startDate: Double
    let endDate: Double
    let chefId: String
    
    static func == (lhs: Fields, rhs: Fields) -> Bool {
        return lhs.id == rhs.id
    }
    
    // دالة الهشاشة لاستخدامها في قوائم Sorted أو Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    // Custom CodingKeys to match the JSON keys
    enum CodingKeys: String, CodingKey {
        case id, title, level, description
        case locationLongitude = "location_longitude"
        case locationName = "location_name"
        case locationLatitude = "location_latitude"
        case imageUrl = "image_url"
        case startDate = "start_date"
        case endDate = "end_date"
        case chefId = "chef_id"
    }
}

struct Course: Identifiable {
    let id: String
    let title: String
    let chefId: String  // معرف الشيف المرتبط بهذه الدورة
    let locationLatitude: Double
    let locationLongitude: Double
}







