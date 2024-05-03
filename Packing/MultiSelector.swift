//
//  MultiSelector.swift
//  Packing
//
//  Created by 어재선 on 5/3/24.
//

import SwiftUI

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                    .foregroundStyle(.black)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}



struct MultiSelector: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selections: [String]

    var body: some View {
        NavigationStack {
            List {
                ForEach(TravelActivity.allCases, id: \.self) { item in
                    MultipleSelectionRow(title: item.rawValue, isSelected: self.selections.contains(item.rawValue)) {
                        if self.selections.contains(item.rawValue) {
                            self.selections.removeAll(where: { $0 == item.rawValue })
                        }
                        else {
                            self.selections.append(item.rawValue)
                        }
                    }
                }
            }.navigationTitle("여행 활동")
        }.toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button{
                    print(selections)
                    dismiss()
                    
                } label: {
                    Text("확인")
                        .padding()
                }
            }
        }
    }
}
#Preview {
    NavigationStack{
        MultiSelector(selections: .constant([]))
    }
}
