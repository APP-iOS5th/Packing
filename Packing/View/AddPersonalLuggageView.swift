//
//  AddPersonalLuggageView.swift
//  Packing
//
//  Created by 김영훈 on 5/3/24.
//

import SwiftUI

struct AddPersonalLuggageView: View {
    let journey: Journey
    var service: PackingItemService
    let myID = "나"
    @State var itemName: String = ""
    @State var descriptionText: String = ""
    @State var duplicated: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            JourneySummaryView(journey: journey)
                .frame(minWidth: 200, maxWidth: .infinity, minHeight: 100)
                .padding()
            
            Form {
                Section(header: Text("개인 물품 이름")
                ){
                    TextField(text: $itemName) {
                        Text("개인 물품 이름")
                    }
                }
                Section(footer: HStack{
                    Spacer()
                    Text(descriptionText)
                        .font(.callout)
                        .foregroundStyle(.red)
                }
                ){
                    HStack {
                        Spacer()
                        Button("개인 물품 추가"){
                            if itemName.isEmpty {
                                descriptionText = "물품 이름을 입력하세요."
                            } else {
                                duplicated = false
                                for personalLuggage in service.personalLuggages[myID]! {
                                    if personalLuggage.name == itemName {
                                        duplicated = true
                                    }
                                }
                                if duplicated {
                                    descriptionText = "이미 등록된 물품입니다."
                                } else {
                                    service.addPersonalLuggage(name: itemName)
                                    dismiss()
                                }
                            }
                        }
                        .foregroundStyle(.blue)
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        Button("취소"){
                            dismiss()
                        }
                        .foregroundStyle(.red)
                    }
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
