import Foundation
import SwiftUI

class ChefViewModel: ObservableObject {
    @Published var chefName: String = ""  // لتخزين اسم الشيف
    
    // دالة لتحميل اسم الشيف بناءً على chefId
    func loadChefName(chefId: String) async {
        // بناء الـ URL بناءً على الـ chefId
        guard let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/chef?filterByFormula=id=\"\(chefId)\"") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
        
        do {
            // إرسال الطلب وانتظار الاستجابة
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // فك تشفير البيانات المستلمة
            let decodedResponse = try JSONDecoder().decode(ChefApiResponse.self, from: data)
            
            // تعيين اسم الشيف بعد فك التشفير
            if let chef = decodedResponse.records.first?.fields {
                DispatchQueue.main.async {
                    self.chefName = chef.name
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}

