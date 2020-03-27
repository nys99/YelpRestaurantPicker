//
//  FilterView.swift
//  Restaurant Picker
//
//  Created by Nikhil Sharma on 3/16/20.
//  Copyright © 2020 Nikhil Sharma. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    
    @State private var distance = 0
    @State private var price = 0
    @State private var establishment_type = 0
    @State private var meal_type = 0
    @State private var search_text = ""
    
    static var prices = ["$", "$$", "$$$", "$$$$"]
    static var establishments = ["Restuarant", "Bar", "Seach"]
    static var meals = ["Breakfast", "Brunch", "Lunch", "Dinner"]
    static var distances = ["4 Blocks", "1 mile", "2 miles", "5 miles"]
    
    var body: some View {
            VStack {
                // Rest/Bar Picker
                // Price Picker
                // TODO select individual prices
                Picker(selection: self.$establishment_type, label: Text("")) {
                    ForEach(0 ..< FilterView.establishments.count) {
                        Text(FilterView.self.establishments[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.leading, 40)
                    .padding(.trailing, 40)
                    .padding(.bottom, 40)
                
                // if restuarnat was picked, let them pick what meal
                if (self.establishment_type == 0) {
                    Picker(selection: self.$meal_type, label: Text("")) {
                        ForEach(0 ..< FilterView.meals.count) {
                            Text(FilterView.self.meals[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding(.leading, 40)
                        .padding(.trailing, 40)
                        .padding(.bottom, 40)
                } else if (self.establishment_type == 2) {  // search bar
                    TextField("Feeling Decisive??? Seach!", text: self.$search_text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 40)
                        .padding(.trailing, 40)
                        .padding(.bottom, 40)
                }
                
                // Price Picker
                // TODO select individual prices
                Picker(selection: self.$price, label: Text("Pick a max Price")) {
                    ForEach(0 ..< FilterView.prices.count) {
                        Text(FilterView.self.prices[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.leading, 40)
                    .padding(.trailing, 40)
                    .padding(.bottom, 40)
                
                // Distance
                Picker(selection: self.$distance, label: Text("")) {
                    ForEach(0 ..< FilterView.distances.count) {
                        Text(FilterView.self.distances[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.leading, 40)
                    .padding(.trailing, 40)
                    .padding(.bottom, 40)
                
                // Nav to next page
                NavigationLink(destination: PickerView(price: self.$price, distance: self.$distance, establishment_type: self.$establishment_type, meal_type: self.$meal_type, search_text: self.$search_text)) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray)
                        .overlay(
                            Text("GOOO 2 pckr")
                                .foregroundColor(.white)
                    ).frame(width: 150, height: 30)
                        .shadow(radius: 10)
                }
            }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
