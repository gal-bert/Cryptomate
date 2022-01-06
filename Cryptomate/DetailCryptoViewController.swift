//
//  DetailCryptoViewController.swift
//  Cryptomate
//
//  Created by Ivan Su on 1/6/22.
//

import UIKit

class DetailCryptoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let urlString = "https://api.coingecko.com/api/v3/coins/bitcoin"
        let url = URL(string: urlString)!
        
        let req = URLRequest(url: url)
        let session = URLSession.shared
        let detailTask = session.dataTask(with: req) { data, res, err in
            if err == nil {
                do {
                    let root = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    
                    // ["id"]
                    // ["name"]
                    // ["symbol"]
                    // ["description"]["en"]
                    // ["links"]["homepage"][0]
                    // ["image"]["large"]
                    // ["market_cap_rank"]
                    // ["market_data"]["current_price"]["usd"]
                    // ["market_data"]["ath"]["usd"]
                    // ["market_data"]["ath_change_percentage"]["usd"]
                    // ["market_data"]["atl"]["usd"]
                    // ["market_data"]["atl_change_percentage"]["usd"]
                    // ["market_data"]["market_cap"]["usd"]
                    // ["market_data"]["high_24h"]["usd"]
                    // ["market_data"]["low_24h"]["usd"]
                    // ["market_data"]["price_change_24h"]
                    // ["market_data"]["price_change_percentage_24h"]
                    
                    print("id: \(root["id"] as! String)")
                    
                } catch {
                    print("Error JSON Serialization")
                }
            } else {
                print(err?.localizedDescription)
            }
        }
        
        detailTask.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
