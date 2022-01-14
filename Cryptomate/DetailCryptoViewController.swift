//
//  DetailCryptoViewController.swift
//  Cryptomate
//
//  Created by Ivan Su on 1/6/22.
//

import UIKit

class DetailCryptoViewController: UIViewController {
    
    @IBOutlet weak var coinIdLabel: UILabel!
    var coinId:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinIdLabel.text = coinId

        let urlString = "https://api.coingecko.com/api/v3/coins/bitcoin"
        let url = URL(string: urlString)!
        
        let req = URLRequest(url: url)
        let session = URLSession.shared
        let detailTask = session.dataTask(with: req) { data, res, err in
            if err == nil {
                do {
                    let root = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    print("id: \(root["id"] as! String)")
                    
                } catch {
                    print("Error JSON Serialization")
                }
            } else {
                print(err!.localizedDescription)
            }
        }
        
        detailTask.resume()
    }
    

}
