//
//  EbayViewController.swift
//  countCards
//
//  Created by Kyle Mamiit (New) on 12/17/18.
//  Copyright © 2018 Kyle Mamiit. All rights reserved.
//

import UIKit
import AlamofireImage

class EbayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var EBtableView: UITableView!
    @IBAction func didTapCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    var keyword = "water"
    var urlString = "https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=KyleMami-ItemSear-PRD-260b1f533-da5c5e6e&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords="
    
    var products: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EBtableView.dataSource = self
        EBtableView.delegate = self
        
        self.EBtableView.estimatedRowHeight = self.EBtableView.rowHeight
        self.EBtableView.rowHeight = 250
        
//        let url = URL(string: "https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=KyleMami-ItemSear-PRD-260b1f533-da5c5e6e&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=harry%20potter%20phoenix&fbclid=IwAR1jrosA9BBB_X2PlvTIHMK7Tf7W8BiqfjvUxKM2DmJZC9ythqNyVPhwybk")!
        
        let newKeyWord = keyword.replacingOccurrences(of: " ", with: "%20")
        urlString += newKeyWord
        let url = URL(string: urlString)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("field 11111")
                print(error.localizedDescription)
            } else if let data = data {
                print("field 22222")
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let responseDictionary = dataDictionary["findItemsByKeywordsResponse"] as! [[String: Any]]
                let actualResponseDictionary = responseDictionary.first
                let resultDictionary = actualResponseDictionary!["searchResult"] as! [[String: Any]]
                let actualResultDictionary = resultDictionary.first
//                print(resultDictionary)
                self.products = actualResultDictionary!["item"] as! [[String: Any]]
                
                self.EBtableView.reloadData()
                
                print(self.products)
                print(self.keyword)
            }
        }
        
        task.resume()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ebCell", for: indexPath) as! EBTableViewCell
        let product = products[indexPath.row]
        
        let itemTitle = product["title"] as! [String]
        let actualItemTitle = itemTitle[0]
        
        let sellItemInfo = product["sellingStatus"] as! [[String: Any]]
        let actualSellItemInfo = sellItemInfo.first!
        let sellItemInfoPrice = actualSellItemInfo["currentPrice"] as! [[String: Any]]
        
        let itemValue = sellItemInfoPrice.first!["__value__"] as! String
        let itemImageURL = product["galleryURL"] as! [String]
        let actualItemImageURL = itemImageURL[0]
        let url = URL(string: actualItemImageURL)

        cell.itemImageView.af_setImage(withURL: url!)
        cell.itemTitleLabel.text = actualItemTitle
        cell.itemPriceLabel.text = "$" + itemValue
        return cell
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
