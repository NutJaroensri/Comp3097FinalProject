//
//  AddNewListView.swift
//  Comp3097FinalProject
//
//  Created by Nut Jaroensri on 2025-04-04.
//
//  Author:
//  Nut Jaroensri 101422089
//  Paradee Supapian 101374958

import SwiftUI
import CoreData

struct ItemInput: Identifiable {
    let id = UUID()
    var name: String
    var price: Double
    var quantity: Int
    var category: TaxCategory
}

struct AddNewListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    // Input fields
    @State private var listName: String = ""
    @State private var itemName: String = ""
    @State private var itemPrice: String = ""
    @State private var itemQuantity: String = ""
    @State private var selectedCategory: TaxCategory?

    @State private var shoppingList: [ItemInput] = []

    // Fetch all tax categories
    @FetchRequest(
        entity: TaxCategory.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TaxCategory.name, ascending: true)]
    ) var categoryList: FetchedResults<TaxCategory>

    // Computed totals
    var totalBeforeTax: Double {
        shoppingList.reduce(0) { total, item in
            let subtotal = item.price * Double(item.quantity)
            return total + subtotal
        }
    }

    var totalTax: Double {
        shoppingList.reduce(0) { $0 + ($1.price * Double($1.quantity) * $1.category.taxRate) }
    }

    var totalAfterTax: Double {
        totalBeforeTax + totalTax
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack{
                    Text("New Shopping List")
                        .font(.title)
                        .fontWeight(.bold)

                    TextField("List Name", text: $listName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Divider()

                    Group {
                        TextField("Item Name", text: $itemName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Price", text: $itemPrice)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)

                        TextField("Quantity", text: $itemQuantity)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)

                        Picker("Select Category", selection: $selectedCategory) {
                            Text("Choose category").tag(nil as TaxCategory?)

                            ForEach(categoryList, id: \.self) { category in
                                Text(category.name ?? "").tag(category as TaxCategory?)
                            }
                        }

                        Button("Add Item") {
                            addItem()
                        }
                        .disabled(itemName.isEmpty || itemPrice.isEmpty || itemQuantity.isEmpty || selectedCategory == nil)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }

                    Divider()

                    // List of added items
                    Text("Items")
                        .font(.headline)

                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(shoppingList.enumerated()), id: \.element.id) { index, item in
                            let subtotal = item.price * Double(item.quantity)
                            let tax = subtotal * item.category.taxRate

                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text("Qty: \(item.quantity) • \(item.category.name ?? "")")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text("Subtotal: $\(subtotal, specifier: "%.2f") • Tax: $\(tax, specifier: "%.2f")")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Button(action: {
                                    deleteItem(at: index)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    Divider()
                    Spacer()

                    // Total Summary
                    VStack(alignment: .trailing) {
                        Text("Summary")
                            .font(.headline)
                        Text("Total Before Tax: $\(totalBeforeTax, specifier: "%.2f")")
                        Text("Total Tax: $\(totalTax, specifier: "%.2f")")
                        Text("Total After Tax: $\(totalAfterTax, specifier: "%.2f")")
                    }

                    Button("Save List") {
                        saveShoppingList()
                    }
                    .disabled(listName.isEmpty || shoppingList.isEmpty)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
        }
    }

    func addItem() {
        guard
            let price = Double(itemPrice),
            let qty = Int(itemQuantity),
            let category = selectedCategory
        else { return }

        let newItem = ItemInput(name: itemName, price: price, quantity: qty, category: category)
        shoppingList.append(newItem)

        // Clear inputs
        itemName = ""
        itemPrice = ""
        itemQuantity = ""
        selectedCategory = nil
    }
    
    private func deleteItem(at index: Int) {
        shoppingList.remove(at: index)
    }

    func saveShoppingList() {
        let newList = ShoppingList(context: viewContext)
        newList.id = UUID()
        newList.name = listName
        newList.dateCreated = Date()

        for item in shoppingList {
            let newItem = Item(context: viewContext)
            newItem.name = item.name
            newItem.price = item.price
            newItem.quantity = Int16(item.quantity)
            newItem.category = item.category.name
            newItem.taxRate = item.category.taxRate // ✅ This is the new line
            newItem.shoppingList = newList
        }

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving list: \(error)")
        }
    }
}

#Preview {
    AddNewListView()
}
