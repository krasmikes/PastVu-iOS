//
//  AppDelegate.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 06.05.2022.
//

import UIKit
import YandexMapsMobile

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let apiKey = dict["API_KEY"] as? String {
            YMKMapKit.setApiKey(apiKey)
        } else {
            YMKMapKit.setApiKey("your-api-key")
        }

        YMKMapKit.sharedInstance()

        return true
    }
}

