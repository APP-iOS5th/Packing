//
//  PackingListView.swift
//  Packing
//
//  Created by 김영훈 on 4/30/24.
//

import SwiftUI

struct PackingListView: View {
    @State var showingMember: String = "나"
    @State private var service: PackingItemService = PackingItemService(documentID: "Tk0hmyjN99tnGpt2Ka4g")
    let journey = Journey.sample[0]
    var body: some View {
        NavigationStack {
            JourneySummaryView(journey: journey)
                .frame(minWidth: 200, maxWidth: .infinity, minHeight: 100)
                .padding()
            
            Form {
                Section(header: Text("구성원")
                    .foregroundStyle(.black)
                    .font(.title2)
                    .fontWeight(.bold)) {
                        Picker(selection: $showingMember, label: Text("choose member")){
                            ForEach(Array(service.personalLuggages.keys), id: \.self){ name in
                                Text(name).tag(name)
                            }
                        }
                        .pickerStyle(.automatic)
                    }
                Section(header:
                            Text("공용")
                    .foregroundStyle(.black)
                    .font(.title2)
                    .fontWeight(.bold)
                ){
                    List(service.shareLuggages){ shareLuggage in
                        HStack{
                            Button {
                                //toggle
                            } label: {
                                Label {
                                    Text(shareLuggage.name)
                                        .tint(.black)
                                } icon: {
                                    Image(systemName: "checkmark.square")
                                }
                            }
                            Text("( \(shareLuggage.checkedPeople.count) / \(shareLuggage.requiredCount) )")
                                .foregroundStyle(.gray)
                            if !shareLuggage.checkedPeople.isEmpty {
                                Text("-")
                                ForEach(shareLuggage.checkedPeople, id: \.self) { name in
                                    Text(name)
                                        .font(.system(size: 15))
                                }
                            }
                        }
                    }
                }
                Section(header:
                            Text("개인")
                    .foregroundStyle(.black)
                    .font(.title2)
                    .fontWeight(.bold)
                ){
                    List(service.personalLuggages[showingMember] ?? []){ personalLuggage in
                        Button {
                            //toggle
                        } label: {
                            Label {
                                Text(personalLuggage.name)
                                    .tint(.black)
                            } icon: {
                                Image(systemName: personalLuggage.isChecked ? "checkmark.square" : "square")
                            }
                        }
                    }
                }
            }
            .task{
                service.updatePackingItems()
            }
            .scrollContentBackground(.hidden)
            
            //색상 변경해야함
            .background(RoundedRectangle(cornerRadius: 30).fill( Color(red: 157/255, green: 178/255, blue: 191/255)))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    PackingListView()
}

