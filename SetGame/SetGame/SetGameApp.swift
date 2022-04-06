//
//  SetGameApp.swift
//  SetGame
//
//  Created by lina on 3/6/22.
//

import SwiftUI

@main
struct SetGameApp: App {
    private let game = SetGame()
    
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
