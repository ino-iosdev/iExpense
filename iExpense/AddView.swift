//
//  AddView.swift
//  iExpense
//
//  Created by Ino Yang Popper on 3/31/25.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount: Double = 0.0
    
    var expenses: Expenses
    // Added: Binding to receive the selected currency code from ContentView
    @Binding var selectedCurrencyCode: String
    
    
    let types = ["Business", "Personal"]
    
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            
            Picker("Type", selection: $type) {
                ForEach(types, id: \.self) {
                    Text($0)
                }
            }
            
            Picker("Currency", selection: $selectedCurrencyCode) {
                ForEach(availableCurrencyCodes, id: \.self) { code in
                    Text(code)
                }
            }
            
            TextField("Amount", value: $amount, format: .currency(code: selectedCurrencyCode))
                .keyboardType(.decimalPad)
        }
        .navigationTitle("Add new expense")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddView(expenses: Expenses(), selectedCurrencyCode: .constant("USD")) // used .constant for preview because it expect a binding.
}
