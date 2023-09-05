//
//  Image+extension.swift
//  WhatsUp
//
//  Created by Kārlis Štekels on 05/09/2023.
//

import Foundation
import SwiftUI

extension Image {
    func rounded(width: CGFloat = 100, height: CGFloat = 100) -> some View {
        return self
            .resizable()
            .frame(width: width, height: height)
            .clipShape(Circle())
    }
}
