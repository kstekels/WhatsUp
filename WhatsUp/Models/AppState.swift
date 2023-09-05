//
//  AppState.swift
//  WhatsUp
//
//  Created by Kārlis Štekels on 04/09/2023.
//

import Foundation


enum Route: Hashable {
    case main
    case login
    case signup
}

class AppState: ObservableObject {
    
    @Published var routes: [Route] = []
    
}
