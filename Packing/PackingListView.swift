//
//  PackingListView.swift
//  Packing
//
//  Created by 김영훈 on 4/30/24.
//

import SwiftUI

struct PackingListView: View {
    @State var showingMember: String = "나"
    @State var service: PackingItemService = PackingItemService(documentID: "test")
    @State private var isNewSharePresented = false
    @State private var isNewPersonalPresented = false
    
    var journey: Journey
    
    var body: some View {
        NavigationStack {
            JourneySummaryView(journey: journey)
                .frame(minWidth: 200, maxWidth: .infinity, minHeight: 100)
                .padding()
            
            Form {
                Section(header: Text("구성원 선택")
                    .foregroundStyle(.black)
                    .font(.title2)
                    .fontWeight(.bold)) {
                        Picker(selection: $showingMember, label: Text("")){
                            ForEach(Array(service.personalLuggages.keys), id: \.self){ name in
                                Text(name).tag(name)
                            }
                        }
                        .pickerStyle(.automatic)
                    }
                Section(header: HStack{
                    Text("공용 물품")
                    Spacer()
                    Button {
                        isNewSharePresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                    .foregroundStyle(.black)
                    .font(.title2)
                    .fontWeight(.bold)
                ){
                    List(service.shareLuggages){ shareLuggage in
                        HStack{
                            Button {
                                if let index = service.shareLuggages.firstIndex(where: {$0.name == shareLuggage.name}) {
                                    service.toggleShareLuggage(showingMember: showingMember, index: index)
                                }
                            } label: {
                                Label {
                                    Text(shareLuggage.name)
                                        .tint(.black)
                                } icon: {
                                    Image(systemName: shareLuggage.checkedPeople.contains(showingMember) ? "checkmark.square" : "square")
                                }
                            }
                            //                            .disabled(showingMember가 내가 아니면)
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
                    .sheet(isPresented: $isNewSharePresented) {
                        AddShareLuggageView(journey: journey, service: service)
                    }
                }
                Section(header: HStack{
                    Text("개인 물품")
                    Spacer()
                    Button {
                        isNewPersonalPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                    .foregroundStyle(.black)
                    .font(.title2)
                    .fontWeight(.bold)
                ){
                    List(service.personalLuggages[showingMember] ?? []){ personalLuggage in
                        Button {
                            if let index = service.personalLuggages[showingMember]?.firstIndex(where: {$0.name == personalLuggage.name}) {
                                service.togglePersonalLuggage(showingMember: showingMember, index: index)
                            }
                        } label: {
                            Label {
                                Text(personalLuggage.name)
                                    .tint(.black)
                            } icon: {
                                Image(systemName: personalLuggage.isChecked ? "checkmark.square" : "square")
                            }
                        }
                        //                        .disabled(showingMember가 내가 아니면)
                    }
                    .sheet(isPresented: $isNewPersonalPresented) {
                        AddPersonalLuggageView(journey: journey, service: service)
                    }
                }
            }
            .task{
                service.fetch()
            }
            .scrollContentBackground(.hidden)
            .background(RoundedRectangle(cornerRadius: 30)
                .fill(LinearGradient(colors: [Color(hex: "AEC6CF"),Color(hex: "ECECEC"),Color(hex: "FFFDD0")], startPoint: .topLeading, endPoint: .bottomTrailing)))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    PackingListView(journey: Journey.sample[0])
}

