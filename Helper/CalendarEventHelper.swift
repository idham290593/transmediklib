//
//  CalendarEventHelper.swift
//  Pasien
//
//  Created by Adam M Riyadi on 24/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import EventKit

class EventHelper {
    static func addEventToCalendar(id: String, title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
            DispatchQueue.global(qos: .background).async { () -> Void in
                let eventStore = EKEventStore()

                eventStore.requestAccess(to: .event, completion: { (granted, error) in
                    if (granted) && (error == nil) {
                        let alarm2day = EKAlarm(relativeOffset: (-86400 * 2)) //2 day
                        let alarm1day = EKAlarm(relativeOffset: -86400) //1 day
                        
                        let event = EKEvent(eventStore: eventStore)
                        event.title = title
                        event.startDate = startDate
                        event.endDate = endDate
                        event.isAllDay = true
                        event.notes = description
                        event.calendar = eventStore.defaultCalendarForNewEvents
                        
                        event.addAlarm(alarm2day)
                        event.addAlarm(alarm1day)
                        do {
                            try eventStore.save(event, span: .thisEvent)
                        } catch let e as NSError {
                            completion?(false, e)
                            return
                        }
                        completion?(true, nil)
                    } else {
                        completion?(false, error as NSError?)
                    }
                })
            }
        }

}
