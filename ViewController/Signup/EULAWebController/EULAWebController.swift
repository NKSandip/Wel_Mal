//
//  EULAWebController.swift
//  OnDemandApp
//  Created by Pawan Joshi on 11/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

protocol EULAControllerDelegate {
    func eulaControllerOptionDidSelect(_ isAccepted: Bool)
}

class EULAWebController: BaseViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var navItem: UINavigationItem?
    @IBOutlet weak var titleLabel: UILabel!
    
    var titleText = ""
    
    var pageUrlString: String!
    var delegate: EULAControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if self.title == nil {
            self.title = self.navigationItem.title
            self.titleLabel.text = self.navigationItem.title
        }
        
        if self.titleText != "" {
            self.titleLabel.text = self.titleText.uppercased()
        }
        
        let tAndC = Localization("Terms & Conditions")
        
        self.navItem?.title = self.title

        switch self.titleText {
        case "Privacy Policy":
            self.pageUrlString = Constants.Urls.privacyPolicy
        case tAndC:
            
            if UserManager.sharedManager().userType == .userTypeProvider{
                self.pageUrlString = Constants.Urls.termsAndConditonsProvider + "?language=" + Localisator.sharedInstance.currentLanguage
            }else{
                self.pageUrlString = Constants.Urls.termsAndConditonsSeeker + "?language=" + Localisator.sharedInstance.currentLanguage
            }

        case "About":
            self.pageUrlString = Constants.Urls.aboutUs
        default:
            break
        }
        
                
        self.webView.loadRequest(URLRequest(url: URL(string: self.pageUrlString)!))
        
        UIApplication.shared.statusBarStyle = .default
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: Control Actions
    
    @IBAction func rejectButtonAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: {
            self.delegate?.eulaControllerOptionDidSelect(false)
        })
    }
    
    @IBAction func acceptButtonAction(_ sender: AnyObject) {
//        dismiss(animated: true, completion: {
//            self.delegate?.eulaControllerOptionDidSelect(true)
//        })
        
        self.navigationController?.popViewController(animated: true)
    }
}


extension EULAWebController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.activityView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.activityView.stopAnimating()
    }
}
