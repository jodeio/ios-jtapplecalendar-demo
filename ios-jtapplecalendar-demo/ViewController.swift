//
//  ViewController.swift
//  ios-jtapplecalendar-demo
//
//  Created by Joshua de Guzman on 06/06/2018.
//  Copyright © 2018 xrojan. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    // MARK: - Outlet declaration
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    // MARK: - Variable declaration
    let formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // MARK: Initialization
        scrollToDateToday()
        setUpVisibleDates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Render Calendar
    private func scrollToDateToday(){
        calendarView.scrollToDate(Date())
    }
    
    private func setUpVisibleDates(){
        calendarView.visibleDates { (visibleDates) in
            self.setUpCalendarViews(from: visibleDates)
        }
    }
    
    private func setUpCalendarViews(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        print("Year: \(formatter.string(from: date))")
        formatter.dateFormat = "MMMM"
        print("Month: \(formatter.string(from: date))")
    }
    
    private func renderCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else { return }
        formatter.dateFormat = "yyyy MM dd"
        if formatter.string(from: Date()) == formatter.string(from: cellState.date) && cellState.dateBelongsTo == .thisMonth {
            validCell.dateLabel.textColor = Color.TODAY
        } else if cellState.date < Date() && cellState.dateBelongsTo == .thisMonth{
            validCell.dateLabel.textColor = UIColor.init(rgb: 0xbdc3c7)
        }else {
            if cellState.isSelected {
                if cellState.dateBelongsTo == .thisMonth {
                    validCell.dateLabel.textColor = Color.SELECTED_MONTH
                }
            } else {
                if cellState.dateBelongsTo == .thisMonth {
                    validCell.dateLabel.textColor = Color.SELECTED_MONTH
                } else {
                    validCell.dateLabel.textColor = Color.OUTSIDE_MONTH
                }
            }
        }
    }
    
    private func renderCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else { return }
        if cellState.isSelected && cellState.dateBelongsTo == .thisMonth {
            validCell.vSelected.isHidden = false
        }else{
            validCell.vSelected.isHidden = true
            validCell.backgroundColor = UIColor.clear
        }
    }
}

// MARK: Additional protocol classes
// JTAppleCalendar Protocols
// delegate and data source is set in the storyboard builder

// JTAppleCalendarViewDataSource Protocol
extension ViewController: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2000 01 01")!
        let endDate = formatter.date(from: "2080 01 01")!
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 5,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfRow,
                                                 firstDayOfWeek: .sunday,
                                                 hasStrictBoundaries: true)
        
        
        return parameters
    }
}

// JTAppleCalendarViewDelegate Protocol
extension ViewController: JTAppleCalendarViewDelegate{
    // MARK: - Important
    // More on willDisplay requirement https://github.com/patchthecode/JTAppleCalendar/issues/553
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        renderCellSelected(view: cell, cellState: cellState)
        renderCellTextColor(view: cell, cellState: cellState)
        cell.layoutIfNeeded()
    }
    
    // Individual calendar cell instance
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        
        renderCellSelected(view: cell, cellState: cellState)
        renderCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    // Scroll identifier
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpCalendarViews(from: visibleDates)
    }
    
    // Header event on date change
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "CalendarHeader", for: indexPath) as! CalendarHeader
        formatter.dateFormat = "YYYY"
        header.lbYear.text = formatter.string(from: range.start).uppercased()
        formatter.dateFormat = "MMMM"
        header.lbMonth.text = formatter.string(from: range.start).uppercased()
        
        return header
    }
    
    // MARK: - Important
    // Requirement to make header from the previously set method visible
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    // MARK: - User Events
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        renderCellSelected(view: cell, cellState: cellState)
        renderCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        renderCellSelected(view: cell, cellState: cellState)
        renderCellTextColor(view: cell, cellState: cellState)
    }
}
