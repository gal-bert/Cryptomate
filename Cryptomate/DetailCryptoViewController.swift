//
//  DetailCryptoViewController.swift
//  Cryptomate
//
//  Created by Ivan Su on 1/6/22.
//

import UIKit

class DetailCryptoViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var athLabel: UILabel!
    @IBOutlet weak var atlLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var coinId:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Watchlist.checkIdExist(coinId: coinId!)
        let result = try! context.fetch(fetchRequest)
        
        if !result.isEmpty {
            saveBarButtonItem.image = UIImage(named: "fullheart")
        }

        let urlString = "https://api.coingecko.com/api/v3/coins/\(coinId!)"
        let url = URL(string: urlString)!
        
        let req = URLRequest(url: url)
        let session = URLSession.shared
        let detailTask = session.dataTask(with: req) { data, res, err in
            if err == nil {
                do {
                    let root = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    let name = root["name"] as! String
            
                    let description = root["description"] as! [String: String]
                    let descriptionEn = description["en"]
                    
                    let image = root["image"] as! [String: String]
                    let imageLarge = image["large"]
                    
                    
                    let marketData = root["market_data"] as! [String: Any]
                    
                    let volume = marketData["total_volume"] as! [String: Double]
                    let volumeUsd = volume["usd"]
                    
                    let currentPrice = marketData["current_price"] as! [String: Double]
                    let currentPriceUsd = currentPrice["usd"]
                    
                    let ath = marketData["ath"] as! [String: Double]
                    let athUsd = ath["usd"]
                
                    let atl = marketData["atl"] as! [String: Double]
                    let atlUsd = atl["usd"]
                    
                    let marketCap = marketData["market_cap"] as! [String: Double]
                    let marketCapUsd = marketCap["usd"]
                    
                    let high24h = marketData["high_24h"] as! [String: Double]
                    let high24hUsd = high24h["usd"]
                    
                    let low24h = marketData["low_24h"] as! [String: Double]
                    let low24hUsd = low24h["usd"]
                    
                    let priceChangePercentage24h = marketData["price_change_percentage_24h"] as! Double
                    
                    let imageURL = URL(string: imageLarge!)!

                    let imageTask = session.dataTask(with: imageURL) { data, response, error in

                        if error == nil {
                            DispatchQueue.main.async {
                                self.imageLogo.image = UIImage(data: data!)
                            }
                        }

                    }
                    imageTask.resume()
                    
                    DispatchQueue.main.async {
                        self.nameLabel.text = name
                        self.priceLabel.text = Helper.formatPrice(price: currentPriceUsd!)
                        self.changeLabel.text = "\(String(format: "%.2f", priceChangePercentage24h))%"
                        self.changeLabel.textColor = Helper.formatChange(change: priceChangePercentage24h)
                        self.athLabel.text = "ATH: $\(athUsd!)"
                        self.atlLabel.text = "ATL: $\(atlUsd!)"
                        self.marketCapLabel.text = "Market Cap: $\(marketCapUsd!)"
                        self.volumeLabel.text = "Volume: $\(volumeUsd!)"
                        self.highLabel.text = "24H High: $\(high24hUsd!)"
                        self.lowLabel.text = "24H Low: $\(low24hUsd!)"
                        
                        let html = NSString(string: descriptionEn!).data(using: String.Encoding.utf8.rawValue)
                        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
                        let htmlStr = try! NSAttributedString(data: html!, options: options,documentAttributes: nil)
                        self.descriptionTextView.attributedText = htmlStr
                    }
                    
                } catch {
                    print("Error JSON Serialization")
                }
            } else {
                print(err!.localizedDescription)
            }
        }
        
        detailTask.resume()
    }
    
    @IBAction func saveToWatchlist(_ sender: Any) {
        
        let fullheart = UIImage(named: "fullheart")
        let heart = UIImage(named: "heart")
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Watchlist.checkIdExist(coinId: coinId!)
        let result = try! context.fetch(fetchRequest)
        
        if result.isEmpty {
            do{
                let context = appDelegate.persistentContainer.viewContext
                let watchlist = Watchlist(context: context)
                watchlist.coinId = coinId
                context.insert(watchlist)
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            saveBarButtonItem.image = fullheart
        }
        else {
            let context = appDelegate.persistentContainer.viewContext
            context.delete(result[0])
            try! context.save()
            saveBarButtonItem.image = heart
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
