//
//  CalendarCell.swift
//  ios-jtapplecalendar-demo
//
//  Created by Joshua de Guzman on 06/06/2018.
//  Copyright © 2018 xrojan. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var vSelected: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // MARK: - Render UI
        vSelected.layer.cornerRadius = vSelected.frame.height / 2
    }
}
