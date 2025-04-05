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
    let deleteItems: (IndexSet) -> Void
    
    // Added: State to store the selected currency code. Initialized from UserDefaults or defaults
    @State private var selectedCurrencyCode: String = UserDefaults.standard.string(forKey: "selectedCurrency") ?? Locale.current.currency?.identifier ?? "USD"
    
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
            }
            .onDelete(perform: deleteItems)
        }
    }
}

#Preview {
    ExpenseSection(title: "Personal", expenses: []) { _ in }
}
