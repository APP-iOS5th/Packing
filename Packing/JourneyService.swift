//
//  JourneyService.swift
//  Packing
//
//  Created by 이융의 on 5/2/24.
//

import Firebase
import FirebaseCore

class JourneyService: ObservableObject {
    @Published var journeys: [Journey]
    private let dbCollection = Firestore.firestore().collection("Journey")
    private var listener: ListenerRegistration?
    
    init(journeys: [Journey] = []) {
        self.journeys = journeys
//        startRealtimeUpdates()
    }
}


