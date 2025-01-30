//
//  BookingsViewModel.swift
//  HomeBakery
//
//  Created by Raneem Alomair on 29/07/1446 AH.
//
import Foundation
import SwiftUI

class BookingsViewModel: ObservableObject {
    @Published var bookings: [RecordFields] = [] // Change Fields to RecordFields
    
    func loadItems() async {
        guard let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/bookings") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001",
                         forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode(AirtableResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.bookings = decodedResponse.records.map { $0.fields } // This maps to RecordFields
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}

