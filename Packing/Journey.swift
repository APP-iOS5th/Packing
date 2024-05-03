//
//  Journey.swift
//  Packing
//
//  Created by 이융의 on 5/3/24.
//

import Foundation

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
