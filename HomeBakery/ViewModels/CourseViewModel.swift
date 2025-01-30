
//  CourseViewModel.swift
//  HomeBakery
//
//  Created by Raneem Alomair on 20/07/1446 AH.

import Foundation
//
//struct Course: Identifiable {
//    let id = UUID()
//    let title: String
//    let difficulty: String
//    let duration: String
//    let date: String
//    let imageName: String
//}
//
//class CourseViewModel: ObservableObject {
//    @Published var courses: [Course] = [
//        Course(title: "Babka dough", difficulty: "Intermediate", duration: "2h", date: "19 Feb - 4:00", imageName: "babka"),
//        Course(title: "Cinnamon rolls", difficulty: "Beginner", duration: "2h", date: "19 Feb - 4:00", imageName: "cinnamon"),
//        Course(title: "Japanese bread", difficulty: "Advanced", duration: "2h", date: "19 Feb - 4:00", imageName: "japanese"),
//        Course(title: "Banana bread", difficulty: "Intermediate", duration: "2h", date: "19 Feb - 4:00", imageName: "banana")
//    ]
//    
//    
//    @Published var Allcourses: [Course] = [
//        Course(title: "Babka dough", difficulty: "Intermediate", duration: "2h", date: "19 Feb - 4:00", imageName: "babka"),
//        Course(title: "Cinnamon rolls", difficulty: "Beginner", duration: "2h", date: "19 Feb - 4:00", imageName: "cinnamon"),
//        Course(title: "Japanese bread", difficulty: "Advanced", duration: "2h", date: "19 Feb - 4:00", imageName: "japanese"),
//        Course(title: "Banana bread", difficulty: "Intermediate", duration: "2h", date: "19 Feb - 4:00", imageName: "banana"),
//        Course(title: "Babka dough", difficulty: "Intermediate", duration: "2h", date: "19 Feb - 4:00", imageName: "babka"),
//        Course(title: "Cinnamon rolls", difficulty: "Beginner", duration: "2h", date: "19 Feb - 4:00", imageName: "cinnamon"),
//        Course(title: "Japanese bread", difficulty: "Advanced", duration: "2h", date: "19 Feb - 4:00", imageName: "japanese"),
//        Course(title: "Banana bread", difficulty: "Intermediate", duration: "2h", date: "19 Feb - 4:00", imageName: "banana")
//    ]
//
//}
//


import SwiftUI

class CourseViewModel: ObservableObject {
    @Published var courses: [Fields] = []
    
    func loadItems() async {
        guard let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/course") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001",
                         forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.courses = decodedResponse.records.map { $0.fields }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    
    
}





        
