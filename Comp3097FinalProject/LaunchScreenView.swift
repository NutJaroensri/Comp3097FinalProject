//
//  LaunchScreenVview.swift
//  Comp3097FinalProject
//
//  Created by Nut Jaroensri on 2025-04-03.
//
//  Author:
//  Nut Jaroensri 101422089
//  Paradee Supapian 101374958

import SwiftUI

struct LaunchScreenView: View {
    @State private var isActive = false
    var body: some View {
        if isActive {
            HomeView()
        }else{
            VStack{
                Image(systemName: "cart.fill.badge.plus").font(.system(size: 70))
                Text("ShopList").font(.largeTitle)
                    .foregroundColor(.blue)
                Text("Nut Jaroensri").font(.callout)
                Text("Paradee Supapian").font(.callout)
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    self.isActive = true
                }
            }
        }
        
    }
}

#Preview {
    LaunchScreenView()
}
