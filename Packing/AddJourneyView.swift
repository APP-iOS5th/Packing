//
//  AddJourneyView.swift
//  Packing
//
//  Created by 어재선 on 4/30/24.
//

import SwiftUI



struct AddJourneyView: View {
    var service: JourneyService?
    @Environment(\.dismiss) var dismiss
    
    @State var testString = ""
    @State private var startdate = Date()
    @State private var endDate = Date()
    
    @State private var travelActivitys: TravelActivity = .beach
    
    @State var showImagePicker = false
    @State var selectedUIImage: UIImage?
    @State var image: Image?
    
    func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        image = Image(uiImage: selectedImage)
    }
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        ZStack{
            //MARK: - 사진 배경
            
            //                Color(hex: 0xBDCDD6)
            LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [Color(hex: "AEC6CF"), Color(hex: "ECECEC"), Color(hex: "FFFDD0")] : [Color(hex: "34495E"), Color(hex: "555555"), Color(hex: "333333")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack{
                ZStack{
                    if let image = image {
                        image
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .frame(minWidth: 200, maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 60)
                            .shadow(radius: 3)
                    } else {
                        Spacer()
                        Rectangle()
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .frame(minWidth: 200, maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 60)
                            .shadow(radius: 3)
                            .foregroundStyle(.white)
                        VStack{
                            Image(systemName: "photo.badge.plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                                .padding(.top, 50)
                                .foregroundStyle(Color(hex: 0x566375))
                    
                        }
                    }
                }.onTapGesture {
                    showImagePicker.toggle()
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.white)
                        .frame(minHeight: 550, maxHeight: .infinity)
                    VStack {
                        VStack(alignment:.center){
                            
                            // MARK: 여행 목적
                            Text("여행목적")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            TextField("여행목적",text: $testString)
                                .padding()
                                .font(.subheadline)
                                .background(Color(hex: 0xF3F3F3))
                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                .frame(width: 300)
                                .padding(.bottom,30)
                            
                            // MARK: - 여행 기간
                            Text("여행 기간")
                                .font(.title2)
                                .fontWeight(.bold)
                            VStack{
                                DatePicker("시작 날짜", selection: $startdate, displayedComponents: [.date])
                                    .padding()
                                DatePicker("종료 날짜", selection: $endDate, displayedComponents: [.date])
                                    .padding()
                            }
                            .bold()
                            .font(.body)
                            .frame(width: 300 , alignment: .leading)
                            .background(Color(hex: 0xF3F3F3))
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            .padding()
                                
                            //MARK: - 여행 목적
                            Picker("여행 활동", selection: $travelActivitys){
                                ForEach(TravelActivity.allCases, id: \.self) {
                                    Text($0.rawValue)
                                        .font(.body)
                                }
                            }
                            .foregroundStyle(.black)
                            .font(.title3)
                            .bold()
                            .padding()
                            .pickerStyle(.navigationLink)
                            .frame(width: 300,height: 60)
                            .background(Color(hex: 0xF3F3F3))
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            
                            
                        }
                        
                        //MARK: - 확인 버튼
                        Button{
                            //TODO: 버튼 클릭시 데이터 전송
                            service?.addJourney(destination: testString, activities: [travelActivitys], image: "", startDate: startdate, endDate: endDate, packingItemId: "")
                            dismiss()
                        } label: {
                            Text("확인")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal,50)
                                .padding(.vertical,20)
                                .background(Color(hex: 0x566375))
                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            
                        }
                        .padding(.top, 30)
                        .disabled(testString.isEmpty)
                        
                    }
                }
            }
        }
        .ignoresSafeArea(.all)
        .sheet(isPresented: $showImagePicker, onDismiss: {
            loadImage()
        }) {
            ImagePicker(image: $selectedUIImage)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    NavigationStack{
        
        AddJourneyView(service: nil)
    }
}
