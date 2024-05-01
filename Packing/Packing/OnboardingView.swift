//
//  OnboardingView.swift
//  Packing
//
//  Created by 이융의 on 4/30/24.
//
import SwiftUI

struct MainView: View {
    var body: some View {
        Text("Welcome to LAB5 Packing APP")
            .font(.title)
            .padding()
    }
}

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showMainView = false

    var body: some View {
        if showMainView {
            MainView()
        } else {
            ZStack {
                Color("mainColor").edgesIgnoringSafeArea(.all)

                TabView(selection: $currentPage) {
                    ForEach(0..<4, id: \.self) { index in
                        OnboardingStepView(index: index, showMainView: $showMainView)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .transition(.slide)
                .animation(.easeInOut, value: currentPage)

                HStack {
                    if currentPage > 0 {
                        Button(action: {
                            currentPage -= 1
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 20)
                    }
                    Spacer()
                    if currentPage < 3 {
                        Button(action: {
                            currentPage += 1
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 20)
                    }
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
            Text(headerText[index])
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(.black)
                .shadow(color:.gray, radius: 2, x:0 , y:1)

            Image(images[index])
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()

            Text(descriptionText[index])
                .font(.headline)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .padding()

            if index == 3 {
                Button("Let's Start") {
                    showMainView = true
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.mint)
                .cornerRadius(10)
                .shadow(color:.gray, radius: 2, x:0, y:1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

let headerText = [
    "Get Organized",
    "Personalized Suggestions",
    "Pack Together",
    "Enjoy Your Trip"
]

let descriptionText = [
    "여행 준비를 한눈에! 여행 목적지와 활동에 맞춰 필요한 물품을 추천받으세요.",
    "목적지와 일정에 따라 맞춤 패킹 리스트를 생성하고, 친구들과 공유하여 여행 준비를 더욱 쉽게!",
    "친구들과 패킹 리스트를 공유하고, 누가 무엇을 가져갈지 실시간으로 조율하세요.",
    ""
]





#Preview {
    OnboardingView()
}
