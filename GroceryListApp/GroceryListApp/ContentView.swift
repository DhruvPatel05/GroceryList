//
//  ContentView.swift
//  GroceryListApp
//
//  Created by Dhruv Patel on 23/05/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    var body: some View {
        NavigationStack{
            List{
                ForEach(items) { item in
                    Text(item.title)
                }
            }
            .navigationTitle("Grocery List")
        }
    }
}

#Preview {
    ContentView()
}
