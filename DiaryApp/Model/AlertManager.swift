//
//  AlertManager.swift
//  DiaryApp
//
//  Created by Gavin Butler on 29-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit


class AlertManager {
    
    func generateSimpleAlert(withTitle title: String, message: String) {
        if let window = alertWindow(), let rootViewController = window.rootViewController {
            window.makeKeyAndVisible()
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(okAction)
            rootViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func alertWindow() -> UIWindow? {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController(nibName: nil, bundle: nil)
        window.backgroundColor = UIColor.clear
        window.windowLevel = UIWindow.Level.alert
        return window
    }
    
}
