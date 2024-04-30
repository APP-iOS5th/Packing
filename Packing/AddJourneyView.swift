//
//  AddJourneyView.swift
//  Packing
//
//  Created by 어재선 on 4/30/24.
//

import SwiftUI


struct AddJourneyView: View {
    @State var testString = ""
    @State private var date = Date()
    var body: some View {
        NavigationStack{
            ZStack{
                Color(hex: 0xBDCDD6)
                VStack{
                    Spacer()
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)                            
                            .foregroundStyle(.white)
                            .frame(height: 700)
                        VStack {
                            // MARK: 여행 목적
                            VStack(alignment:.leading){
                                Text("여행목적")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    
                                TextField("여행목적",text: $testString)
                                    .padding()
                                    .font(.subheadline)
                                    .background(Color(hex: 0xF3F3F3))
                                    .clipShape(.capsule)
                                    .frame(width: 300)
                                // MARK: 여행 기간
                                Text("여행 기간")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                DatePicker(
                                       "Start Date",
                                       selection: $date,
                                       displayedComponents: [.date]
                                   )
                                   .datePickerStyle(.graphical)
                                    .frame(width: 300)
                                //MARK: 여행 목적
                                Text("여행목적")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                TextField("여행목적",text: $testString)
                                    .padding()
                                    .font(.subheadline)
                                    .background(Color(hex: 0xF3F3F3))
                                    .clipShape(.capsule)
                                    .frame(width: 300)
                                    .padding(.bottom)
                            }
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
