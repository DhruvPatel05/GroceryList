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
    
    func addEssentialFoos() {
        modelContext.insert( Item(title: "Bakery & Bread", isCompleted: false))
        modelContext.insert(Item(title: "Meat & Seafood", isCompleted: true))
        modelContext.insert(Item(title: "Cereals", isCompleted: .random()))
        modelContext.insert(Item(title: "Pasta & Rice", isCompleted: .random()))
        modelContext.insert(Item(title: "Cheese & Eggs", isCompleted: .random()))
        
    }
    var body: some View {
        NavigationStack{
            List{
                ForEach(items) { item in
                    Text(item.title)
                        .font(.title.weight(.light))
                        .padding(.vertical,2)
                        .foregroundStyle(item.isCompleted == false ? Color.primary:Color.accentColor)
                        .strikethrough(item.isCompleted)
                        .italic(item.isCompleted)
                        .swipeActions {
                            Button(role:.destructive) {
                                withAnimation {
                                    modelContext.delete(item)
                                }
                            }
                            label : {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading)  {
                            Button("Done", systemImage: "checkmark.circle") {
                                item.isCompleted.toggle()
                            }
                        }
                }
            }
            .navigationTitle("Grocery List")
            .toolbar {
                if items.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            addEssentialFoos()
                        } label : {
                            Label("Essential",systemImage: "carrot")
                        }
                    }
                }
            }
            .overlay {
                if items.isEmpty
                    {
                    ContentUnavailableView("Empty Cart", systemImage: "cart.circle",description: Text("Add some items to the shopping list."))
                }
            }
        }
    }
}
#Preview ("Sample Data"){
    let sampleData: [Item] = [
        Item(title: "Bakery & Bread", isCompleted: false),
        Item(title: "Meat & Seafood", isCompleted: true),
        Item(title: "Cereals", isCompleted: .random()),
        Item(title: "Pasta & Rice", isCompleted: .random()),
        Item(title: "Cheese & Eggs", isCompleted: .random())
    ]
    let container = try! ModelContainer(for: Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    for item in sampleData {
        container.mainContext.insert(item)
    }
    return ContentView()
        .modelContainer(container)
}

#Preview ("Empty List"){
    ContentView()
        .modelContainer(for : Item.self, inMemory: true)
}
