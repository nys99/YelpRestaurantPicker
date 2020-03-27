//
//  ChosenView.swift
//  Restaurant Picker
//
//  Created by Nikhil Sharma on 3/21/20.
//  Copyright © 2020 Nikhil Sharma. All rights reserved.
//

import SwiftUI
import CDYelpFusionKit

struct ChosenView: View {
    
    var chosen_res: CDYelpBusiness
    
    init(chosen_res: CDYelpBusiness) {
        self.chosen_res = chosen_res
        print(chosen_res.toJSON())
        
    }
    
    var body: some View {
        VStack {
            Text("Congrats for being decisive for once in yo life")
                .padding()
            
            VStack {
                // name of res
                Text(chosen_res.name!).font(.largeTitle).bold()
                // image
                ImageViewContainer(imageUrl: chosen_res.imageUrl!.absoluteString)
                // url
                Text("Website").onTapGesture {
                    UIApplication.shared.open(self.chosen_res.url!)
                }
                // address
                
                Text(chosen_res.location!.displayAddress![0])
                Text(chosen_res.location!.displayAddress![1])
            }.padding()
            
            NavigationLink(destination: FilterView()) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray)
                    .overlay(
                        Text("Wait, I'm not decisive... again please")
                            .foregroundColor(.white)
                ).frame(width: 300, height: 30)
                    .shadow(radius: 10)
            }.padding()
        }
    }
}

struct ChosenView_Previews: PreviewProvider {
    static var previews: some View {
        ChosenView(chosen_res: CDYelpBusiness(JSON: ["phone": "+14159561760", "distance": 224.64743031891933, "is_closed": false, "location": ["address3": "", "address2": "", "zip_code": "94102", "state": "CA", "city": "San Francisco", "display_address": ["154 Ellis St", "San Francisco, CA 94102"], "country": "US", "address1": "154 Ellis St"], "price": "$", "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/bnGv8c7Ct2PoNE0FM3QLpQ/o.jpg", "review_count": 294, "name": "Daniel\'s Cafe", "coordinates": ["longitude": -122.4088907, "latitude": 37.7855284], "url": "https://www.yelp.com/biz/daniels-cafe-san-francisco-2?adjust_creative=CToNLBgpsWapmNhH__JElQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=CToNLBgpsWapmNhH__JElQ", "categories": [["alias": "coffee", "title": "Coffee & Tea"], ["title": "Bagels", "alias": "bagels"], ["alias": "delis", "title": "Delis"]], "transactions": ["delivery"], "id": "_7PmCSs1oEGLevlonhdFRw", "rating": 4.0, "display_phone": "(415) 956-1760"])!)
    }
}
