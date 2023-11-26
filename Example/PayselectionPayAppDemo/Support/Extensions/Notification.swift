//
//  NSNotification.swift
//  PayselectionPayAppDemo
//
//  Created by  on 17.11.23.
//

import Foundation

extension NSNotification.Name {
    static let fieldsChanged = NSNotification.Name(Bundle.main.bundleIdentifier! + ".fieldsChanged")
    static let dismissPayment = NSNotification.Name(Bundle.main.bundleIdentifier! + ".dismissPayment")
}
