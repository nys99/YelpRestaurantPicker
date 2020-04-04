//
//  YelpService.swift
//  Restaurant Picker
//
//  Created by Nikhil Sharma on 3/18/20.
//  Copyright © 2020 Nikhil Sharma. All rights reserved.
//

import SwiftUI
import CDYelpFusionKit
import CoreLocation

final class YelpService {
    
    let METERS_IN_MILE: Int = 1609
        
    // returns list of num_res restuarants, in price category price, and distance radius (in miles) from cur location
    func getRestuarants(lat: Double, long: Double, price: Int, distance: Int, est_type: Int, meal_type: Int, search_text: String, eating_time: Date, completion: @escaping ([CDYelpBusiness]?) -> Void)  {
        // TODO change to select multiple
        var prices: [CDYelpPriceTier] = [];
        if (price == 0) {
            prices.append(CDYelpPriceTier.oneDollarSign)
        } else if (price == 1) {
            prices.append(CDYelpPriceTier.twoDollarSigns)
        } else if (price == 2) {
            prices.append(CDYelpPriceTier.threeDollarSigns)
        } else if (price == 3) {
            prices.append(CDYelpPriceTier.fourDollarSigns)
        }

        // distance
        var distance_in_meters = 0
        if (distance == 0) {
            distance_in_meters = 322 // 4 blocks
        } else if (distance == 1) {
            distance_in_meters = METERS_IN_MILE
        } else if (distance == 2) {
            distance_in_meters = 2 * METERS_IN_MILE
        } else if (distance == 3) {
            distance_in_meters = 5 * METERS_IN_MILE
        } else if (distance == 4) {
            distance_in_meters = 40000 // max distance
        }
        
        // establishment type
        var query = ""
        var categoires: [String] = []
        if (est_type == 0) {
            // restaurant, append the meal type
            if (FilterView.meals[meal_type] == "Breakfast") {
                categoires.append("breakfast_brunch")
            } else {
                query.append(FilterView.meals[meal_type])
                categoires.append("restaurants")
                categoires.append("food")
            }
        } else if (est_type == 1) {
            // not rest, so append establishment type (bar)
            query.append(FilterView.establishments[est_type])
            categoires.append("nightlife")
        } else {
            // search
            query.append(search_text)
        }
        
        
        var businesses: [CDYelpBusiness] = []
        // make call to the yelp api
        YelpClient.shared.apiClient.searchBusinesses(byTerm: query,
                                        location: nil,
                                        latitude: lat,
                                        longitude: long,
                                        radius: distance_in_meters,
                                        categories: nil,
                                        locale: nil,
                                        limit: 50,
                                        offset: nil,
                                        sortBy: .bestMatch,
                                        priceTiers: prices,
                                        openNow: nil, // TODO change these
                                        openAt: Int(eating_time.timeIntervalSince1970), // Filter by open at time
                                        attributes: nil) { (response) in
                                            if let response = response {
                                                businesses = response.businesses!
                                                // shuffle the results and pick 15 at random
                                                businesses.shuffle()
                                                businesses = Array(businesses.prefix(15))
                                            } else {
                                                print("Search Bus failed")
                                            }
                                            completion(businesses)
        }
    }
    
    // gets three photos for the given establishment
    func getRestaurantPhotos(id: String, completion: @escaping ([String]?) -> Void) {
        var photos: [String] = []
        YelpClient.shared.apiClient.fetchBusiness(forId: id, locale: nil) { (response) in
            if let response = response {
                if response.photos != nil {
                    photos = response.photos!
                }
            } else {
                print("Get business photos failed")
            }
            completion(photos)
        }
    }
    
    // get autocomplete results
    func getAutocomplete(text: String, lat: Double, long: Double, completion: @escaping ([String]?) -> Void) {
        var res: [String] = []
        YelpClient.shared.apiClient.autocompleteBusinesses(byText: text, latitude: lat, longitude: long, locale: nil, completion: { (response) in
            if let response = response {
                // append terms
                var index = 0
                while index < 3 && index < response.terms!.count {
                    res.append(response.terms![index].text!)
                    index += 1
                }
                // append businesses
                index = 0
                while index < 3 && index < response.businesses!.count {
                    res.append(response.businesses![index].name!)
                    index += 1
                }
                // append categories
                index = 0
                while index < 3 && index < response.categories!.count {
                    res.append(response.categories![index].title!)
                    index += 1
                }
            }
            completion(res)
        })
    }
}
