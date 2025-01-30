//
//  ViewModel.swift
//  HomeBakery
//
//  Created by Raneem Alomair on 20/07/1446 AH.
//
//import Foundation
//
//class DateViewModel: ObservableObject {
//    @Published var day: String = ""
//    @Published var month: String = ""
//    
//    init() {
//        getCurrentDate()
//    }
//    
//    func getCurrentDate() {
//        let date = Date()
//        let formatter = DateFormatter()
//        
//        formatter.dateFormat = "dd"
//        self.day = formatter.string(from: date)
//        
//        formatter.dateFormat = "MMM"
//        self.month = formatter.string(from: date)
//    }
//    
//
//}
