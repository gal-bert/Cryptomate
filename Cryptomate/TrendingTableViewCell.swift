//
//  TrendingTableViewCell.swift
//  Cryptomate
//
//  Created by Kevin Putra Yonathan on 10/01/22.
//

import UIKit

protocol TrendingTableViewDelegate {
    func onClick(id:String)
}

class TrendingTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    
    var arrTrendings = [Coin]()
    var trendingTableViewDelegate:TrendingTableViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        trendingCollectionView.dataSource = self
        trendingCollectionView.delegate = self
        
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
                        
                        let urlString2 = "https://api.coingecko.com/api/v3/coins/\(id)"
                        let url2 = URL(string: urlString2)!
                        let req2 = URLRequest(url: url2)
                        
                        var usd:Double?
                        var percentChange:Double?
                        
                        let session2 = URLSession.shared
                        let task2 = session2.dataTask(with: req2) { data, response, error in
                            if error == nil {
                                do{
                                    let root2 = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                                    let mktData = root2["market_data"] as! [String:Any]
                                    
                                    let currentPrice = mktData["current_price"] as! [String:Any]
                                    usd = currentPrice["usd"] as? Double
                                    percentChange = mktData["price_change_percentage_24h"] as? Double
                                                                
                                    self.arrTrendings[row].currentPrice = usd!
                                    self.arrTrendings[row].percentChange = percentChange!
                                    let indexPath = IndexPath(row: row, section: 0)
                                    DispatchQueue.main.async {
//                                        self.trendingCollectionView.reloadItems(at: [indexPath])
                                        self.trendingCollectionView.reloadData()
                                    }
                                }
                                catch {
                                    
                                }
                            }
                            else {
                                print(error?.localizedDescription)
                            }
                        }
                        task2.resume()
                        
                        let imageURL = URL(string: coin.imageUrl)!
                        let imageTask = session.dataTask(with: imageURL) { data, response, error in

                            if error == nil {
                                self.arrTrendings[row].imageThumb = UIImage(data: data!)
                                let indexPath = IndexPath(row: row, section: 0)
                                DispatchQueue.main.async {
//                                    self.trendingCollectionView.reloadItems(at: [indexPath])
                                    self.trendingCollectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTrendings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCollectionViewCell", for: indexPath) as! TrendingCollectionViewCell
        
        cell.layer.borderColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.00).cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 5.0
        
        let coin = arrTrendings[indexPath.row]
        
        cell.trendingImage.image = coin.imageThumb
        cell.trendingSymbol.text = coin.symbol
        cell.trendingPrice.text = Helper.formatPrice(price: coin.currentPrice)
        cell.trendingChange.textColor = Helper.formatChange(change: coin.percentChange)
        cell.trendingChange.text = "\(String(format: "%.2f", coin.percentChange))%"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 135, height: 115)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = arrTrendings[indexPath.row].id
        trendingTableViewDelegate?.onClick(id: id)
    }
    
    
    
}


