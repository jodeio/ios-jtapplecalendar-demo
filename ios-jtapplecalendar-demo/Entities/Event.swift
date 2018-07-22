//
//  Event.swift
//  ios-jtapplecalendar-demo
//
//  Created by Joshua de Guzman on 07/06/2018.
//  Copyright © 2018 xrojan. All rights reserved.
//

import ObjectMapper

struct Event{
    var name: String!
    var date: String!
    var type: String!
}


extension Event: Mappable {
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        date <- map["date"]
        type <- map["type"]
    }
}
