//
//  String+extensions.swift
//  WhatsUp
//
//  Created by Kārlis Štekels on 04/09/2023.
//

import Foundation


extension String {
    var isEmptyOrWithWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
