//
//  BeritaViewController.swift
//  Cryptomate
//
//  Created by Ivan Su on 1/6/22.
//

import UIKit

class BeritaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var beritaList = [Berita]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        // API CALL
        let urlString = "https://newsapi.org/v2/everything?q=crypto&from=2021-12-20&apiKey=c0d5252381e04396bb6a5f49d87bd9e3"
        let url = URL(string: urlString)!
        
        let req = URLRequest(url: url)
        let session = URLSession.shared
        let detailTask = session.dataTask(with: req) { [self] data, res, err in
            if err == nil {
                do {
                    let root = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    let arr = root["articles"] as! Array<Any>
                    
                    for item in arr {
                        let i = item as! [String: Any]
                        let berita = Berita(
                            title: i["title"] as! String,
                            description: i["description"] as! String,
                            publishedAt: i["publishedAt"] as! String,
                            author: i["author"] as? String ?? "",
                            urlToImage: i["urlToImage"] as! String,
                            url: i["url"] as! String
                        )
                        
                        self.beritaList.append(berita)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beritaCell")!
        let berita = beritaList[indexPath.row]
        
        cell.textLabel?.text = berita.title
        cell.detailTextLabel?.text = "Published: \(berita.publishedAt)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beritaList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let berita = beritaList[indexPath.row]
        
        guard let url = URL(string: berita.url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
