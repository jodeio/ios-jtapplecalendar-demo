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
    @IBOutlet weak var tvEvents: UITableView!
    
    // MARK: - Variable declaration
    // var events = [String]()
    // var events = ["2018/06/04","2018/06/07","2018/06/08","2018/06/10","2018/07/10"]
    var events = [[Event]]()
    let formatter = DateFormatter()
    
    // MARK: - Date Event Specific Changes
    var selectedEventIndex = -1 // Default if no events it set for the selected date
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // MARK: Initialization
        populateEvents()
        scrollToDateToday()
        setUpVisibleDates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Event Population
    private func populateEvents(){
        // Group dates by day (specific date)
        // Local events assigning
        formatter.dateFormat = "yyyy/MM/dd"
        events.append([
                    Event(name: "Independence Day", date: formatter.date(from: "2018/06/12"), type: Keys.HOLIDAY),
                    Event(name: "Mark's Birthday", date: formatter.date(from: "2018/06/12"), type: Keys.BIRTHDAY),
                ]
            )
        
        events.append([
                    Event(name: "Eid al Fitr", date: formatter.date(from: "2018/06/15"), type: Keys.SPECIAL_HOLIDAY)
            ]
        )

        events.append([
                    Event(name: "Test Holiday", date: formatter.date(from: "2018/07/12"), type: Keys.SPECIAL_HOLIDAY),
                    Event(name: "Test Birthday", date: formatter.date(from: "2018/07/12"), type: Keys.BIRTHDAY),
                    Event(name: "Test Birthday 2", date: formatter.date(from: "2018/07/12"), type: Keys.BIRTHDAY),
                    Event(name: "Test Birthday 3", date: formatter.date(from: "2018/07/12"), type: Keys.BIRTHDAY)
            ]
        )

        
        events.append([
                    Event(name: "Test Holiday", date: formatter.date(from: "2018/07/15"), type: Keys.SPECIAL_HOLIDAY),
                    Event(name: "Test Birthday", date: formatter.date(from: "2018/07/15"), type: Keys.BIRTHDAY)
                ]
            )
        
        // You can call your api to append dates to the events array here
        // Be minded with the format
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
        } else if cellState.date < Date() && cellState.dateBelongsTo == .thisMonth {
            if cellState.isSelected {
                validCell.dateLabel.textColor = UIColor.white
            }else{
                validCell.dateLabel.textColor = Color.OUTSIDE_MONTH
            }
        }else {
            if cellState.isSelected {
                validCell.dateLabel.textColor = UIColor.white
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
        if cellState.isSelected {
            validCell.vSelected.isHidden = false
        }
        else{
            validCell.vSelected.isHidden = true
            validCell.backgroundColor = UIColor.clear
        }
        
    }
    
    // Render events styles on the calendar
    private func renderCellEvents(view: JTAppleCell, cellState: CellState){
        guard let validCell = view as? CalendarCell else { return }
        formatter.dateFormat = "yyyy/MM/dd"
        let index = getEventDateIndex(date: cellState.date)
        
        if(events.count > 0 && index != -1 && events[index].contains { $0.date == cellState.date }){
            validCell.vEventIndicator.isHidden = false
        }else{
            validCell.vEventIndicator.isHidden = true
        }
    }
    
    // Validates if the current date has events
    private func getEventDateIndex(date: Date) -> Int{
        var index = 0
        for i in 0..<events.count{
            for j in 0..<events[i].count{
                if(events[i][j].date == date){
                    index = i
                    return index
                }
            }
        }
        return -1
    }
    
    // Sets selected event details
    private func setSelectedEventIndex(selectedEventIndex: Int) {
        self.selectedEventIndex = selectedEventIndex
        
        // Reload EventsTableView
        tvEvents.reloadData()
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
        renderCellEvents(view: cell, cellState: cellState)
        
        cell.layoutIfNeeded()
    }
    
    // Individual calendar cell instance
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        
        renderCellSelected(view: cell, cellState: cellState)
        renderCellTextColor(view: cell, cellState: cellState)
        renderCellEvents(view: cell, cellState: cellState)
        
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
        
        cell?.bounce()
        
        setSelectedEventIndex(selectedEventIndex: getEventDateIndex(date: date))
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        renderCellSelected(view: cell, cellState: cellState)
        renderCellTextColor(view: cell, cellState: cellState)
        
        cell?.bounce()
        
        setSelectedEventIndex(selectedEventIndex: getEventDateIndex(date: date))
    }
}

// TableViewDelegateProtocol
extension ViewController: UITableViewDelegate{

}

// TableViewDataSourceProtocol
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If there is no events for the selected date (-1 const), the default value will be assigned to 0 count
        return selectedEventIndex == -1 ? 0 : events[selectedEventIndex].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell

        formatter.dateFormat = "yyyy MM dd"
        cell.lbEventName.text = events[selectedEventIndex][indexPath.row].name
        cell.lbEventDate.text = formatter.string(from: events[selectedEventIndex][indexPath.row].date)
        
        return cell
    }
}
