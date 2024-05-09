//
//  JourneyListView.swift
//  Packing
//
//  Created by 이융의 on 4/30/24.
//

import SwiftUI

// MARK: - VIEW MODIFIER
struct GradientBackground: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(gradient: Gradient(colors: colorScheme == .light ?
                    [Color(hex: "AEC6CF"), Color(hex: "D6D6D6"), Color(hex: "F0EAD6")] :
                    [Color(hex: "34495E"), Color(hex: "4E4E4E"), Color(hex: "2E2E2E")]),
                    startPoint: .topLeading, endPoint: .bottomTrailing)
            )
    }
}

extension View {
    func gradientBackground() -> some View {
        modifier(GradientBackground())
    }
}

struct JourneyListView: View {
    @StateObject private var service: JourneyService = JourneyService()
    @State private var selectedJourney: Journey?
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            if service.journeys.isEmpty {
                EmptyStateView
            } else {
                JourneyList
            }
        }
        .gradientBackground()
        .navigationTitle("Your Journeys")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddJourneyView(packingItemService: PackingItemService(documentID: "test"), service: service)) {                    
                    HStack {
                        Text("여행 추가")
                        Image(systemName: "plus.circle.fill")
                    }
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                    
                }
            }
        }
        .task {
            service.fetch()
        }
        .navigationBarBackButtonHidden(true)
    }

    private var EmptyStateView: some View {
        VStack {
            Image(systemName: "airplane")
                .font(.largeTitle)
                .padding()
            Text("현재 여행 목록이 없습니다.\n'+'를 눌러 새 여행을 추가해주세요.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var JourneyList: some View {
        List(service.journeys) { journey in
            Button(action: {
                self.selectedJourney = journey
            }) {
                JourneySummaryView(journey: journey)
                    .shadow(radius: 1)
                    .padding(.vertical, 5)
            }
            .buttonStyle(PlainButtonStyle())
            .listRowBackground(Color.clear)
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    service.deleteJourney(journey)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationDestination(item: $selectedJourney) { journey in
            PackingListView(service: PackingItemService(documentID: journey.id), journey: journey)
        }
    }
}


// MARK: - JOURNEY SUMMARY VIEW
struct JourneySummaryView: View {
    @Environment(\.colorScheme) var colorScheme
    var journey: Journey

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(journey.destination)
                    .font(.headline)
                    .fontWeight(.semibold)

                Text(journey.activities.map { $0.rawValue }.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(journey.duration)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(
            AsyncImage(url: URL(string: journey.image)) { image in
                ZStack {
                    image.resizable()
                    LinearGradient(gradient: Gradient(stops: [
                        .init(color: colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.8), location: 0.3),
                        .init(color: colorScheme == .dark ? Color.black.opacity(0.4) : Color.white.opacity(0.5), location: 0.7),
                        .init(color: .clear, location: 1)
                    ]), startPoint: .leading, endPoint: .trailing)
                }
            } placeholder: {
                colorScheme == .dark ? Color("DarkColor") : Color(hex: 0xE2E8F0)
            }
            .scaledToFill()
        )
        .cornerRadius(8)
        .scaledToFill()
        .frame(height: 100)
        .clipped()
    }
}


#Preview {
    NavigationStack {
        JourneyListView()
            .environmentObject(JourneyService())
    }
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
