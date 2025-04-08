//
//  ContentView.swift
//  iExpense
//
//  Created by Ino Yang Popper on 3/25/25.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        // Encode the items array to JSON and save to UserDefaults whenever the array changes
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    var personalItems: [ExpenseItem] {
        items.filter { $0.type == "Personal"}
    }
    
    var businessItems: [ExpenseItem] {
        items.filter { $0.type == "Business"}
    }

    // Attempt to decode items from UserDefaults during initialization
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        // If decoding fails or no saved items are found, initialize with an empty array
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showAddExpense = false
    
    @State private var selectedCurrencyCode: String = UserDefaults.standard.string(forKey: "selectedCurrency") ?? Locale.current.currency?.identifier ?? "USD"
    
    var body: some View {
        NavigationStack {
            List {
                ExpenseSection(title: "Business", expenses: expenses.businessItems, selectedCurrencyCode: "USD", deleteItems: removeBusinessItems)
                ExpenseSection(title: "Personal", expenses: expenses.personalItems, selectedCurrencyCode: "USD", deleteItems: removePersonalItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                // Modified: Changed toolbar to a Menu to include currency selection
                Menu {
                    Button("Add Expense", systemImage: "plus") {
                        showAddExpense = true
                    }
                    // Added: NavigationLink to CurrencySelectionView
                    NavigationLink(destination: CurrencySelectionView(selectedCurrencyCode: $selectedCurrencyCode)) {
                        Label("Change Currency", systemImage: "dollarsign.circle")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            // Modified: Pass the selectedCurrencyCode binding to AddView
            .sheet(isPresented: $showAddExpense) {
                AddView(expenses: expenses, selectedCurrencyCode: $selectedCurrencyCode)
            }
        }
        // Added: Listen for UserDefaults changes to update the currency code
        .onReceive(NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)) { _ in
            if let newCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") {
                selectedCurrencyCode = newCurrency
            }
        }
    }
    
    func removeItems(at offsets: IndexSet, in inputArray: [ExpenseItem]) {
        var objectsToDelete = IndexSet()
        
        for offset in offsets {
            let item = inputArray[offset]
            
            if let index = expenses.items.firstIndex(of: item) {
                objectsToDelete.insert(index)
            }
        }
        expenses.items.remove(atOffsets: objectsToDelete)
    }
    
    func removePersonalItems(at offsets: IndexSet) {
        removeItems(at: offsets, in: expenses.personalItems)
    }

    func removeBusinessItems(at offsets: IndexSet) {
        removeItems(at: offsets, in: expenses.businessItems)
    }
}

#Preview {
    ContentView()
}
