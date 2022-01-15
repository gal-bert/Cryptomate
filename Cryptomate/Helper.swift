//
//  Helper.swift
//  Cryptomate
//
//  Created by Gregorius Albert on 14/01/22.
//

import UIKit

class Helper {
    
    static func pushAlert(title:String, message:String) -> UIAlertController{
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        ))
        
        return alert
    }
    
    static func formatPrice(price: Double) -> String {
        if price < 0.01 {
            return "$\(String(format: "%.5f", price))"
        } else {
           return "$\(String(format: "%.2f", price))"
        }
    }
    
    static func formatChange(change: Double) -> UIColor {
        if change < 0 {
            return UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        } else if change > 0 {
            return UIColor(red: 0.25, green: 0.89, blue: 0.00, alpha: 1.00)
        }
        return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    
}
