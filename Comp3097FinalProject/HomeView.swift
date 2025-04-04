//
//  HomeView.swift
//  Comp3097FinalProject
//
//  Created by Nut Jaroensri on 2025-04-03.
//
//  Author:
//  Nut Jaroensri 101422089
//  Paradee Supapian 101374958


import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: ShoppingList.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingList.dateCreated, ascending: false)]
    ) var shoppingLists: FetchedResults<ShoppingList>
    
    let buttonWidth: CGFloat = 220
    var body: some View {
        NavigationView{
            VStack{
                Text("ShopList")
                    .padding(.bottom)
                
                Text("Recent Shopping List")
                // List show shopping lists
                List {
                    ForEach(shoppingLists, id: \.self) { list in
                        NavigationLink(destination: ShoppingListDetailsView(shoppingList: list)) {
                            VStack(alignment: .leading) {
                                Text(list.name ?? "---")
                                    .font(.headline)

                                if let date = list.dateCreated {
                                    Text(date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteShoppingList)
                }
                
                Spacer()
                
                // Add new list button to navigate to Add new shopping list screen
                NavigationLink(destination: AddNewListView()){
                    Label("Add New List", systemImage: "plus.circle.fill")
                        .padding()
                        .frame(width: buttonWidth)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // Manage category button to navigate to manage category screen
                NavigationLink(destination: CategoryTaxView()){
                    Label("Manage Category", systemImage: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90")
                        .padding()
                        .frame(width: buttonWidth)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            //.navigationTitle("Home")
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
    // Delete shopping list
    private func deleteShoppingList(at offsets: IndexSet) {
        for index in offsets {
            viewContext.delete(shoppingLists[index])
        }

        do {
            try viewContext.save()
        } catch {
            print("❌ Failed to delete shopping list: \(error)")
        }
    }
}

#Preview {
    HomeView()
}
