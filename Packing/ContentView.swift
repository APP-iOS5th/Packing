//
//  ContentView.swift
//  Packing
//
//  Created by 이융의 on 4/30/24.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    var body: some View {
        VStack {
            Button("new document"){
                newPackingList(id: "test2")
            }
        }
        .padding()
    }
    func newPackingList(id: String) {
        let dbCollection = Firestore.firestore().collection("PackingList")
        let people: [String] = ["나","멤버2","멤버3","멤버4"]
        let personalLuggages: [String] = ["세면도구","여벌옷","충전기","개인 약"]
        let shareLuggages: [String : Int] = ["비상 약":1,"드라이기":1,"간식":2]
        var personalLuggageList:[String : [[ String : Any ]]] = [:]
        for person in people {
            var array:[[String : Any]] = []
            for personalLuggage in personalLuggages {
                array.append(["isChecked" : false, "name" : personalLuggage])
            }
            personalLuggageList[person] = array
        }
        var shareLuggageList: [[String : Any]] = []
        for (name, count) in shareLuggages {
            shareLuggageList.append(["checkedPeople":[],"name": name,"requiredCount":count])
        }
        dbCollection.document(id).setData(["personal":personalLuggageList, "share":shareLuggageList])
    }
}

#Preview {
    ContentView()
}
