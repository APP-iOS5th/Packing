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
                    for personalLuggage in service.personalLuggages[myID]! {
                        if personalLuggage.name == itemName {
                            duplicated = true
                        }
                    }
                    if duplicated {
                        showAlert.toggle()
                    } else {
                        service.addPersonalLuggage(name: itemName)
                        dismiss()
                    }
                }
                .disabled(itemName.isEmpty)
                .alert("추가 실패", isPresented: $showAlert) {
                    Button("확인",role: .cancel){}
                } message: {
                    Text("이미 있는 개인 물품입니다.")
                }
            }
            .padding()
            Form {
                Section(header: Text("개인 물품 이름")
                ){
                    TextField(text: $itemName) {
                        Text("개인 물품 이름")
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
