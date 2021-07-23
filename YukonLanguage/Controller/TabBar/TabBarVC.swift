//
//  TabBarVC.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/14/20.
//

import UIKit
import StoreKit
import UserNotifications

class TabBarVC: UITabBarController {
    
    var randomId: Int = Int.random(in: 0...6015)
    var welcomeData: [ItemsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeData = ItemsEntity.shared.getDataId(randomId)
        UserDefaults.standard.set(welcomeData[0].title, forKey: "TITLE")
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.sendNotification()
            default:
                break // Do nothing
            }
        }
        if !PaymentManager.shared.isPurchase() {
            DispatchQueue.main.async {
                let premium = self.storyboard?.instantiateViewController(withIdentifier: PremiumVC.className) as! PremiumVC
                premium.modalPresentationStyle = .fullScreen
                self.present(premium, animated: true, completion: nil)
            }
        } else {
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.sendNotification()
            default:
                break // Do nothing
            }
        }
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            (granted, error) in
            if granted {
                print("Yes")
            } else {
                print("No")
            }
        }
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = welcomeData[0].title
        content.body = welcomeData[0].locaziation()
        content.sound = UNNotificationSound.default
        
        // 3
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7200, repeats: true)
        
        let request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)
        
        // 4
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

}
