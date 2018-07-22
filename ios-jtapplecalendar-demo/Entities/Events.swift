//
//  Events.swift
//  ios-jtapplecalendar-demo
//
//  Created by Joshua de Guzman on 22/07/2018.
//  Copyright © 2018 xrojan. All rights reserved.
//

import ObjectMapper

struct Events{
    var date : String!
    var events : [Event]!
}

extension Events : Mappable {
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        date <- map["date"]
        events <- map["events"]
    }
}
