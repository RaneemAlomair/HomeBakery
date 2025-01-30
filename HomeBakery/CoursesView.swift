////
////  Courses.swift
////  HomeBakery
////
////  Created by Raneem Alomair on 21/07/1446 AH.
////
//
//import SwiftUI
//
//struct CoursesView: View {
//    @State private var searchText: String = ""
//   // @StateObject private var courseViewModel = CourseViewModel()
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Courses")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .padding(.bottom, 5)
//                
//                Divider()
//                    .background(Color.gray)
//                
//                HStack {
//                    Image(systemName: "magnifyingglass")
//                        .foregroundColor(.gray)
//                    
//                    TextField("Search", text: $searchText)
//                        .foregroundColor(.primary)
//                }
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(10)
//                .padding(.horizontal)
//                
//                List(courseViewModel.Allcourses) { course in
//                    NavigationLink(destination: CourseDetailView(course: course)) {
//                        HStack {
//                            Image(course.imageName)
//                                .resizable()
//                                .frame(width: 60, height: 60)
//                                .cornerRadius(8)
//                            
//                            VStack(alignment: .leading) {
//                                Text(course.title)
//                                    .font(.headline)
//                                if course.difficulty == "Beginner" {
//                                    Text(course.difficulty)
//                                        .font(.subheadline)
//                                        .foregroundColor(.white)
//                                        .padding(5)
//                                        .background(Color.brown1.opacity(1))
//                                        .cornerRadius(10)
//                                } else if course.difficulty == "Intermediate" {
//                                    Text(course.difficulty)
//                                        .font(.subheadline)
//                                        .foregroundColor(.brown1)
//                                        .padding(5)
//                                        .background(Color.cream.opacity(0.7))
//                                        .cornerRadius(10)
//                                } else {  // This is the default case (for any other difficulty)
//                                    Text(course.difficulty)
//                                        .font(.subheadline)
//                                        .foregroundColor(.white)
//                                        .padding(5)
//                                        .background(Color.primary1.opacity(0.9))
//                                        .cornerRadius(5)
//                                }
//                                
//                                
//                                HStack {
//                                    Image(systemName: "hourglass")
//                                    Text(course.duration)
//                                }
//                                .font(.subheadline)
//                                .foregroundColor(.brown1)
//                                HStack {
//                                    Image(systemName: "calendar")
//                                    Text(course.date)
//                                }
//                                .font(.subheadline)
//                                .foregroundColor(.brown1)
//                            }
//                            Spacer()
//                        }
//                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.gray, lineWidth: 0.1)
//                        )
//                        .padding(5)
//                    }
//                }
//                .listStyle(PlainListStyle())
//                
//            }
//            .padding()
//        }
//    }
//}

import SwiftUI

struct CoursesView: View {
    @State private var searchText: String = ""
    @StateObject private var courseViewModel = CourseViewModel()
    
    var filteredCourses: [Fields] {
        if searchText.isEmpty {
            return courseViewModel.courses
        } else {
            return courseViewModel.courses.filter { $0.id.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // 🏷️ عنوان الصفحة
                Text("Courses")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // 🔍 شريط البحث
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: $searchText)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // 📋 قائمة الكورسات
                List(courseViewModel.courses, id: \.id) { course in
                    ZStack {
                        NavigationLink(destination: CourseDetailView(course: course)) {
                            EmptyView() // 🔥 رابط غير مرئي
                        }
                        .opacity(0) // 🔥 يخفي الرابط
                        
                        CourseRowView(course: course) // ✅ عرض البيانات فقط بدون سهم
                    }
                }
                .listStyle(PlainListStyle())
            }
            .padding()
            .task {
                await courseViewModel.loadItems()
            }
        }
    }
}




#Preview {
    CoursesView()
}
