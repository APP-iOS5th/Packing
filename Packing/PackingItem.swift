//
//  Luggage.swift
//  Packing
//
//  Created by 김영훈 on 5/1/24.
//

import Foundation

class ShareLuggage {
    
    let name: String
    var checkedPeople: [String]
    var requiredCount: Int
    
    init(name: String, checkedPeople: [String], requiredCount: Int) {
        self.name = name
        self.checkedPeople = checkedPeople
        self.requiredCount = requiredCount
    }
}

class PersonalLuggage {

    let name: String
    var isChecked: Bool
    
    init(name: String, isChecked: Bool) {
        self.name = name
        self.isChecked = isChecked
    }
}

//class PackingItem: Codable {
//    let id: String
//    let peronal: Dictionary<String,[Dictionary<String,Any>]>
//    let share: [Dictionary<String,Any>]
//    
//    init(id: String = UUID().uuidString ,peronal: Dictionary<String, [Dictionary<String, Any>]>, share: [Dictionary<String, Any>]) {
//        self.peronal = peronal
//        self.share = share
//    }
//}
