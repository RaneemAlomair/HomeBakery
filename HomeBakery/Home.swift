import SwiftUI

struct Home: View {
    @State private var searchText: String = ""
    @StateObject private var courseViewModel = CourseViewModel()
    
    private let background = Color("background")
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    Text("Home Bakery")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    
                    Divider()
                        .background(Color.gray)
                    
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
                    
                    // 📅 قسم الكورسات القادمة
                    Text("Upcoming")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    if let firstCourse = courseViewModel.courses.first {
                        UpcomingCourseView(course: firstCourse)
                    }
                    
                    // ⭐️ قسم الكورسات الشعبية
                    Text("Popular courses")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
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
                    await courseViewModel.loadItems()  // ✅ تحميل البيانات عند فتح الشاشة
                }
            }
            .tabItem {
                Image("iconbake")
                    .resizable()
                    .frame(width: 24 , height: 24)
                Text("Home")
            }
                       
            NavigationView {
                CoursesView()
            }
            .tabItem {
                Image("iconCourses")
                Text("Courses")
            }
                       
            NavigationView {
                Profile()
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
            
        }
        .tint(Color.primary1)
    }
}

// ✅ **عرض الكورسات القادمة**
struct UpcomingCourseView: View {
    let course: Fields
    
    var body: some View {
        HStack(spacing: 5) {
            VStack(alignment: .leading, spacing: 5) {
                Text(formatDate(course.startDate, format: "MMM"))
                    .font(.headline)
                    .foregroundColor(.brown1)
                
                Text(formatDate(course.startDate, format: "dd"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.brown1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            
            Rectangle()
                .frame(width: 6, height: 70)
                .cornerRadius(10)
                .foregroundColor(.primary1)
                .padding(.leading, -75)
                .padding()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(course.title)
                    .bold()
                    .foregroundColor(.black)
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.primary1)
                    Text(course.locationName)
                        .foregroundColor(.black)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.primary1)
                    Text(formatDate(course.startDate, format: "h:mm a"))
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, -75)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 0.1)
        )
        .padding(.horizontal)
    }
}

// ✅ **عرض صف الكورس في القائمة**
struct CourseRowView: View {
    let course: Fields
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: course.imageUrl)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(course.title)
                    .font(.headline)
                
                Text(course.level)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(levelColor(for: course.level))
                    .cornerRadius(10)
                
                HStack {
                    Image(systemName: "calendar")
                    Text(formatDate(course.startDate, format: "MMM d, yyyy"))
                }
                .font(.subheadline)
                .foregroundColor(.brown1)
                
                HStack {
                    Image(systemName: "clock")
                    Text("\(formatDate(course.startDate, format: "h:mm a")) - \(formatDate(course.endDate, format: "h:mm a"))")
                }
                .font(.subheadline)
                .foregroundColor(.brown1)
            }
            Spacer()
        }
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 0.1)
        )
        .padding(5)
    }
}

// ✅ **تحويل التواريخ من Timestamp إلى نص مقروء**
func formatDate(_ timestamp: Double, format: String) -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: date)
}

// ✅ **تحديد لون مستوى الكورس**
func levelColor(for level: String) -> Color {
    switch level {
    case "beginner":
        return Color.brown1.opacity(1)
    case "intermediate":
        return Color.cream.opacity(0.7)
    default:
        return Color.primary1.opacity(0.9)
    }
}

#Preview {
    Home()
}
