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
    
}
