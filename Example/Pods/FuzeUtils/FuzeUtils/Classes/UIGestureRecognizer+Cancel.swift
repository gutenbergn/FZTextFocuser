//
//  UIGestureRecognizer+Cancel.swift
//
//  Created by Gutenberg Neto on 6/8/18.
//  Copyright © 2018 Fuze. All rights reserved.
//

import Foundation

public extension UIGestureRecognizer {
    public func cancel() {
        guard self.isEnabled else {
            return
        }
        
        self.isEnabled = false
        self.isEnabled = true
    }
}
