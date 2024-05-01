//
//  PackingListView.swift
//  Packing
//
//  Created by 김영훈 on 4/30/24.
//

import SwiftUI

struct PackingListView: View {
    @State var showingMember: String = "나"
    var memberList: [String] = ["나", "멤버2", "멤버3", "멤버4"]
//    @State var packingList: [Luggage] =
//    [Luggage(name: "잠옷", isChecked: true, type: .common),
//     Luggage(name: "칫솔", isChecked: false, type: .common),
//     Luggage(name: "수건", isChecked: false, type: .common),
//     Luggage(name: "양말", isChecked: false, type: .common)]
    @State private var service: PackingItemService = PackingItemService(documentID: "Tk0hmyjN99tnGpt2Ka4g")
    var body: some View {
        NavigationStack {
            Button(action: {
                
            }, label: {
                HStack{
                    VStack(alignment: .leading){
                        Text("경기 가평")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                        Text("캠핑")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
            })
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 100)
            .background(.yellow)
            .padding()
            
            Form {
                Section(header: Text("구성원")
                    .foregroundStyle(.black)
                    .font(.title2)
                    .fontWeight(.bold)) {
                        Picker(selection: $showingMember, label: Text("choose member")){
                            ForEach(memberList, id: \.self){ name in
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
                    Button("firestore data print") {
                        print("click")
                        service.updatePackingItems()
                    }
//                    ForEach($packingList){ $item in
//                        Button {
//                            //토글
//                        } label: {
//                            Label {
//                                Text(item.name)
//                                    .tint(.black)
//                            } icon: {
//                                item.isChecked ? Image(systemName: "checkmark.square") : Image(systemName: "square")
//                            }
//                        }
//                    }
                }
                Section(header:
                            Text("개인")
                    .foregroundStyle(.black)
                    .font(.title2)
                    .fontWeight(.bold)
                ){
//                    ForEach($packingList){ $item in
//                        Button {
//                            //토글
//                        } label: {
//                            Label {
//                                Text(item.name)
//                                    .tint(.black)
//                            } icon: {
//                                item.isChecked ? Image(systemName: "checkmark.square") : Image(systemName: "square")
//                            }
//                        }
//                    }
                    
                }
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

