//
//  JourneyListView.swift
//  Packing
//
//  Created by 이융의 on 4/30/24.
//

import SwiftUI

struct Journey: Identifiable, Hashable {
    let id: UUID = UUID()
    let destination: String // 여행 목적지
    let activities: [String]    // 여행 활동 Array
    let image: String    //  여행 사진
    let startDate: Date // 여행 시작 날짜
    let endDate: Date   // 여행 끝 날짜
    
    var duration: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }
}

extension Journey {
    static let sample: [Journey] = [
        Journey(destination: "다낭", activities: ["바다", "해변"], image: "다낭", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 5)),
        Journey(destination: "가평", activities: ["글램핑", "캠핑"], image: "캠핑", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 7)),
        Journey(destination: "사하라 사막", activities: ["배낭여행", "사막"], image: "사막", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 3))
    ]
}


struct JourneyListView: View {
    var journeys = Journey.sample
    @State private var isNewJourneyPresented = false

    var body: some View {
        NavigationStack {
            List(journeys) { journey in
                NavigationLink(value: journey) {
                    JourneySummaryView(journey: journey)
                        .frame(height: 100)
                }
                .listRowSeparator(.hidden)
                .cornerRadius(3.0)
                .shadow(radius: 3, x: 3, y: 3)

            }
            .listStyle(.plain)
            .navigationDestination(for: Journey.self) { journey in
                JourneyDetailView(journey: journey)
            }
            .navigationTitle("JourneyListView")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("mainColor"), for: .navigationBar)
            .toolbar {
                Button {
                    isNewJourneyPresented.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.headline)
                }
            }
            .sheet(isPresented: $isNewJourneyPresented) {
                // MARK: -  AddJourneyView 추가
                EmptyView()
                    .presentationDetents([.medium, .large])
                    .presentationCornerRadius(21)
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
            backgroundImage = nil
        }
        
        return VStack(alignment: .leading, spacing: 4) {
            Text(journey.destination)
                .font(.title2)
                .fontWeight(.bold)
            
            Text("\(journey.activities.joined(separator: ", "))")
                .font(.callout)
                .fontWeight(.thin)

            
            Text(journey.duration)
                .font(.caption)
                .fontWeight(.ultraLight)

        }
        .padding()
        .background(
            ZStack {
                if let background = backgroundImage {
                    background
                        .opacity(0.8)
                }

                LinearGradient(gradient: Gradient(stops: [
                    .init(color: colorScheme == .dark ? Color.black : Color.white.opacity(0.9), location: 0.3),
                    .init(color: colorScheme == .dark ? Color.black.opacity(0.7) : Color.white.opacity(0.5), location: 0.7),
                    .init(color: .clear, location: 1)
                ]), startPoint: .leading, endPoint: .trailing) // 왼쪽에서 오른쪽으로의 선형 그라데이션
            }
                .frame(height: 100)
                .clipped()
        )
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
}
