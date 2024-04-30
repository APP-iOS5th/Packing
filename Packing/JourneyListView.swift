//
//  JourneyListView.swift
//  Packing
//
//  Created by 이융의 on 4/30/24.
//

import SwiftUI

enum TravelActivity: String, CaseIterable {
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


struct Journey: Identifiable, Hashable {
    let id: UUID = UUID()
    let destination: String // 여행 목적지
    let activities: [TravelActivity]
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
        Journey(destination: "다낭", activities: [.beach, .sightseeing, .waterSports], image: "다낭", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 5)),
        Journey(destination: "가평", activities: [.camping], image: "캠핑", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 7)),
        Journey(destination: "사하라 사막", activities: [.hiking, .sightseeing], image: "사막", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 3)),
        Journey(destination: "다낭", activities: [.beach, .sightseeing, .waterSports], image: "다낭", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 5)),
        Journey(destination: "가평", activities: [.camping], image: "캠핑", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 7)),
        Journey(destination: "사하라 사막", activities: [.hiking, .sightseeing], image: "사막", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 3))
    ]
}

//
//struct JourneyListView: View {
//    var journeys = Journey.sample
//    @State private var isNewJourneyPresented = false
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
////                Color("mainColor")
//
//                VStack {
//                    if journeys.isEmpty {
//                        Image(systemName: "airplane")
//                            .font(.title)
//                            .padding()
//                        
//                        Text("현재 여행 목록이 없습니다.\n여행을 추가해주세요.")
//                            .font(.headline)
//                            .multilineTextAlignment(.center)
//                    } else {
//                        List(journeys) { journey in
//                            NavigationLink(value: journey) {
//                                JourneySummaryView(journey: journey)
//                                    .frame(height: 100)
//                            }
//                            .listRowSeparator(.hidden)
//                            .cornerRadius(3.0)
//                            .shadow(radius: 3, x: 3, y: 3)
//                        }
//                        .listStyle(.plain)
//                        .navigationDestination(for: Journey.self) { journey in
//                            JourneyDetailView(journey: journey)
//                        }
//                    }
//                }
//                
//                // MARK: - ADD BUTTON
//                VStack {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                        Button {
//                            isNewJourneyPresented.toggle()
//                        } label: {
//                            Image(systemName: "bag.fill.badge.plus")
//                                .font(.largeTitle)
//                                .foregroundStyle(Color("mainColor"))
//                                .shadow(radius: 1)
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//                .padding()
//            }
//
//            .navigationTitle("JourneyListView")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbarBackground(Color("mainColor"), for: .navigationBar)
//            .sheet(isPresented: $isNewJourneyPresented) {
//                // MARK: -  AddJourneyView 추가
//                EmptyView()
//                    .presentationDetents([.medium, .large])
//                    .presentationCornerRadius(21)
//            }
//        }
//    }
//}

struct JourneyListView: View {
    var journeys = Journey.sample
    @State private var isNewJourneyPresented = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack {
            ZStack {
                Color("mainColor").ignoresSafeArea()
                VStack {
                    if journeys.isEmpty {
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
                            
                            List(journeys) { journey in
                                NavigationLink(value: journey) {
                                    JourneySummaryView(journey: journey)
                                        .frame(height: 100)
                                        .padding(.top, 10)
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .cornerRadius(3.0)
                                .shadow(radius: 3, x: 1, y: 4)
                            }
                            .listStyle(.plain)
                            .cornerRadius(30)
                            .edgesIgnoringSafeArea(.bottom)

    //                        .padding(.top)
                            .navigationDestination(for: Journey.self) { journey in
                                JourneyDetailView(journey: journey)
                            }
                        }
//                        .offset(y: 20)
                    }
                }
//                // MARK: - ADD BUTTON
//                VStack {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                        Button {
//                            isNewJourneyPresented.toggle()
//                        } label: {
//                            Image(systemName: "bag.fill.badge.plus")
//                                .font(.largeTitle)
//                                .foregroundStyle(Color("mainColor"))
////                                .shadow(radius: 1)
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//                .padding()
            }
//            .navigationTitle("여행 목록")
            .toolbarBackground(Color("mainColor"), for: .navigationBar)
            .sheet(isPresented: $isNewJourneyPresented) {
                // MARK: -  AddJourneyView 추가
                EmptyView()
                    .presentationDetents([.medium, .large])
                    .presentationCornerRadius(21)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isNewJourneyPresented.toggle()
                    } label: {
                        Image(systemName: "bag.fill.badge.plus")
                            .font(.title)
                            .foregroundStyle(Color("DarkColor"))
                    }
                }
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
            
            Text(journey.activities.map { $0.rawValue }.joined(separator: ", "))
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
                    .init(color: colorScheme == .dark ? Color.black : Color.white.opacity(0.99), location: 0.3),
                    .init(color: colorScheme == .dark ? Color.black.opacity(0.7) : Color.white.opacity(0.6), location: 0.7),
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