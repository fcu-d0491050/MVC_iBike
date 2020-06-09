//
//  WebViewController.swift
//  iBike with MVC
//
//  Created by CS01196 on 2020/5/28.
//  Copyright © 2020 CS01196. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.layer.borderColor = UIColor.lightGray.cgColor
        webView.layer.borderWidth = 1
        
        openWebView()
    }
    
    func openWebView() {
        
        /*建立並指定網址*/
        //https://i.youbike.com.tw/home
        if let iBikeUrl = URL(string: "https://www.google.com") {
            /*URL load請求*/
            let request = URLRequest(url: iBikeUrl)
            webView.load(request)
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(identifier: "HomeViewController")
        homeVC.modalPresentationStyle = .fullScreen
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
