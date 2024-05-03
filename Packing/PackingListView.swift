//
//  PackingListView.swift
//  Packing
//
//  Created by 김영훈 on 4/30/24.
//

import SwiftUI

struct PackingListView: View {
    @State var showingMember: String = "나"
    @State var service: PackingItemService
    @State private var isNewSharePresented = false
    @State private var isNewPersonalPresented = false
    
    var journey: Journey
    
    @Environment(\.colorScheme) var colorScheme
//    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
//            HStack {
//                Button(action: {
//                    dismiss()
//                    print("dismiss")
//                }) {
//                    Image(systemName: "chevron.backward")
//                        .font(.title3)
//                        .foregroundColor(.primary)
//                }
//                .padding()
//                Spacer()
//            }
//            .padding()
            
            JourneySummaryView(journey: journey)
                .frame(minWidth: 200, maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.vertical, 5)
            Divider().overlay(colorScheme == .dark ? .white.opacity(0.5) : .gray.opacity(0.8)).padding(.horizontal)
            

            
            Form {
                Section(header: Text("구성원 선택")
                    .foregroundStyle(colorScheme == .dark ? .white.opacity(0.85) : .black)
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
                    .foregroundStyle(colorScheme == .dark ? .white.opacity(0.85) : .black)
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
                                        .tint(colorScheme == .dark ? .white.opacity(0.85) : .black)
                                } icon: {
                                    Image(systemName: shareLuggage.checkedPeople.contains(showingMember) ? "checkmark.square" : "square")
                                }
                            }
                            .contextMenu {
                                Button {
                                    if let index = service.shareLuggages.firstIndex(where: {$0.name == shareLuggage.name}) {
                                        service.deleteShareLuggage(index: index)
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                    Text("삭제")
                                        .tint(.red)
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
                    .foregroundStyle(colorScheme == .dark ? .white.opacity(0.85) : .black)
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
                                    .tint(colorScheme == .dark ? .white.opacity(0.85) : .black)
                            } icon: {
                                Image(systemName: personalLuggage.isChecked ? "checkmark.square" : "square")
                            }
                        }
                        .contextMenu {
                            Button {
                                if let index = service.personalLuggages[showingMember]?.firstIndex(where: {$0.name == personalLuggage.name}) {
                                    service.deletePersonalLuggage(index: index)
                                }
                            } label: {
                                Image(systemName: "trash")
                                Text("삭제")
                                    .tint(.red)
                            }
                        }
                        //                        .disabled(showingMember가 내가 아니면)
                    }
                }
            }
            .task{
                service.fetch()
            }
            .scrollContentBackground(.hidden)

        }
//        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isNewSharePresented) {
            AddShareLuggageView(journey: journey, service: service)
        }
        .sheet(isPresented: $isNewPersonalPresented) {
            AddPersonalLuggageView(journey: journey, service: service)
        }
        .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [Color(hex: "AEC6CF"), Color(hex: "ECECEC"), Color(hex: "FFFDD0")] : [Color(hex: "34495E"), Color(hex: "555555"), Color(hex: "333333")]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}


#Preview {
    PackingListView(service: PackingItemService(documentID: "test"), journey: Journey.sample[0])
}

