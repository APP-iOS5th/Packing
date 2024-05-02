//
//  JourneyListView.swift
//  Packing
//
//  Created by 이융의 on 4/30/24.
//

import SwiftUI

enum TravelActivity: String, CaseIterable, Codable {
    case beach = "해변"
    case camping = "캠핑"
    case hiking = "등산"
    case sightseeing = "관광"
    case skiing = "스키"
    case cycling = "자전거 타기"
    case foodTour = "음식 투어"
    case culturalExperience = "문화 체험"
    case waterSports = "수상 스포츠"
    // 다른 여행 활동 추가
}


struct Journey: Identifiable, Codable, Hashable {
    let id: String
    let destination: String // 여행 목적지
    let activities: [TravelActivity]
    let image: String    //  여행 사진
    let startDate: Date // 여행 시작 날짜
    let endDate: Date   // 여행 끝 날짜
    let packingItemId: String
    var docId: String?
    
    var duration: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }
}

extension Journey {
    static let sample: [Journey] = [
        Journey(id: UUID().uuidString, destination: "다낭", activities: [.beach, .sightseeing, .waterSports], image: "다낭", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 5), packingItemId: "", docId: nil),
        Journey(id: UUID().uuidString, destination: "가평", activities: [.camping], image: "캠핑", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 7), packingItemId: "", docId: nil),
        Journey(id: UUID().uuidString, destination: "사하라 사막", activities: [.hiking, .sightseeing], image: "사막", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 3), packingItemId: "", docId: nil),
        Journey(id: UUID().uuidString, destination: "다낭", activities: [.beach, .sightseeing, .waterSports], image: "다낭", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 5), packingItemId: "", docId: nil),
        Journey(id: UUID().uuidString, destination: "가평", activities: [.camping], image: "캠핑", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 7), packingItemId: "", docId: nil),
        Journey(id: UUID().uuidString, destination: "사하라 사막", activities: [.hiking, .sightseeing], image: "사막", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 3), packingItemId: "", docId: nil)
    ]
}


struct JourneyListView: View {
    @StateObject private var service: JourneyService = JourneyService()
//    var journeys = Journey.sample
    @State private var selectedJourney: Journey?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [Color(hex: "AEC6CF"), Color(hex: "ECECEC"), Color(hex: "FFFDD0")] : [Color(hex: "34495E"), Color(hex: "555555"), Color(hex: "333333")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack {
                    if service.journeys.isEmpty {
                        Image(systemName: "airplane")
                            .font(.title)
                            .padding()
                        
                        Text("현재 여행 목록이 없습니다.\n여행을 추가해주세요.")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    } else {
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(colorScheme == .dark ? Color("DarkColor") : .white)
                                .frame(minHeight: 700, maxHeight: .infinity)
                                .shadow(radius: 5)
                                .edgesIgnoringSafeArea(.bottom)
                            
                            List(service.journeys) { journey in
                                Button(action: {
                                    self.selectedJourney = journey
                                }) {
                                    JourneySummaryView(journey: journey)
                                        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 100)
                                        .padding(.top, 10)
                                    //                                        .background(Color.clear)
                                        .shadow(radius: 3, x: 1, y: 4)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                            .cornerRadius(30)
                            .edgesIgnoringSafeArea(.bottom)
                            
                            //                        .padding(.top)
                            .navigationDestination(item: $selectedJourney) { journey in
                                JourneyDetailView(journey: journey)
                                
                            }
                        }
                        //                        .offset(y: 20)
                    }
                }
            }
            .toolbarBackground(Color("mainColor"), for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
//                    NavigationLink(destination: AddJourneyView()){
//                        Image(systemName: "bag.fill.badge.plus")
//                            .font(.title)
//                            .foregroundStyle(Color("DarkColor"))
//                    }
                    Button {
                        service.addJourney(destination: "다낭!", activities: ["해변"], image: "test", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 5), packingItemId: "")
                    } label: {
                        Text("ADD JOURNEY")
                    }
                }
            }
            .task {
                service.fetch()
            }
        }
    }
}


struct JourneySummaryView: View {
    @Environment(\.colorScheme) var colorScheme
    var journey: Journey
    
    var body: some View {
        let backgroundImage: Image?
        
        if let uiImage = UIImage(named: journey.image) {
            backgroundImage = Image(uiImage: uiImage)
        } else {
            backgroundImage = Image("다낭")
        }
        
        return HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(journey.destination)
                    .font(.title2)
                    .fontWeight(.black)
                
                Text(journey.activities.map { $0.rawValue }.joined(separator: ", "))
                    .font(.callout)
                    .fontWeight(.thin)
                
                Text(journey.duration)
                    .font(.caption)
                    .fontWeight(.light)
            }
            Spacer()
        }
        .padding()
        .background(
            ZStack {
                if let background = backgroundImage {
                    background
                }
                LinearGradient(gradient: Gradient(stops: [
                    .init(color: colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.8), location: 0.3),
                    .init(color: colorScheme == .dark ? Color.black.opacity(0.4) : Color.white.opacity(0.5), location: 0.7),
                    .init(color: .clear, location: 1)
                ]), startPoint: .leading, endPoint: .trailing)
            }
                .frame(height: 100)
                .clipped()
        )
        .cornerRadius(8)
        .shadow(radius: 3)
        .scaledToFill()
    }
}

struct JourneyDetailView: View {
    var journey: Journey
    
    var body: some View {
        Text("")
    }
}

#Preview {
    JourneyListView()
        .environmentObject(JourneyService())
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: Double(a) / 255)
    }
}
