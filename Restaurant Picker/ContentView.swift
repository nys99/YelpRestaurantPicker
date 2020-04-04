//
//  ContentView.swift
//  Restaurant Picker
//
//  Created by Nikhil Sharma on 3/16/20.
//  Copyright © 2020 Nikhil Sharma. All rights reserved.
//

import SwiftUI
import CDYelpFusionKit

struct ContentView: View {
    
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to the Restaurant Picker!")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                
                Text("you indecisive shmuck :)")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                NavigationLink(destination: FilterView()) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray)
                        .overlay(
                            Text("GOOO")
                                .foregroundColor(.white)
                    ).frame(width: 150, height: 30)
                        .shadow(radius: 10)
                }
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

