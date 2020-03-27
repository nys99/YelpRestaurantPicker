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
    func getRestuarants(lat: Double, long: Double, price: Int, distance: Int, est_type: Int, meal_type: Int, search_text: String, completion: @escaping ([CDYelpBusiness]?) -> Void)  {
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
        if (est_type == 0) {
            // restaurant, append the meal type
            query.append(FilterView.meals[meal_type])
        } else if (est_type == 1) {
            // not rest, so append establishment type (bar)
            query.append(FilterView.establishments[est_type])
        } else {
            // search
            query.append(search_text)
        }
        
        var businesses: [CDYelpBusiness] = []
        print (lat)
        print (long)
        print (distance_in_meters)
        YelpClient.shared.apiClient.searchBusinesses(byTerm: query,
                                        location: nil,
                                        latitude: lat,
                                        longitude: long,
                                        radius: distance_in_meters,
                                        categories: nil,
                                        locale: nil,
                                        limit: 20,
                                        offset: nil,
                                        sortBy: .bestMatch,
                                        priceTiers: prices,
                                        openNow: nil, // TODO change these
                                        openAt: nil,
                                        attributes: nil) { (response) in
                                            if let response = response {
                                                // do something clever here?
                                                businesses = response.businesses!
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
}
