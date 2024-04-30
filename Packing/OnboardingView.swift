//
//  OnboardingView.swift
//  Packing
//
//  Created by 이융의 on 4/30/24.
//

import SwiftUI

struct MainView : View {
    var body : some View {
        Text("Welcome to LAB5 Paking APP")
        //main layout details insertion
    }
}
//onboardingView
struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showMainView = false
    
    var body: some View {
        if showMainView {
            MainView()
        } else {
            ZStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<4, id: \.self) { index in
                        OnboardingStepView(index: index, showMainView: $showMainView)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                // you can "swipe" the page or click "next"
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            if currentPage < 3 {
                                currentPage += 1
                            } else {
                                showMainView = true
                            }
                        }) {
                            Text("다음 >")
                                .padding()
                                .font(.system(size: 22))
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct OnboardingStepView: View {
    var index: Int
    @Binding var showMainView: Bool
    
    let images = ["onboarding1", "onboarding2", "onboarding3", "onboarding4"]
    
    var body: some View {
        VStack {
            Image(images[index]) // 각 인덱스에 따라서 넣어줌
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            Text(descriptionText)
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
//            if index == 3
//            {
////                Button("Let's Dig in!") {
////                    showMainView = true
//                }
//                .padding()
//            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var descriptionText: String {
        switch index {
        case 0:
            return "Get Organized \n여행 준비를 한눈에! 여행 목적지와 활동에 맞춰 필요한 물품을 추천받으세요."
        case 1:
            return "Personalized Suggestions \n목적지와 일정에 따라 맞춤 패킹 리스트를 생성하고, 친구들과 공유하여 여행 준비를 더욱 쉽게!"
        case 2:
            return "Pack Together \n친구들과 패킹 리스트를 공유하고, 누가 무엇을 가져갈지 실시간으로 조율하세요."
        case 3:
            return "Enjoy Your Trip"
        default:
            return ""
        }
    }
}

#Preview {
    OnboardingView()
}
