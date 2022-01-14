//
//  TrendingCollectionViewCell.swift
//  Cryptomate
//
//  Created by Thomas Ryouga Tanaka on 10/01/22.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var trendingImage: UIImageView!
    @IBOutlet weak var trendingSymbol: UILabel!
    @IBOutlet weak var trendingPrice: UILabel!
    @IBOutlet weak var trendingChange: UILabel!
    
    func setup(with coin: Coin) {
//        trendingImage.image = coin.imageThumb
//        trendingSymbol.text = coin.symbol
//        if coin.currentPrice < 0.01 {
//            trendingPrice.text = "$\(String(format: "%.5f", coin.currentPrice))"
//        } else {
//            trendingPrice.text = "$\(String(format: "%.2f", coin.currentPrice))"
//        }
//        
//        if coin.percentChange < 0 {
//            trendingChange.textColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
//        } else if coin.percentChange > 0 {
//            trendingChange.textColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
//        }
    }
}
