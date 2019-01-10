//
//  AppDelegate+Feedback.swift
//  E3malApp
//
//  Created by Pawan Dhawan on 30/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

extension AppDelegate {

    /* getFeedbackList method is called to get list of all pending feedbacks */
    
    func getFeedbackList(){
        
        Provider.getFeedbackList({ (feedbacks,success, error) -> (Void) in
            // hide loader
            
            DispatchQueue.main.async {
                
                if let _ = error {
                    self.isFeedbackProcessing = false
                
                } else {
                    
                    self.pendingFeedbacks =  feedbacks
                    if self.pendingFeedbacks != nil && (self.pendingFeedbacks?.count)! > 0 {
                        
                        let user = UserManager.sharedManager().activeUser
                        if user?.roleType == 2 { // feedback for worker
                            
                            if(self.feedBackView == nil){
                                self.feedBackView = FeedBackHireView()
                            }
                            self.feedBackView?.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:(UIScreen.main.bounds.size.height))
                            self.feedBackView?.delegate = self
                            self.window?.addSubview(self.feedBackView!)
                            let feedback = self.pendingFeedbacks?.first as! Feedback
                            self.feedBackView?.nameLabel.text = feedback.name
                            if let thumbImageUrl = feedback.profileImage {
                                self.feedBackView?.profileImage.sd_setImage(with: NSURL(string: thumbImageUrl)! as URL, placeholderImage:  UIImage(named: "ProfilePicBlank"))
                            }
                            if let cityName = feedback.cityName {
                                self.feedBackView?.locationLabel.text = cityName
                            }
                            self.feedBackView?.setStarImage(14)
                            self.feedBackView?.starRating = "5"
                            
                        }else{  // feedback for hire
                        
                            if(self.feedBackHireView == nil){
                                self.feedBackHireView = FeedBackView()
                            }
                            self.feedBackHireView?.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:(UIScreen.main.bounds.size.height))
                            self.feedBackHireView?.delegate = self
                            self.window?.addSubview(self.feedBackHireView!)
                            let feedback = self.pendingFeedbacks?.first as! Feedback
                            self.feedBackHireView?.nameLabel.text = feedback.name
                            if let thumbImageUrl = feedback.profileImage {
                                self.feedBackHireView?.profileImage.sd_setImage(with: NSURL(string: thumbImageUrl)! as URL, placeholderImage:  UIImage(named: "ProfilePicBlank"))
                            }
                            self.feedBackHireView?.setStarImage(14)
                            self.feedBackHireView?.starRating = "5"
                        
                        }
                    }
                }
            }
        })
    }
    
    /* sendFeedback this method is called to send Feedback */
    
    func sendFeedback(feedbackId: String, ratingPoint : String , comment : String){
        
        // show loader
        Feedback.sendFeedback(feedbackId, ratingPoint: ratingPoint, comment: comment, completion: { (success, error) -> (Void) in
            // hide loader
            
            DispatchQueue.main.async {
                
                
                if let _ = error {
//                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                } else {
                    
                    self.pendingFeedbacks?.removeFirst()
                    
                    let user = UserManager.sharedManager().activeUser
                    if user?.roleType == 2 {
                        self.feedBackView?.removeFromSuperview()
                    }else{
                        self.feedBackHireView?.removeFromSuperview()
                    }
                    
                    if self.pendingFeedbacks != nil && self.pendingFeedbacks?.count == 0 {
                        
                        self.pendingFeedbacks = nil
                        let alertController = UIAlertController(title: UserManager.sharedManager().activeUser.successMessage, message: "", preferredStyle: UIAlertControllerStyle.alert)
                        let closeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
                            // do nothing
                            self.isFeedbackProcessing = false
                        }
                        alertController.addAction(closeAction)
                        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                        
                    }else if self.pendingFeedbacks != nil && (self.pendingFeedbacks?.count)! > 0 {
                        
                        let alertController = UIAlertController(title: UserManager.sharedManager().activeUser.successMessage, message: "", preferredStyle: UIAlertControllerStyle.alert)
                        let closeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
                            
                            let user = UserManager.sharedManager().activeUser
                            if user?.roleType == 2 {
                                self.feedBackView?.setStarImage(14)
                                self.feedBackView?.starRating = "5"
                                self.window?.addSubview(self.feedBackView!)
                                let feedback = self.pendingFeedbacks?.first as! Feedback
                                self.feedBackView?.nameLabel.text = feedback.name
                                if let thumbImageUrl = feedback.profileImage {
                                    self.feedBackView?.profileImage.sd_setImage(with: NSURL(string: thumbImageUrl) as! URL, placeholderImage: UIImage(named: "ProfilePicBlank"))
                                }
                                if let cityName = feedback.cityName {
                                    self.feedBackView?.locationLabel.text = cityName
                                }
                            }else{
                                self.feedBackHireView?.setStarImage(14)
                                self.feedBackHireView?.starRating = "5"
                                self.window?.addSubview(self.feedBackHireView!)
                                let feedback = self.pendingFeedbacks?.first as! Feedback
                                self.feedBackHireView?.nameLabel.text = feedback.name
                                if let thumbImageUrl = feedback.profileImage {
                                    self.feedBackHireView?.profileImage.sd_setImage(with: NSURL(string: thumbImageUrl) as! URL, placeholderImage: UIImage(named: "ProfilePicBlank"))
                                }
                            }
                        }
                        alertController.addAction(closeAction)
                        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                    }
                    
                }
            }
        })
    }
}

extension AppDelegate:FeedbackDelegate{

    func removeFeedbackView() {
        feedBackView?.removeFromSuperview()
    }
    
    func sendFeedback(_ rating: String, comment: String) {
        
        let array =  self.pendingFeedbacks
        if array != nil && (array?.count)! > 0 {
            let feedback = array?.first as! Feedback
            self.sendFeedback(feedbackId: "\((feedback.id)!)", ratingPoint: rating, comment: comment)
        }
    }
}
