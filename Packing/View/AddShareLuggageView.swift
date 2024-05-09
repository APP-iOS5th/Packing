//
//  AddPackingItemView.swift
//  Packing
//
//  Created by 김영훈 on 5/2/24.
//

import SwiftUI

struct AddShareLuggageView: View {
    let journey: Journey
    var service: PackingItemService
    
    @State var itemName: String = ""
    @State var requiredCount: Int = 1
    @State var duplicated: Bool = false
    @State var showAlert: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack{
                Button("취소"){
                    dismiss()
                }
                .foregroundStyle(.red)
                Spacer()
                Button("추가"){
                    duplicated = false
                    for shareLuggage in service.shareLuggages {
                        if shareLuggage.name == itemName {
                            duplicated = true
                        }
                    }
                    if duplicated {
                        showAlert.toggle()
                    } else {
                        service.addShareLuggage(name: itemName, requiredCount: requiredCount)
                        dismiss()
                    }
                }
                .disabled(itemName.isEmpty)
                .alert("추가 실패", isPresented: $showAlert) {
                    Button("확인",role: .cancel){}
                } message: {
                    Text("이미 있는 공용 물품입니다.")
                }
            }
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
            }
            .foregroundStyle(.black)
            .scrollContentBackground(.hidden)
        }
        .font(.title2)
        .fontWeight(.bold)
        .background(LinearGradient(colors: [Color(hex: "AEC6CF"),Color(hex: "ECECEC"),Color(hex: "FFFDD0")], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}
