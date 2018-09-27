//
//  WebViewController.swift
//  NewYorkTimes
//
//  Created by andah on 26/09/2018.
//  Copyright © 2018 programmer. All rights reserved.
//

import UIKit

class WebViewController: UIViewController , UIWebViewDelegate {

  
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!
   
    
    var hasFinishedLoading = false
    var myUrl: URL!
    var postTitle :String!

    @objc func closeBtnTapped(_ sender: Any) {
        
       navigationController?.popViewController(animated: true)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupNavigationItems()
        setupWebView()
        
    }
    func setupWebView() {
        webView.delegate = self
        let req = URLRequest(url: myUrl)

        webView.loadRequest(req)
    }
    func setupNavigationItems() {
        let closeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40 ))
        closeBtn.backgroundColor = UIColor.clear
        let image = UIImage(named: "icon-close")
        closeBtn.setImage(image, for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeBtn)
        
        let titleLbl = UILabel()
        titleLbl.text = postTitle
        titleLbl.backgroundColor = UIColor.clear
        titleLbl.textColor = UIColor.white
        titleLbl.numberOfLines = 0
        titleLbl.textAlignment = .center
        navigationItem.titleView = titleLbl
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        hasFinishedLoading = false
        updateProgress()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        delay(delay: 1) { [weak self] in
            if let _self = self {
                _self.hasFinishedLoading = true
            }
        }
    }
    deinit {
        webView.stopLoading()
        webView.delegate = nil
    }
    func updateProgress() {
        if progressView.progress >= 1 {
            progressView.isHidden = true
        } else {
            
            if hasFinishedLoading {
                progressView.progress += 0.002
            } else {
                if progressView.progress <= 0.3 {
                    progressView.progress += 0.004
                } else if progressView.progress <= 0.6 {
                    progressView.progress += 0.002
                } else if progressView.progress <= 0.9 {
                    progressView.progress += 0.001
                } else if progressView.progress <= 0.94 {
                    progressView.progress += 0.0001
                } else {
                    progressView.progress = 0.9401
                }
            }
            
            delay(delay: 0.008) { [weak self] in
                if let _self = self {
                    _self.updateProgress()
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    public func delay(delay:Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
