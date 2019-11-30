//
//  AlertManager.swift
//  DiaryApp
//
//  Created by Gavin Butler on 29-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit


//class AlertManager {
//    
//    func generateSimpleAlert(withTitle title: String, message: String) {
//        if let window = alertWindow(), let rootViewController = window.rootViewController {
//            window.makeKeyAndVisible()
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            alertController.addAction(okAction)
//            rootViewController.present(alertController, animated: true, completion: nil)
//        }
//    }
//    
//    private func alertWindow() -> UIWindow? {
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        window.rootViewController = UIViewController(nibName: nil, bundle: nil)
//        window.backgroundColor = UIColor.clear
//        window.windowLevel = UIWindow.Level.alert
//        return window
//    }
//    
//}


//I would rather create an extension on UIWindow like this. Reason for this is that you don't need to instantiate another object to present the alert. Just call the presentAlert method and you're good.
extension UIWindow {
    var alertWindow: UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController(nibName: nil, bundle: nil)
        window.backgroundColor = UIColor.clear
        window.windowLevel = UIWindow.Level.alert
        return window
    }
    
    func presentAlert(with title: String?, message: String?, hanlder: ((UIAlertAction) -> Void)? = nil) {
        let window = alertWindow
        let rootViewController = window.rootViewController
        window.makeKeyAndVisible()
        let okAction = UIAlertAction(title: "OK", style: .default, handler: hanlder)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(okAction)
        
        guard let rootVC = rootViewController else { return }
        rootVC.present(alertController, animated: true)
    }
}
