//
//  CategoryTaxView.swift
//  Comp3097FinalProject
//
//  Created by Nut Jaroensri on 2025-04-04.
//
//  Author:
//  Nut Jaroensri 101422089
//  Paradee Supapian 101374958

import SwiftUI
import CoreData

struct CategoryTaxView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: TaxCategory.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TaxCategory.name, ascending: true)]
    ) var categoryList: FetchedResults<TaxCategory>

    @State private var categoryName: String = ""
    @State private var taxRate: String = ""

    var body: some View {
        VStack() {
            Text("Manage Category")
                .padding(.bottom)

            TextField("Category Name", text: $categoryName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Tax Rate (%)", text: $taxRate)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: addCategoryTax) {
                Text("Add Category Tax")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.vertical)

            List {
                ForEach(categoryList, id: \.self) { category in
                    HStack {
                        Text(category.name ?? "---")
                        Spacer()
                        Text("\(category.taxRate * 100, specifier: "%.2f")%")
                            .foregroundColor(.gray)
                    }
                }
                .onDelete(perform: deleteCategory)
            }
        }
        .padding()
    }

    // Add category to storage
    private func addCategoryTax() {
        // input validation
        guard !categoryName.isEmpty, let rate = Double(taxRate) else { return }

        let newCategory = TaxCategory(context: viewContext)
        newCategory.name = categoryName
        newCategory.taxRate = rate / 100

        // save to CoreData
        do {
            try viewContext.save()
            categoryName = ""
            taxRate = ""
        } catch {
            print("Failed to save category: \(error)")
        }
    }

    // Delete category
    private func deleteCategory(at offsets: IndexSet) {
        for index in offsets {
            viewContext.delete(categoryList[index])
        }

        // save
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete category: \(error)")
        }
    }
}

#Preview {
    // Preview doesn't work with Core Data directly unless mocked
    Text("Preview not available")
}
