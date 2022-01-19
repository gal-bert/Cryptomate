//
//  NewsViewController.swift
//  Cryptomate
//
//  Created by Ivan Su on 1/6/22.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var arrNews = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        activityIndicator.startAnimating()
        
        let urlString = "https://newsapi.org/v2/everything?q=crypto&from=2021-12-20&apiKey=c0d5252381e04396bb6a5f49d87bd9e3"
        let url = URL(string: urlString)!
        
        let req = URLRequest(url: url)
        let session = URLSession.shared
        let detailTask = session.dataTask(with: req) {
            [self] data, res, err in
            if err == nil {
                do {
                    let root = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    let arr = root["articles"] as! Array<Any>
                    
                    for item in arr {
                        let i = item as! [String: Any]
                        let news = News(
                            title: i["title"] as! String,
                            description: i["description"] as! String,
                            publishedAt: i["publishedAt"] as! String,
                            author: i["author"] as? String ?? "",
                            urlToImage: i["urlToImage"] as! String,
                            url: i["url"] as! String
                        )
                        self.arrNews.append(news)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        arrNews.sort {
            $0.title.localizedStandardCompare($1.title) == .orderedAscending
        }
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        
        let news = arrNews[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, YYYY - HH:MM"
        let isoformat = ISO8601DateFormatter()
        let date = isoformat.date(from: news.publishedAt)
        let strDate = dateFormatter.string(from: date!)
        
        cell.textLabel?.text = news.title
        cell.detailTextLabel?.text = "Published: \(String(describing: strDate))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNews.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = arrNews[indexPath.row]
        
        guard let url = URL(string: news.url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }

}
