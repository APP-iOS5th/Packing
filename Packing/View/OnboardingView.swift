//
//  OnboardingView.swift
//  Packing
//
//  Created by 장예진 on 4/30/24.
//
// MARK: setting appstorage를 통해 로그인 후 한번만 온보딩뷰 실행
// MARK:  hidden back button,
// MARK: 마지막 페이지의 Let's start button 위치

import SwiftUI

struct OnboardingView: View {
    @StateObject private var authenticationViewModel = AuthenticationViewModel()
    @State private var currentPage = 0
    @AppStorage("hasCompletedOnboarding") var showMainView: Bool = false

    var body: some View {
//        NavigationView {
            if showMainView {
                JourneyListView()
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

                    NavigationButtons(currentPage: $currentPage, totalPages: 4)
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
//        }

    }
}

struct NavigationButtons: View {
    @Binding var currentPage: Int
    let totalPages: Int

    var body: some View {
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

            if currentPage < totalPages - 1 {
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

struct OnboardingStepView: View {
    var index: Int
    @Binding var showMainView: Bool
    let images = ["onboarding1", "onboarding2", "onboarding3", "onboarding4"]
    
    var body: some View {
        VStack {
            Spacer()
            Text(headerText[index])
                .font(.title)
                .fontWeight(.semibold)
                .padding()
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .shadow(color: .gray, radius: 1, x: 0, y: 1)

            Text(descriptionText[index])
                .font(.headline)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                .padding()

            if index == 3 {
                Button("Let's Start") {
                    // 온보딩 완료로 설정
                    showMainView = true
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.mint)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 2, x: 0, y: 1)
                .padding(.bottom, 20)
            }

            Image(images[index])
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


let headerText = [
    "여행 일정을 추가해보세요",
    "물품 추가와 수정을 쉽고 자유롭게",
    "친구와 함께하는 여행의 새로운 방식",
    "Packing과 함께라면 완벽하게 준비할 수 있습니다"
]

let descriptionText = [
    "여행 목적지와 활동에 맞춰 필요한 물품을 추천받을 수 있습니다.",
    "공용물품과 개인물품을 분리하여 \n관리 할 수 있습니다",
    "친구들과 패킹 리스트를 공유하고,\n누가 무엇을 가져갈지 실시간으로 조율하세요.",
    ""
]

let image = [
    #imageLiteral(resourceName: "onboarding2.png")
]




#Preview {
    OnboardingView()
}
