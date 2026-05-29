//
//  ContentView.swift
//  GroceryListApp
//
//  Created by Dhruv Patel on 23/05/26.
//

import SwiftUI
import SwiftData
import TipKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var newItemTitle = ""

    @FocusState private var isFocused: Bool
    
    let buttonTip = ButtonTip()
    func setUpTips() {
        do {
            try Tips.resetDatastore()
            Tips.showAllTipsForTesting()
            try Tips.configure([.displayFrequency(.immediate)])
        } catch {
            print("Error initializing TipKit \(error.localizedDescription)")
        }
    }
    init() {
        setUpTips()
    }
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
                            Button("Done", systemImage:
                                    item.isCompleted == false ? "checkmark.circle" : "x.circle") {
                                item.isCompleted.toggle()
                            }
                                    .tint(item.isCompleted == false ? .green: .accentColor)
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
                                        Image(systemName: "carrot")
//                                        Label("Essential",systemImage: "carrot")
                                    }
                                    .popoverTip(buttonTip)
                                }
                            }
                        }
            
            .overlay {
                if items.isEmpty
                {
                    ContentUnavailableView("Empty Cart", systemImage: "cart.circle",description: Text("Add some items to the shopping list."))
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 12) {
                    TextField("", text: $newItemTitle)
                        .textFieldStyle(.plain)
                        .font(.title3.weight(.light))
                        .padding(.horizontal,16)
                        .frame(height: 52)
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .focused($isFocused)
                    Button {
                        let trimmed = newItemTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmed.isEmpty else { return }

                            let newItem = Item(title: trimmed, isCompleted: false)
                            modelContext.insert(newItem)
                            newItemTitle = ""
                            isFocused = false
                    } label: {
                        Text("Save")
                            .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                    .buttonBorderShape(.roundedRectangle)
                    .controlSize(.large)
                }
                .padding()
                .background(.bar)
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
