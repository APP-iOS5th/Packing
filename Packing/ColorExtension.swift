//
//  ColorExtension.swift
//  Packing
//
//  Created by 김소희 on 4/30/24.
//
// 재선님 코드에서 가져왔습니다.

import Foundation
import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
            )
         }
     }
