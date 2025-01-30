import SwiftUI
import MapKit

struct CourseDetailView: View {
    let course: Fields
    
    @ObservedObject private var chefViewModel = ChefViewModel()
    @State private var isBooked = false
    @State private var navigateToHome = false
    @State private var navigateToSignIn = false
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    @AppStorage("bookedCoursesData") private var bookedCoursesData: Data = Data()
    
    @State private var region: MKCoordinateRegion

    init(course: Fields) {
        self.course = course
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: course.locationLatitude, longitude: course.locationLongitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    private var bookedCourses: Set<String> {
        get {
            (try? JSONDecoder().decode(Set<String>.self, from: bookedCoursesData)) ?? []
        }
        set {
            bookedCoursesData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    AsyncImage(url: URL(string: course.imageUrl)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 300, height: 300)
                    .cornerRadius(8)
                    
                    Text("About this course:\n \(course.description)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 10)
                    
                    Divider()
                    
                    if !chefViewModel.chefName.isEmpty {
                        HStack {
                            Text("Chef: \(chefViewModel.chefName)")
                        }
                        .font(.title3)
                        //.foregroundColor(.brown)
                    }
                    
                    HStack {
                        Text("Level: \(course.level)")
                            .font(.title2)
                            .foregroundColor(.brown1)
                            .padding(.horizontal)
                            .background(levelColor(for: course.level))
                            .cornerRadius(8)
                        
                        HStack {
                            Text("Duration: \(formatDuration(course.startDate, course.endDate))")
                        }
                        .font(.title3)
                    }
                    
                    HStack {
                        Text("Date: \(formatDate(course.startDate))")
                            .font(.title3)
                        
                        Text("Location: \(course.locationName)")
                            .font(.title3)
                    }
                    
                    // 🗺️ **إضافة الخريطة قبل زر الحجز**
                    Map(coordinateRegion: $region, annotationItems: [course]) { course in
                            MapMarker(coordinate: CLLocationCoordinate2D(latitude: course.locationLatitude, longitude: course.locationLongitude), tint: .red)
                                    }
                            .frame(height: 150)
                            .cornerRadius(10)
                            .padding(.horizontal)
            
                    Button(action: {
                        if !isAuthenticated {
                            navigateToSignIn = true
                        } else {
                            if isBooked {
                                isBooked = false
                                removeCourseFromProfile(course.id)
                            } else {
                                isBooked = true
                                addCourseToProfile(course.id)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    navigateToHome = true
                                }
                            }
                        }
                    }) {
                        Text(isBooked ? "Cancel Booking " : "Book a Space")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isBooked ? Color.clear : Color.primary1)
                            .foregroundColor(isBooked ? .red : .white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                    
                    NavigationLink(destination: Home(), isActive: $navigateToHome) {
                        EmptyView()
                    }
                    NavigationLink(destination: SignIn(), isActive: $navigateToSignIn) {
                        EmptyView()
                    }
                    // map
                    
                    Spacer()
                }
                .padding()
                .navigationBarTitle(course.title, displayMode: .inline)
                .onAppear {
                    Task {
                        await chefViewModel.loadChefName(chefId: course.chefId)
                        isBooked = bookedCourses.contains(course.id)
                    }
                }
            }
        }
    }
    
    func levelColor(for level: String) -> Color {
        switch level {
        case "beginner":
            return Color.brown1.opacity(1)
        case "intermediate":
            return Color.cream.opacity(0.7)
        case "advanced":
            return Color.primary1.opacity(0.9)
        default:
            return Color.gray.opacity(0.2)
        }
    }
    
    func formatDate(_ timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func formatDuration(_ startTimestamp: Double, _ endTimestamp: Double) -> String {
        let startDate = Date(timeIntervalSince1970: startTimestamp)
        let endDate = Date(timeIntervalSince1970: endTimestamp)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .full
        return formatter.string(from: startDate, to: endDate) ?? "N/A"
    }
    
    /// **🔹 جلب الدورات المحجوزة من `@AppStorage`**
        func getBookedCourses() -> Set<String> {
            return (try? JSONDecoder().decode(Set<String>.self, from: bookedCoursesData)) ?? []
        }
        
        /// **🔹 إضافة دورة إلى القائمة المحجوزة**
        func addCourseToProfile(_ courseId: String) {
            var courses = getBookedCourses()
            if !courses.contains(courseId) {
                courses.insert(courseId)
                saveBookedCourses(courses)
            }
        }
        
        /// **🔹 إزالة دورة من القائمة المحجوزة**
        func removeCourseFromProfile(_ courseId: String) {
            var courses = getBookedCourses()
            courses.remove(courseId)
            saveBookedCourses(courses)
        }
        
        /// **🔹 حفظ الدورات في `@AppStorage`**
        func saveBookedCourses(_ courses: Set<String>) {
            bookedCoursesData = (try? JSONEncoder().encode(courses)) ?? Data()
        }
    }



#Preview {
    CourseDetailView(course: Fields(
        id: "1",
        title: "Mastering Croissants",
        level: "intermediate",
        locationLongitude: 46.6753,
        locationName: "Riyadh, KSA",
        locationLatitude: 24.7136,
        imageUrl: "https://example.com/image.jpg",
        description: "Learn the art of making croissants from scratch.",
        startDate: 1705987200,
        endDate: 1705990800,
        chefId: "123"
    ))
}
