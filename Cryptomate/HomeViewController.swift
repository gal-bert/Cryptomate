//
//  ViewController.swift
//  Cryptomate
//
//  Created by Gregorius Albert on 19/12/21.
//

import UIKit


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, TrendingTableViewDelegate {
   

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var trendingTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var arrCoins = [Coin]()
    var temp:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        self.homeTableView.rowHeight = 65
        self.trendingTableView.rowHeight = 120
        
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
                    print(error.localizedDescription)
                }
            }
            else {
                print(error!.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == homeTableView {
            return arrCoins.count
        }
        else if tableView == trendingTableView {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        activityIndicator.stopAnimating()
        
        if tableView == homeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! CustomTableViewCell
            let coin = arrCoins[indexPath.row]
            
            cell.id.text = coin.symbol.uppercased()
            cell.name.text = coin.name
            
            cell.price.text = Helper.formatPrice(price: coin.currentPrice)
            
            cell.change.textColor = Helper.formatChange(change: coin.percentChange)
            
            cell.change.text = "\(String(format: "%.2f", coin.percentChange))%"
            
            cell.coinImage.image = coin.imageThumb

            return cell
        }
        
        else if tableView == trendingTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "trendingTableViewCell") as! TrendingTableViewCell
            cell.trendingTableViewDelegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == homeTableView {
            temp = arrCoins[indexPath.row].id
            performSegue(withIdentifier: "toDetailSegue", sender: self)
            homeTableView.reloadData()
        }
                    
    }
    
    @IBAction func search(_ sender: Any) {
        
        activityIndicator.startAnimating()
        
        let coinId = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = "https://api.coingecko.com/api/v3/coins/\(coinId!)"
        let url = URL(string: urlString)!
        
        let req = URLRequest(url: url)
        let session = URLSession.shared
        let detailTask = session.dataTask(with: req) { data, res, err in
            if err == nil {
                let response = res as? HTTPURLResponse
                let statusCode = response?.statusCode
                
                if statusCode! == 404 || coinId == "" {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.present(Helper.pushAlert(title: "Oops!", message: "Coin not found!"), animated: true, completion: nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.temp = coinId
                        self.activityIndicator.stopAnimating()
                        self.performSegue(withIdentifier: "toDetailSegue", sender: self)
                    }
                }

            } else {
                print(err!.localizedDescription)
                self.present(Helper.pushAlert(title: "Oops!", message: err!.localizedDescription), animated: true, completion: nil)
            }
        }
        detailTask.resume()
    }
    
    //Delegate from collection view
    func onClick(id: String) {
        temp = id
        performSegue(withIdentifier: "toDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailSegue" {
            let destination = segue.destination as! DetailCryptoViewController
            destination.coinId = temp
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func searchDidEndOnExit(_ sender: Any) {
        
    }
    
}

