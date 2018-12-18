//
//  APIManager.swift
//  FastEat
//
//  Created by Danny LIP on 4/11/2018.
//  Copyright © 2018 Danny LIP. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    
    static let domainName = "http://demo5582425.mockable.io"
    
    typealias SuccessCallBack = (Bool, [Restaurant]) -> ()
    
    static private func validateStatusCode(response: DataResponse<Any>) -> Bool {
        print("Success: \(response.result.isSuccess)")
        
        let statusCode = response.response?.statusCode
        print("Status Code: \(String(describing: statusCode))")
        
        switch statusCode {
        case 200:
            return true
        default:
            print("Erorr Status Code: \(String(describing: statusCode))")
            return false
        }
    }
    
    static func getRestaurantInfo(callBack: @escaping SuccessCallBack) {
        Alamofire.request("\(domainName)/restaurants").responseJSON { (response) in

            let isSuccessful = validateStatusCode(response: response)
            var restList = [Restaurant]()

            if isSuccessful,
                let responseJsonStr = response.value,
                let restaurants = JSON(responseJsonStr).array
            {
                restaurants.forEach { restaurant in
                    restList.append(Restaurant(json: restaurant))
                }
            }
            callBack(isSuccessful, restList)
        }
    }
}
