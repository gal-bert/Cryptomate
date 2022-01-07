//
//  BeritaViewController.swift
//  Cryptomate
//
//  Created by Ivan Su on 1/6/22.
//

import UIKit

class BeritaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let urlString = "https://newsapi.org/v2/everything?q=crypto&from=2021-12-20&apiKey=c0d5252381e04396bb6a5f49d87bd9e3"
        let url = URL(string: urlString)!
        
        let req = URLRequest(url: url)
        let session = URLSession.shared
        let detailTask = session.dataTask(with: req) { data, res, err in
            if err == nil {
                do {
                    let root = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    let arr = root["articles"] as! Array<Any>
                    
                    for item in arr {
                        let i = item as! [String: Any]
                        
//                        print("--> \(i)")
//                        print("-->> \(i["title"]!)")
//                        print("-->> \(i["description"]!)")
//                        print("-->> \(i["publishedAt"]!)")
//                        print("-->> \(i["author"]!)")
//                        print("-->> \(i["urlToImage"]!)")
//                        print("-->> \(i["url"]!)")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
