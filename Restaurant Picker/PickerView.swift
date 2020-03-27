//
//  PickerView.swift
//  Restaurant Picker
//
//  Created by Nikhil Sharma on 3/17/20.
//  Copyright © 2020 Nikhil Sharma. All rights reserved.
//

import SwiftUI
import CDYelpFusionKit
import Combine
import WebKit

struct PickerView: View {
    
    // Filter params
    @Binding var price: Int
    @Binding var distance: Int
    @Binding var establishment_type: Int
    @Binding var meal_type: Int
    @Binding var search_text: String
    
    // used for tracking the restuarant picks
    @State var index1: Int = 0
    @State var index2: Int = 1
    @State var index_next: Int = 2
    @State var foundRes = false
    @State var pickedRes: CDYelpBusiness = CDYelpBusiness(JSON: [:])!
    @State var photos1: [String] = []
    @State var photos2: [String] = []
    
    // restuarant data from yelp
    @State var rests: [CDYelpBusiness] = []
    
    // Alert
    @State var showAlert = false
    
    // used for getting the current location
    @ObservedObject var locationManager = LocationManager()
    
    var body: some View {
        VStack() {
            // if rests is loaded display them
            if (self.rests.count > 0) {
                // rest 1
                ResView(rests: self.rests, index: self.index1, photos: self.$photos1)
                    .onTapGesture {
                        // if there are no more to pick from, set foundRes to navigate to next
                        if (self.index1 == self.rests.count - 1 || self.index2 == self.rests.count - 1) {
                            self.pickedRes = self.rests[self.index1]
                            self.foundRes = true
                        } else {  // load the next restuarant
                            self.index2 = self.index_next
                            self.index_next += 1
                        }
                        YelpService().getRestaurantPhotos(id: self.rests[self.index2].id!, completion: { (response) in
                            self.photos2 = response!
                        })
                }.padding()
                
                // neither button (For some reason the spacing is weird, I tried with spacers and get some weird overlap at times)
                Button(action: {
                    // res 1 or res 2 is the last rest (no res left)
                    if (self.index1 == self.rests.count - 1 || self.index2 == self.rests.count - 1) {
                        self.showAlert = true
                    } else if (self.index1 == self.rests.count - 2 || self.index2 == self.rests.count - 2) {  // res 1 or res 2 is 2nd to last (only 1 res left)
                        self.showAlert = true
                    } else {  // we chill rests r left
                        // change both
                        self.index1 = self.index_next
                        self.index_next += 1
                        self.index2 = self.index_next
                        self.index_next += 1
                        YelpService().getRestaurantPhotos(id: self.rests[self.index2].id!, completion: { (response) in
                            self.photos2 = response!
                        })
                        YelpService().getRestaurantPhotos(id: self.rests[self.index1].id!, completion: { (response) in
                            self.photos1 = response!
                        })
                    }
                }) {
                    // Neither Button
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray)
                        .overlay(
                            Text("Neither")
                                .foregroundColor(.white)
                    ).frame(width: 150, height: 30)
                        .shadow(radius: 10)
                }.alert(isPresented: self.$showAlert) {
                    // res 1 or res 2 is the last rest (no res left)
                    // alert menu (you suck, fucking pick one
                    if (self.index1 == self.rests.count - 1 || self.index2 == self.rests.count - 1) {
                        return Alert(title: Text("You Suck, please know that"), message: Text("There are no rests left, so pick one!"), dismissButton: .default(Text("Yes, I'm a shmuck")))
                    } else {
                        // res 1 or res 2 is 2nd to last (only 1 res left)
                        // *facepalm* navigate to chosen view (you are stuck with this cause you suck) || alert
                        return Alert(title: Text("You Suck, please know that"), message: Text("There is only 1 rests left, so pick one!"), dismissButton: .default(Text("Yes, I'm a shmuck")))
                    }
                }
                // rest 2
                ResView(rests: self.rests, index: self.index2, photos: self.$photos2)
                    .onTapGesture {
                        // if there are no more to pick from, set foundRes to navigate to next
                        if (self.index1 == self.rests.count - 1 || self.index2 == self.rests.count - 1) {
                            self.pickedRes = self.rests[self.index2]
                            self.foundRes = true
                        } else {  // load the next restuarant
                            self.index1 = self.index_next
                            self.index_next += 1
                        }
                        YelpService().getRestaurantPhotos(id: self.rests[self.index1].id!, completion: { (response) in
                            self.photos1 = response!
                        })
                }.padding()
            } else {  // not loaded
                Text("jussss wait breh")
            }
            
            // hidden nav link to go to next view when rest is picked (Also acts as a spacer to the bottom)
            NavigationLink(destination: ChosenView(chosen_res: self.pickedRes), isActive: self.$foundRes) {
                Text("")
            }.hidden()
            
        }.onAppear() {
            // get the lattitude and longitude of current location
            let lat = self.locationManager.lastLocation!.coordinate.latitude
            let long = self.locationManager.lastLocation!.coordinate.longitude
            print (lat)
            print (long)
            
            // make the call to the yelp API to get restuarant data
            let ys = YelpService()
            ys.getRestuarants(lat: lat, long: long, price: self.price, distance: self.distance, est_type: self.establishment_type, meal_type: self.meal_type, search_text: self.search_text, completion: { response in
                self.rests = response!
            })
            
        }
    }
}

struct ResView: View {
    
    var rests: [CDYelpBusiness]
    var index: Int
    
    @Binding var photos: [String]
    @State var photo_index = 0
    
    var body: some View {
        VStack {
            Text(self.rests[index].name!).font(.system(size: 25)).bold()
            // image
            if (photos.count > 0) {
                ImageViewContainer(imageUrl: self.photos[self.photo_index]).onTapGesture {
                    if (self.photo_index == self.photos.count - 1) {
                        self.photo_index = 0
                    } else {
                        self.photo_index += 1
                    }
                }
            } else {
                Circle().fill(Color.gray).frame(width: 200.0, height: 200.0).onTapGesture {
                    
                }
            }
            // rating, rating count
            Text(self.rests[index].rating!.description + " rating with " + self.rests[index].reviewCount!.description + " reviews")
            // categories
            if (self.rests[index].categories!.count > 0) {
                // TODO get this shit to scale
                HStack {
                    ForEach(0..<self.rests[index].categories!.count, id: \.self) { i in
                        Text(self.rests[self.index].categories![i].title!.description)
                    }
                }
            } else {
                Text("no categories beeerrrree")
            }
            // URL
            Text("Website").onTapGesture {
                UIApplication.shared.open(self.rests[self.index].url!)
            }
            
        }.onAppear() {
            YelpService().getRestaurantPhotos(id: self.rests[self.index].id!, completion: { (response) in
                self.photos = response!
            })
        }.overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 4)
            .scaledToFill()
        )
    }
}


struct ImageViewContainer: View {
    @ObservedObject var remoteImageURL: RemoteImageURL
    
    init(imageUrl: String) {
        remoteImageURL = RemoteImageURL(imageURL: imageUrl)
    }
    
    var body: some View {
        Image(uiImage: UIImage(data: remoteImageURL.data) ?? UIImage())
            .resizable()
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.black, lineWidth: 3.0))
            .frame(width: 200.0, height: 200.0)
    }
}

class RemoteImageURL: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    @Published var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    init(imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            DispatchQueue.main.async { self.data = data }
            
        }.resume()
    }
}

//struct PickerView_Previews: PreviewProvider {
//    static var previews: some View {
//
//    }
//}
