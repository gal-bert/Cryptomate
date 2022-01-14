//
//  Coin.swift
//  Cryptomate
//
//  Created by Gregorius Albert on 09/01/22.
//

import Foundation
import UIKit

struct Coin {
    
    let id:String
    let symbol:String
    let name:String
    var imageUrl:String
    var imageThumb:UIImage? = nil
    var currentPrice:Double = 0.0
    var percentChange:Double = 0.0
    let marketCap:Double
    let totalVolume:Double
    let high:Double
    let low:Double
    
}
