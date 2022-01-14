//
//  TrendingTableViewCell.swift
//  Cryptomate
//
//  Created by Thomas Ryouga Tanaka on 10/01/22.
//

import UIKit

class TrendingTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    
    var arrTrendings = [Coin]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trendingCollectionView.dataSource = self
        trendingCollectionView.delegate = self
        
//        trendingCollectionView.layer.borderColor = UIColor.black.cgColor
//        trendingCollectionView.layer.borderWidth = 3.0
//        trendingCollectionView.layer.cornerRadius = 3.0
        
        let urlString = "https://api.coingecko.com/api/v3/search/trending"
        let url = URL(string: urlString)!
        let req = URLRequest(url: url)
        
        let session = URLSession.shared
        let task = session.dataTask(with: req) { data, response, error in
            if error == nil {
                do {
                    let root = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    let results = root["coins"] as! [[String:Any]]
                    
                    for result in results {
                        
                        let item = result["item"] as! [String: Any]
                        let id = item["id"] as! String
                        
                        let coin = Coin(
                            id: id,
                            symbol: item["symbol"] as! String,
                            name: "",
                            imageUrl: item["small"] as! String,
                            currentPrice: 0,
                            percentChange: 0,
                            marketCap: 0,
                            totalVolume: 0,
                            high: 0,
                            low: 0
                        )
                        
                        let row = self.arrTrendings.count
                        self.arrTrendings.append(coin)
                        
                        let imageURL = URL(string: coin.imageUrl)!

                        let imageTask = session.dataTask(with: imageURL) { data, response, error in

                            if error == nil {
                                self.arrTrendings[row].imageThumb = UIImage(data: data!)
                                let indexPath = IndexPath(row: row, section: 0)
                                DispatchQueue.main.async {
                                    self.trendingCollectionView.reloadItems(at: [indexPath])
                                }
                            }
                            

                        }
                        imageTask.resume()
                    }
                    DispatchQueue.main.async {
                        self.trendingCollectionView.reloadData()
                    }
                }
                catch {
                    
                }
            }
            else {
                print(error!)
            }
        }
        task.resume()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTrendings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCollectionViewCell", for: indexPath) as! TrendingCollectionViewCell
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 3.0
        
        let coin = arrTrendings[indexPath.row]
        
        cell.trendingImage.image = coin.imageThumb
        cell.trendingSymbol.text = coin.symbol
        if coin.currentPrice < 0.01 {
            cell.trendingPrice.text = "$\(String(format: "%.5f", coin.currentPrice))"
        } else {
            cell.trendingPrice.text = "$\(String(format: "%.2f", coin.currentPrice))"
        }
        
        if coin.percentChange < 0 {
            cell.trendingChange.textColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        } else if coin.percentChange > 0 {
            cell.trendingChange.textColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 135, height: 115)
    }
    
}
