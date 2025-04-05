//
//  View-ExpenseStyle.swift
//  iExpense
//
//  Created by Ino Yang Popper on 4/4/25.
//

import SwiftUI

extension View {
    func style(for item: ExpenseItem) -> some View {
        if item.amount < 10 {
            return self.foregroundStyle(.green)
        } else if item.amount < 100 {
            return self.foregroundStyle(.black)
        } else {
            return self.foregroundStyle(.red)
        }
    }
}
