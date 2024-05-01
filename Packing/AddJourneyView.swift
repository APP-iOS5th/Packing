//
//  AddJourneyView.swift
//  Packing
//
//  Created by 어재선 on 4/30/24.
//

import SwiftUI

struct AddJourneyView: View {
    @State var testString = ""
    @State private var Startdate = Date()
    @State private var endDate = Date()

    @State private var selectedlist = ""
    private let list: [String] = ["test1","test2","test3","test4","test5"]
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(hex: 0xBDCDD6)
                VStack{
                    Spacer()
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)                            
                            .foregroundStyle(.white)
                            .frame(height: 550)
                        VStack {
                            VStack(alignment:.leading){
                                
                                // MARK: 여행 목적
                                Text("여행목적")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    
                                TextField("여행목적",text: $testString)
                                    .padding()
                                    .font(.subheadline)
                                    .background(Color(hex: 0xF3F3F3))
                                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                    .frame(width: 300)
                                    .padding(.bottom,30)
                                
                                // MARK: 여행 기간
                                Section(content: {
                                    
//                                    DatePicker(
//                                        "Start Date",
//                                        selection: $date,
//                                        displayedComponents: [.date]
//                                    )
//                                    .background(Color(hex: 0xF3F3F3))
//                                    .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
//                                    .datePickerStyle(.graphical)
//                                    .frame(width: 300)
//                                    .bold()
                                    DatePicker("시작 날짜", selection: $Startdate, displayedComponents: [.date])
                                    DatePicker("종료 날짜", selection: $endDate, displayedComponents: [.date])
                                }, header: {
                                    Text("여행 기간")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    
                                })
                                .frame(width: 300 , alignment: .leading)
                        
                                    
                                
                                //MARK: 여행 목적
                                Text("여행 활동")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding(.top,30)
                                Picker("list", selection: $selectedlist){
                                    ForEach(list, id: \.self) {
                                        Text($0)
                                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                    }.pickerStyle(.wheel)
                                }.background(Color(hex: 0xF3F3F3))
                                
                            }.padding(.bottom,30)
                            
                            //MARK: 확인 버튼
                            Button{
                                //TODO: 버튼 클릭시 데이터 전송
                            } label: {
                                Text("확인")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal,50)
                                    .padding(.vertical,20)
                                    .background(Color(hex: 0x566375))
                                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            
                            }

                        }
                    }
                }
            }
            .ignoresSafeArea(.all)
            
        }
        
    }
}

#Preview {
    NavigationStack{

        AddJourneyView()
    }
}
