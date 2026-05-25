//
//  GroceryListAppApp.swift
//  GroceryListApp
//
//  Created by Dhruv Patel on 23/05/26.
//

import SwiftUI
import SwiftData

@main
struct GroceryListAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for : Item.self)
        }
    }
}
