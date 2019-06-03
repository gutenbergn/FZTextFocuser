//
//  UIApplication+TopViewController.swift
//
//  Created by Gutenberg Neto on 22/5/18.
//  Copyright © 2018 Fuze. All rights reserved.
//

import Foundation

// based on an answer to a Stack Overflow question:
// https://stackoverflow.com/questions/26667009/get-top-most-uiviewcontroller [GN]
public extension UIApplication {
    public static func topViewController(
        controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return self.topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return self.topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return self.topViewController(controller: presented)
        }
        
        return controller
    }
}
