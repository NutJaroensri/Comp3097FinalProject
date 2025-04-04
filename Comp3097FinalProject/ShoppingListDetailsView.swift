//
//  ShoppingListDetailsView.swift
//  Comp3097FinalProject
//
//  Created by Nut Jaroensri on 2025-04-04.
//
//  Author:
//  Nut Jaroensri 101422089
//  Paradee Supapian 101374958
//

import SwiftUI

struct ShoppingListDetailsView: View {
    let shoppingList: ShoppingList

    // Get the items from this shopping list
    var items: [Item] {
        let set = shoppingList.items as? Set<Item> ?? []
        return set.sorted { ($0.name ?? "") < ($1.name ?? "") }
    }

    // Total calculations
    var totalBeforeTax: Double {
        items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    var totalTax: Double {
        items.reduce(0) {
            let subtotal = $1.price * Double($1.quantity)
            return $0 + (subtotal * $1.taxRate)
        }
    }

    var totalAfterTax: Double {
        totalBeforeTax + totalTax
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // List Name
                Text(shoppingList.name ?? "Unnamed List")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // List Date
                if let date = shoppingList.dateCreated {
                    Text("Created on \(date.formatted(date: .abbreviated, time: .shortened))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Divider()

                // Items Section
                Text("Items")
                    .font(.headline)

                ForEach(items, id: \.self) { item in
                    let subtotal = item.price * Double(item.quantity)
                    let tax = subtotal * item.taxRate

                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name ?? "---")
                                .font(.headline)
                            Text("Qty: \(item.quantity), Category: \(item.category ?? "Unknown")")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        VStack(alignment: .trailing) {
                            Text("Subtotal: $\(subtotal, specifier: "%.2f")")
                            Text("Tax: $\(tax, specifier: "%.2f")")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }

                Divider()

                // Total Summary
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Summary")
                            .font(.headline)
                        Text("Total Before Tax: $\(totalBeforeTax, specifier: "%.2f")")
                        Text("Total Tax: $\(totalTax, specifier: "%.2f")")
                        Text("Total After Tax: $\(totalAfterTax, specifier: "%.2f")")
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Details")
    }
}


#Preview {
    //ShoppingListDetailsView()
}
