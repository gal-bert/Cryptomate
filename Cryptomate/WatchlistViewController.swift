//
//  WatchlistViewController.swift
//  Cryptomate
//
//  Created by Gregorius Albert on 14/01/22.
//

import UIKit

class WatchlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    //TODO: Assign tableview same with homepage
    //TODO: Load data from core data
    //TODO: Fetch data from API based on id
    //TODO: Segue to detail page
    
    var arrCoins = [Coin]()
    var arrId = [Watchlist]()

    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    
    func reload() -> Void {
        let context = appDelegate.persistentContainer.viewContext
        do{
            let fetchCoins = Watchlist.fetchRequest()
            let coinsResult = try context.fetch(fetchCoins)
            arrId = coinsResult
            
            for wl in arrId {
                getDataFromAPI(id: wl.coinId!)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getDataFromAPI(id:String) {
        let urlString = "https://api.coingecko.com/api/v3/coins/\(id)"
        let url = URL(string: urlString)!
        
        let req = URLRequest(url: url)
        let session = URLSession.shared
        let detailTask = session.dataTask(with: req) { data, res, err in
            if err == nil {
                do {
                    let root = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    let name = root["name"] as! String
                    let symbol = root["symbol"] as! String
                    
                    let image = root["image"] as! [String: String]
                    let imageLarge = image["small"]
                    
                    let marketData = root["market_data"] as! [String: Any]
                    
                    let currentPrice = marketData["current_price"] as! [String: Double]
                    let currentPriceUsd = currentPrice["usd"]
                    
                    let priceChange24h = marketData["price_change_24h"] as! Double
                    let priceChangePercentage24h = marketData["price_change_percentage_24h"] as! Double
                    
                    let coin = Coin(
                        id: id as! String,
                        symbol: symbol as! String,
                        name: name as! String,
                        imageUrl: imageLarge as! String,
                        currentPrice: currentPriceUsd as! Double,
                        percentChange: priceChangePercentage24h as! Double,
                        marketCap: 0,
                        totalVolume: 0,
                        high: 0,
                        low: 0
                    )
                    
                    let row = self.arrCoins.count
                    self.arrCoins.append(coin)
                    
                    let imageURL = URL(string: imageLarge!)!

                    let imageTask = session.dataTask(with: imageURL) { data, response, error in

                        if error == nil {
                            self.arrCoins[row].imageThumb = UIImage(data: data!)
                            let indexPath = IndexPath(row: row, section: 0)
                            DispatchQueue.main.async {
                                self.tableView.reloadRows(at: [indexPath], with: .fade)
                            }
                        }
                    }
                    imageTask.resume()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                catch {
                    print("Error JSON Serialization")
                }
            } else {
                print(err!.localizedDescription)
            }
        }
        
        detailTask.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! HomeTableViewCell
        let coin = arrCoins[indexPath.row]
        
        cell.id.text = coin.symbol.uppercased()
        cell.name.text = coin.name
        
        cell.price.text = Helper.formatPrice(price: coin.currentPrice)
        
        cell.change.textColor = Helper.formatChange(change: coin.percentChange)
        
        cell.change.text = "\(String(format: "%.2f", coin.percentChange))%"
        
        cell.coinImage.image = coin.imageThumb

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCoins.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Segue to detail
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Segue prep
    }
    

}
