//
//  Status.swift
//  ios-jtapplecalendar-demo
//
//  Created by Joshua de Guzman on 22/07/2018.
//  Copyright © 2018 xrojan. All rights reserved.
//

import ObjectMapper

struct Response {
    
}

struct ResponseArray<T>: Mappable where T: Mappable{
    var statusCode: Int!
    var results: [T]!
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        statusCode <- map["status_code"]
        results <- map["results"]
    }

}
