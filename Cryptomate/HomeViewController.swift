//
//  ViewController.swift
//  Cryptomate
//
//  Created by Gregorius Albert on 19/12/21.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var trendingTableView: UITableView!
    
    var arrCoins = [Coin]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homeTableView.rowHeight = 65
        self.trendingTableView.rowHeight = 119
        
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=false"
        let url = URL(string: urlString)!
        let req = URLRequest(url: url)
        
        let session = URLSession.shared
        let task = session.dataTask(with: req) { data, response, error in
            if error == nil {
                do {
                    let root = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [Any]
                    let results = root as! [[String:Any]]
                    
                    for result in results {
                        
                        let coin = Coin(
                            id: result["id"] as! String,
                            symbol: result["symbol"] as! String,
                            name: result["name"] as! String,
                            imageUrl: result["image"] as! String,
                            currentPrice: result["current_price"] as! Double,
                            percentChange: result["price_change_percentage_24h"] as! Double,
                            marketCap: result["market_cap"] as! Double,
                            totalVolume: result["total_volume"] as! Double,
                            high: result["high_24h"] as! Double,
                            low: result["low_24h"] as! Double
                        )
                        
                        let row = self.arrCoins.count
                        self.arrCoins.append(coin)
                        
                        let imageURL = URL(string: coin.imageUrl)!

                        let imageTask = session.dataTask(with: imageURL) { data, response, error in

                            if error == nil {
                                self.arrCoins[row].imageThumb = UIImage(data: data!)
                                let indexPath = IndexPath(row: row, section: 0)
                                DispatchQueue.main.async {
                                    self.homeTableView.reloadRows(at: [indexPath], with: .fade)
                                }
                            }
                            

                        }
                        imageTask.resume()
                    }
                    DispatchQueue.main.async {
                        self.homeTableView.reloadData()
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
        
    } //didLoad
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == homeTableView {
            return arrCoins.count
        }
        
        if tableView == trendingTableView {
            return 1
        }
        
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == homeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! HomeTableViewCell
            let coin = arrCoins[indexPath.row]
            
            cell.id.text = coin.symbol.uppercased()
            cell.name.text = coin.name
            
            if coin.currentPrice < 0.01 {
                cell.price.text = "$\(String(format: "%.5f", coin.currentPrice))"
            } else {
                cell.price.text = "$\(String(format: "%.2f", coin.currentPrice))"
            }
            
            if coin.percentChange < 0 {
                cell.change.textColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            } else if coin.percentChange > 0 {
                cell.change.textColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
            }
            
            cell.change.text = "\(String(format: "%.2f", coin.percentChange))%"
            
            cell.coinImage.image = coin.imageThumb

    //        cell.coinImage.image = UIImage(named: "news")
            return cell
        }
        
        if tableView == trendingTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "trendingTableViewCell") as! TrendingTableViewCell
            
            return cell
        }
        
        return UITableViewCell()
    }

}

