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
            .overlay {
                if items.isEmpty
                    {
                    ContentUnavailableView("Empty Cart", systemImage: "cart.circle",description: Text("Add some items to the shopping list."))
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for : Item.self, inMemory: true)
}
