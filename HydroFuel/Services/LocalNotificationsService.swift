//
//  LocalNotificationsService.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/6/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

final class LocalNotificationsService {
    
    private static let notificationCenter = UNUserNotificationCenter.current()
    
    static func enqueueLocalNotification(body: String, badge: Int,
                                         info: [String: Any], toDate: Date) {
        
        let content = UNMutableNotificationContent()
        content.title = "Hydrofuel Reminder"
        content.body = body
        content.sound = UNNotificationSound.default
        content.badge = badge as NSNumber
        content.userInfo = info
        
        let date = toDate.toGlobalTime()
        let triggerDaily = Calendar.autoupdatingCurrent.dateComponents([.hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        let identifier = "UYLLocalNotification\(badge - 1)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request, withCompletionHandler: { (error) in
            guard let error = error else { return }
            assertionFailure(error.localizedDescription)
        })
    }
}
