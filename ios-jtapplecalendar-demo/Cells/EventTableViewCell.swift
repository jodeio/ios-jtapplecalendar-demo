//
//  EventTableViewCell.swift
//  ios-jtapplecalendar-demo
//
//  Created by Joshua de Guzman on 07/06/2018.
//  Copyright © 2018 xrojan. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var lbEventName: UILabel!
    @IBOutlet weak var lbEventDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
