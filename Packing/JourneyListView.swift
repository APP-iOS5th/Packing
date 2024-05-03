//
//  JourneyListView.swift
//  Packing
//
//  Created by 이융의 on 4/30/24.
//

import SwiftUI

struct JourneyListView: View {
    @StateObject private var service: JourneyService = JourneyService()
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
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(colorScheme == .dark ? Color("DarkColor") : .white)
//                                .frame(minHeight: 700, maxHeight: .infinity)
//                                .shadow(radius: 5)
//                                .edgesIgnoringSafeArea(.bottom)
                            
                            List(service.journeys) { journey in
                                Button(action: {
                                    self.selectedJourney = journey
                                }) {
                                    JourneySummaryView(journey: journey)
                                        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 100)
                                        .padding(.top, 10)
                                        .shadow(radius: 3, x: 1, y: 4)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        service.deleteJourney(journey)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                            .listStyle(.plain)
                            .cornerRadius(30)
                            .edgesIgnoringSafeArea(.bottom)
                            .navigationDestination(item: $selectedJourney) { journey in
                                PackingListView(journey: journey)
                            }
                        }
                    }
                }
            }
            .toolbarBackground(Color("mainColor"), for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddJourneyView(service: service)){
                        Image(systemName: "bag.fill.badge.plus")
                            .font(.title)
                            .foregroundStyle(Color("DarkColor"))
                    }
                }
            }
            .task {
                service.fetch()
            }
        }
    }
}

// MARK: - JOURNEY SUMMARY VIEW
struct JourneySummaryView: View {
    @Environment(\.colorScheme) var colorScheme
    var journey: Journey
    
    var body: some View {
        
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
                AsyncImage(url: URL(string: journey.image)) { image in
                    image.resizable()
                } placeholder: {
                    EmptyView()
                }
                .scaledToFill()
                
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

#Preview {
    JourneyListView()
        .environmentObject(JourneyService())
}

// MARK: - COLOR EXTENSION
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
