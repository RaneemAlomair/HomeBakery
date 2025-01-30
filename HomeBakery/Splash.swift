//
//  Splash.swift
//  HomeBakery
//
//  Created by Raneem Alomair on 20/07/1446 AH.
//

import SwiftUI

struct Splash: View {
    @State private var isActive = true
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            if self.isActive {
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    Text("Home Bakery")
                        .font(.title)
                        .bold()
                        .foregroundColor(.brown1)
                    
                    Text("Baked to Perfection")
                        .font(.title)
                        .foregroundColor(.brown1)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            self.isActive = false
                        }
                    }
                }
            } else {
                Home()
            }
        }
    }
}

#Preview {
    Splash()
}
