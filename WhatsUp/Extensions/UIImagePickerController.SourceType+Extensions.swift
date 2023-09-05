//
//  UIImagePickerController.SourceType+Extensions.swift
//  WhatsUp
//
//  Created by Kārlis Štekels on 05/09/2023.
//

import Foundation
import UIKit

extension UIImagePickerController.SourceType: Identifiable {
    public var id: Int {
        switch self {
        case .camera:
            return 1
        case .photoLibrary:
            return 2
        case .savedPhotosAlbum:
            return 3
        default:
            return 4
        }
    }
}
