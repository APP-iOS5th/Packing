//
//  AddPackingItemView.swift
//  Packing
//
//  Created by 김영훈 on 5/2/24.
//

import SwiftUI

struct AddPackingItemView: View {
    let journey: Journey
    @State var itemName: String = ""
    @State var requiredCount: Int = 3
    var body: some View {
        NavigationStack {
            JourneySummaryView(journey: journey)
                .frame(minWidth: 200, maxWidth: .infinity, minHeight: 100)
                .padding()
            
            Form {
                Section(header: Text("물품 이름")
                ){
                    TextField(text: $itemName) {
                        Text("물품 이름")
                    }
                }
                Section(header: Text("필요 인원수")
                ){
                    
                }
            }
            .foregroundStyle(.black)
            .font(.title2)
            .fontWeight(.bold)
            .scrollContentBackground(.hidden)
            .background(RoundedRectangle(cornerRadius: 30)
                .fill(LinearGradient(colors: [Color(hex: "AEC6CF"),Color(hex: "ECECEC"),Color(hex: "FFFDD0")], startPoint: .topLeading, endPoint: .bottomTrailing)))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    AddPackingItemView(journey: Journey.sample[0])
}
