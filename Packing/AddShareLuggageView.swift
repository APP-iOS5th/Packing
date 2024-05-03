//
//  AddPackingItemView.swift
//  Packing
//
//  Created by 김영훈 on 5/2/24.
//

import SwiftUI

struct AddShareLuggageView: View {
    let journey: Journey
//    var service: PackingItemService
    var service: PackingItemService = PackingItemService(documentID: "test")
    
    @State var itemName: String = ""
    @State var requiredCount: Int = 1
    @State var descriptionText: String = ""
    @State var duplicated: Bool = false
    
    var body: some View {
        NavigationStack {
            JourneySummaryView(journey: journey)
                .frame(minWidth: 200, maxWidth: .infinity, minHeight: 100)
                .padding()
            
            Form {
                Section(header: Text("공용 물품 이름")
                ){
                    TextField(text: $itemName) {
                        Text("공용 물품 이름")
                    }
                }
                Section(header: Text("필요 인원수")
                ){
                    Stepper(value: $requiredCount, in: 1...4){
                        Text("\(requiredCount)")
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
                        Button("공용 물품 추가"){
                            if itemName.isEmpty {
                                descriptionText = "물품 이름을 입력하세요."
                            } else {
                                duplicated = false
                                for shareLuggage in service.shareLuggages {
                                    if shareLuggage.name == itemName {
                                        duplicated = true
                                    }
                                }
                                if duplicated {
                                    descriptionText = "이미 등록된 물품입니다."
                                } else {
                                    //shareLuggage 추가하기
                                }
                            }
                        }
                        .foregroundStyle(.blue)
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

#Preview {
    AddShareLuggageView(journey: Journey.sample[0])
}
