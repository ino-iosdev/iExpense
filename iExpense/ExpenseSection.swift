//
//  ExpenseSection.swift
//  iExpense
//
//  Created by Ino Yang Popper on 4/4/25.
//

import SwiftUI

struct ExpenseSection: View {
    let title: String
    let expenses: [ExpenseItem]
    let selectedCurrencyCode : String
    let deleteItems: (IndexSet) -> Void
    
    var body: some View {
        Section(title) {
            ForEach(expenses) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        
                        Text(item.type)
                    }
                    
                    Spacer()
                    
                    // Modified: Display amount using the selected currency code
                    Text(item.amount, format: .currency(code: selectedCurrencyCode))
                        .style(for: item)
                }
                .accessibilityElement()
                .accessibilityLabel("\(item.name), \(item.amount, format: .currency(code: selectedCurrencyCode))")
                .accessibilityHint(item.type)
            }
            .onDelete(perform: deleteItems)
        }
    }
}

#Preview {
    ExpenseSection(title: "Personal", expenses: [], selectedCurrencyCode: "USD") { _ in }
}
