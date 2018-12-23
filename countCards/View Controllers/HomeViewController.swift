//
//  HomeViewController.swift
//  countCards
//
//  Created by Kyle Mamiit (New) on 12/17/18.
//  Copyright © 2018 Kyle Mamiit. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var capturedItem: String = ""
    
    @IBOutlet weak var itemLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTappedButton(_ sender: Any) {
        let captureVC = storyboard?.instantiateViewController(withIdentifier: "captureViewController") as! CaptureViewController
        captureVC.delegate = self

        present(captureVC, animated: true, completion: {
            print("Right here")
        })
    }
    
    @IBAction func didTappedFindItemButton(_ sender: Any) {
        let ebayVC = storyboard?.instantiateViewController(withIdentifier: "ebayViewController") as! EbayViewController
        ebayVC.keyword = capturedItem
        
        present(ebayVC, animated: true, completion: {
            print("Left here")
        })
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

extension HomeViewController: CapturedDelegate {
    func valueCaptured(value: String) {
        capturedItem = value
        self.itemLabel.text = value.capitalized
    }
    
    
}
