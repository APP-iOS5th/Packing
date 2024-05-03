//
//  AddJourneyView.swift
//  Packing
//
//  Created by 어재선 on 4/30/24.
//

import SwiftUI
import PhotosUI

struct AddJourneyView: View {
    @State var packingItemService: PackingItemService
    var service: JourneyService?
    @Environment(\.dismiss) var dismiss
    @State var testString = ""
    @State private var startdate = Date()
    @State private var endDate = Date()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var image: UIImage? = nil
    @State private var travelActivitys: TravelActivity = .beach
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isUploading: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: colorScheme == .light ? [Color(hex: "AEC6CF"), Color(hex: "ECECEC"), Color(hex: "FFFDD0")] : [Color(hex: "34495E"), Color(hex: "555555"), Color(hex: "333333")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack{
                
                // MARK: - Image
                
                ZStack{
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .frame(minWidth: 200, maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 60)
                            .shadow(radius: 3)
                    } else {
                        Spacer()
                        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                            ZStack{
                                Rectangle()
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                    .frame(minWidth: 200, maxWidth: .infinity, maxHeight: .infinity)
                                    .padding(.top, 60)
                                    .shadow(radius: 3)
                                    .foregroundStyle(colorScheme == .dark ? Color("DarkColor") : .white)
                                VStack{
                                    Image(systemName: "photo.badge.plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100)
                                        .padding(.top, 50)
                                        .foregroundStyle(Color(hex: 0x566375))
                                }
                            }
                        }.onChange(of: selectedItem) {
                            loadImage()
                        }
                    }
                }
                
                
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(colorScheme == .dark ? Color("DarkColor") : .white)
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
                                .background(colorScheme == .dark ? Color(hex: 0x1A1A1A) : Color(hex: 0xF3F3F3))
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
                            .background(colorScheme == .dark ? Color(hex: 0x1A1A1A) : Color(hex: 0xF3F3F3))
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            .padding()
                                
                            //MARK: - 여행 목적
                            Picker("여행 활동", selection: $travelActivitys){
                                ForEach(TravelActivity.allCases, id: \.self) {
                                    Text($0.rawValue)
                                        .font(.body)
                                }
                            }
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .font(.title3)
                            .bold()
                            .padding()
                            .pickerStyle(.navigationLink)
                            .frame(width: 300,height: 60)
                            .background(colorScheme == .dark ? Color(hex: 0x1A1A1A) : Color(hex: 0xF3F3F3))
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            
                            
                        }
                        
                        //MARK: - 확인 버튼
                        if isUploading {
                            ProgressView()
                        } else {
                            Button{
                                addJourney()
                            } label: {
                                Text("확인")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal,50)
                                    .padding(.vertical,20)
                                    .background(testString.isEmpty ? Color(hex: 0x566375).opacity(0.5) : Color(hex: 0x566375))
                                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            }
                            .padding(.top, 30)
                            .disabled(testString.isEmpty)
                        }
                    }
                }
            }
        }
        // MARK: - ALERT
        
        .alert("알람", isPresented: $showAlert) {
            Button("확인", role: .cancel) {
                dismiss()
            }
        } message: {
            Text(alertMessage)
        }
        .ignoresSafeArea(.all)
    }
    
    // MARK: - FUNCTION
    
    private func addJourney() {
        isUploading = true
        let id = UUID().uuidString
        service?.addJourney(id: id, destination: testString, activities: [travelActivitys], image: image, startDate: startdate, endDate: endDate, completion: { success, message in
            alertMessage = message
            if success {
                packingItemService.newPackingList(id: id, activities: [travelActivitys], completion: { _, error in
                    if let error = error {
                        alertMessage = error.localizedDescription
                        print("Error creating packing list: \(error.localizedDescription)")
                    }
                })
            }
            showAlert = true
            isUploading = false
        })
    }


    private func loadImage() {
        Task{
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let uiImage = UIImage(data: imageData) else { return }
            image = uiImage
        }
    }
}

#Preview {
    NavigationStack{
        
        AddJourneyView(packingItemService: PackingItemService(documentID: "test"), service: nil)
    }
}
