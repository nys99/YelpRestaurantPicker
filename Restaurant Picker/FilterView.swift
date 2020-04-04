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
    @State private var eating_time = Date()
    @State var expand = false
    @State var list = ["value1", "value2", "value3"]
    @State var index = 0
    @State var show_autocomplete = false
    @State var autocomplete_results: [String] = []
    
    @ObservedObject var locationManager = LocationManager()
    
    let date_formatter = DateFormatter()
    
    init() {
        date_formatter.dateFormat = "h:mm a"
    }
    
    static var prices = ["$", "$$", "$$$", "$$$$"]
    static var establishments = ["Restuarant", "Bar", "Seach"]
    static var meals = ["Breakfast", "Brunch", "Lunch", "Dinner"]
    static var distances = ["4 Blocks", "1 mile", "2 miles", "5 miles"]
    
    var body: some View {
        let search_text_binding = Binding<String>(get: {
            self.search_text
        }, set: {
            self.search_text = $0
            // do whatever you want here
            if self.search_text != "" {
                let lat = self.locationManager.lastLocation!.coordinate.latitude
                let long = self.locationManager.lastLocation!.coordinate.longitude
                YelpService().getAutocomplete(text: self.search_text, lat: lat, long: long, completion: { res in
                    self.autocomplete_results = res!
                })
            }
        })
        return VStack {
            // Rest/Bar Picker
            // Price Picker
            Picker(selection: self.$establishment_type, label: Text("")) {
                ForEach(0 ..< FilterView.establishments.count) {
                    Text(FilterView.self.establishments[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
                .padding()
            
            // if restuarnat was picked, let them pick what meal
            if (self.establishment_type == 0) {
                Picker(selection: self.$meal_type, label: Text("")) {
                    ForEach(0 ..< FilterView.meals.count) {
                        Text(FilterView.self.meals[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .padding()
            } else if (self.establishment_type == 2) {  // search bar
                VStack {
                    TextField("Feeling Decisive??? Seach!", text: search_text_binding, onEditingChanged: { editing in
                        self.show_autocomplete = editing
                    })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    if show_autocomplete && search_text != "" {
                        List(autocomplete_results, id: \.self) { res in
                            Text(res).onTapGesture {
                                self.search_text = res
                                UIApplication.shared.endEditing()
                            }
                        }
                    }
                }
            }
            
            // Time to eat at
            Button(action: {
                self.expand.toggle()
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray)
                    .overlay(
                        Text("I'm finna eat at: \(date_formatter.string(from: eating_time))")
                            .foregroundColor(.white)
                ).frame(width: 270, height: 30)
                    .shadow(radius: 10)
            }.padding()
            
            if expand {
                DatePicker("", selection: $eating_time, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .overlay(
                        GeometryReader { gp in
                            VStack {
                                Button(action: {
                                    self.expand.toggle()
                                }) {
                                    Text("Done")
                                        .font(.system(size: 42))
                                        .foregroundColor(.red)
                                        .padding(.vertical)
                                        .frame(width: gp.size.width)
                                }.background(Color.white)
                                Spacer()
                            }
                            .frame(width: gp.size.width, height: gp.size.height - 12)
                            .border(Color.black, width: 8)
                        }
                )
            }
            
            
            
            // Price Picker
            Picker(selection: self.$price, label: Text("Pick a max Price")) {
                ForEach(0 ..< FilterView.prices.count) {
                    Text(FilterView.self.prices[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
                .padding()
            
            // Distance
            Picker(selection: self.$distance, label: Text("")) {
                ForEach(0 ..< FilterView.distances.count) {
                    Text(FilterView.self.distances[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
                .padding()
            
            // Nav to next page
            NavigationLink(destination: PickerView(price: self.$price, distance: self.$distance, establishment_type: self.$establishment_type, meal_type: self.$meal_type, search_text: self.$search_text, eating_time: self.$eating_time)) {
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

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
