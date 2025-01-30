//
//  Profile.swift
//  HomeBakery
//
//  Created by Raneem Alomair on 21/07/1446 AH.
//

import SwiftUI

struct Profile: View {
    @AppStorage("username") private var username: String = ""
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    @AppStorage("bookedCoursesData") private var bookedCoursesData: Data = Data()
    @State private var showSignIn: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Profile")
                .font(.title)
                .bold()
                .padding(.top)
            
            Divider().padding()
            
            HStack(spacing: 16) {
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black)
                        )
                    Circle()
                        .fill(Color(.systemBrown))
                        .frame(width: 20, height: 20)
                        .overlay(
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.white)
                        )
                        .offset(x: 6, y: 6)
                }
                
                TextField("Enter username", text: $username)
                    .font(.system(size: 16))
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                Button("Done") {
                    print("Done button tapped")
                }
                .foregroundColor(.brown)
                .font(.system(size: 16, weight: .bold))
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(12)
            .shadow(radius: 2)
            
            Divider().padding(.top, 10)
            
            Text("Booked Courses")
                .font(.title)
                .bold()
                .padding(.top, 10)
            
            let bookedCourses = getBookedCourses()
            
            if bookedCourses.isEmpty {
                Text("No courses booked yet.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            } else {
                List(bookedCourses.sorted(), id: \.self) { courseId in
                    Text("Course ID: \(courseId)")
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .fullScreenCover(isPresented: $showSignIn) {
            SignIn()
        }
        .onAppear {
            if !isAuthenticated {
                showSignIn = true
            }
        }
    }
    
    /// **🔹 جلب الدورات المحجوزة**
    func getBookedCourses() -> Set<String> {
        return (try? JSONDecoder().decode(Set<String>.self, from: bookedCoursesData)) ?? []
    }
    
    
}

#Preview {
    Profile()
}


