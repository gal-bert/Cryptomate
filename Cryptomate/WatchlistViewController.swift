//
//  WatchlistViewController.swift
//  Cryptomate
//
//  Created by Gregorius Albert on 14/01/22.
//

import UIKit

class WatchlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var arrCoins = [Coin]()
    var arrId = [Watchlist]()
    var selectedCoinId:String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        reload()
        tableView.reloadData()
    }
    
    func reload() -> Void {
        let context = appDelegate.persistentContainer.viewContext
        do{
            let fetchCoins = Watchlist.fetchRequest()
            let coinsResult = try context.fetch(fetchCoins)
            arrId = coinsResult
            arrCoins.removeAll()
            
            if arrId.isEmpty {
                activityIndicator.stopAnimating()
            }
            
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
                    
                    let priceChangePercentage24h = marketData["price_change_percentage_24h"] as! Double
                    
                    let coin = Coin(
                        id: id,
                        symbol: symbol,
                        name: name,
                        imageUrl: imageLarge!,
                        currentPrice: currentPriceUsd!,
                        percentChange: priceChangePercentage24h ,
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
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                    imageTask.resume()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
//                        self.arrCoins.sort {
//                            $0.name.localizedStandardCompare($1.name) == .orderedAscending
//                        }
                    }
                }
                catch {
                    print("Error JSON Serialization")
                }
            }
            else {
                print(err!.localizedDescription)
            }
        }
        detailTask.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! CustomTableViewCell
        activityIndicator.stopAnimating()
        
        let coin = arrCoins[indexPath.row]
        
        cell.name.text = coin.name
        cell.id.text = coin.symbol.uppercased()
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
        selectedCoinId = arrCoins[indexPath.row].id
        performSegue(withIdentifier: "toDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailSegue" {
            let destination = segue.destination as! DetailCryptoViewController
            destination.coinId = selectedCoinId
        }
    }    

}
