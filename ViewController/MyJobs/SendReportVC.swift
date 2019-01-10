//
//  SendReportVC.swift
//  E3malApp
//
//  Created by Pawan Dhawan on 28/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class SendReportVC: BaseViewController, UITextViewDelegate,APImageDataDelegate {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var reportTextview: UITextView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblUpload: UILabel!
    @IBOutlet weak var upArrowImageView: UIImageView!
    
    
    
    var imageDict = [String : Any]()
    var isFirstImageUploaded = false
    var isSecondImageUploaded = false
    var isThirdImageUploaded = false
    var firstTitleText = ""
    var secondTitleText = ""
    var thirdTitleText = ""
    var firstURLText = ""
    var secondURLText = ""
    var thirdURLText = ""
    var editedImageArray = NSMutableArray()
    var uploadImage = false
    var param = [String: Any]()
    
    
    
    @IBOutlet weak var uploadViewHeightConstraint :NSLayoutConstraint!
    
//    @IBOutlet weak var textviewBG: UIView!
    
    var feedbackView:FeedBackView?
    var feedbackHireView:FeedBackHireView?
    var serviceFeedbackId:String?
    
    
    var viewType = Constants.kViewTypeReportAbuse
    
    var jobId = ""
    var isSettingView = false
    var job:Job?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpLocalization()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sendButtonPressed(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if viewType == Constants.kViewTypeDecline && (reportTextview.text == Localization("Reason for decline.") || reportTextview.text == ""){
        
            self.view.makeToast(Localization("Reason for decline."), duration: 3, position: .center)
        
        }else if reportTextview.text == Localization("Type your comment") || reportTextview.text == ""{
            
            self.view.makeToast(Localization("Type your comment"), duration: 3, position: .center)
            
        }else{
        
            
            if viewType == Constants.kViewTypeDecline {
                
                declineJobAPI()
            }else{
                performContactUsOrReportUs()
            }
            
        
        }
 
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        if(self.isSettingView == true) {
             self.setTabBarVisible(visible: false, animated: true)
        }
       else if self.tabBarController != nil {
            self.setTabBarVisible(visible: true, animated: true)
        }
      let _ =  self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - Helper Methods
    func setupUI() {
        
        sendButton.titleLabel?.addTextSpacing(spacing: 1.0)
        titleLabel.addTextSpacing(spacing: 1.0)
        
        if viewType == Constants.kViewTypeRequestProfileVerified {
            uploadViewHeightConstraint.constant = 35;
            lblTitle.text = Localization(Constants.LocalisedString.kDocuments)
            lblUpload.text = ""
            lblUpload.text = Localization(Constants.LocalisedString.kUpload)
        }
        else{
            uploadViewHeightConstraint.constant = 0
        }
    }
    
    func setUpLocalization(){
        
        titleLabel.text = Localization("REPORT")
        reportTextview.text = Localization("Type your comment")
        
        if viewType == Constants.kViewTypeContactUs {
        
            titleLabel.text = Localization("CONTACT US")
        
        }
        
       else if viewType == Constants.kViewTypeRequestProfileVerified {
            
            titleLabel.text = Localization("REQUEST FOR PROFILE VERIFICATION")
            
        }
            
        else if viewType == Constants.kViewTypeDecline {
            
            titleLabel.text = Localization("COMMENTS")
            reportTextview.text = Localization("Reason for decline.")
        }
        
        sendButton.setTitle(Localization("SEND"), for: .normal)
        
        
        
        if Localisator.sharedInstance.currentLanguage == "ar" {
            
            reportTextview.textAlignment = .right
            titleLabel.font = UIFont(name: "GeezaPro-Bold", size: titleLabel.font.pointSize)
            sendButton.titleLabel?.font = UIFont(name: "GeezaPro-Bold", size: (sendButton.titleLabel?.font.pointSize)!)
            reportTextview.font = UIFont(name: "Geeza Pro", size: (reportTextview.font?.pointSize)!)
        
        }
        
        reportTextview.textContainerInset = UIEdgeInsetsMake(13, 15, 13, 15)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (viewType == Constants.kViewTypeDecline && textView.text == Localization("Reason for decline.")) || textView.text == Localization("Type your comment") {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if viewType == Constants.kViewTypeDecline && textView.text == "" {
            
            textView.text = Localization("Reason for decline.")
            
        }else if textView.text == "" {
            
            textView.text = Localization("Type your comment")
        }
        
        if !((textView.text?.isEmpty)!) {
            param["comment"] = textView.text
        }
    }
    
   @IBAction func uploadBtnPressed() {
        if UserManager.sharedManager().isUserLoggedIn() {
            self.setTabBarVisible(visible: false, animated: true)
            let uploadStoryboard  = UIStoryboard(name: "PostJob", bundle: nil)
            if let uploadVC = uploadStoryboard.instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.kUploadVC) as? APUploadDocumentVC {
                uploadVC.delegate = self
                uploadVC.flagHideTopButtons = true
                if(self.imageDict["firstImage"] != nil) {
                    uploadVC.firstImage = self.imageDict["firstImage"] as! UIImage?
                    uploadVC.isFirstDocSet = true
                    uploadVC.isFirstImageUploaded = self.isFirstImageUploaded
                    if(self.firstTitleText != "") {
                        uploadVC.firstTitleText = self.firstTitleText
                    }
                    if(self.firstURLText != ""){
                        uploadVC.firstURLText = self.firstURLText
                    }
                    if(self.imageDict["firstImagePath"] != nil) {
                        uploadVC.firstImagePath = self.imageDict["firstImagePath"] as! String?
                    }
                    
                }
                if(self.imageDict["secondImage"] != nil) {
                    uploadVC.secondImage = self.imageDict["secondImage"] as! UIImage?
                    uploadVC.isSecondDocSet = true
                    uploadVC.isSecondImageUploaded = self.isSecondImageUploaded
                    if(self.secondURLText != ""){
                        uploadVC.secondURLText = self.secondURLText
                    }
                    if(self.secondTitleText != "") {
                        uploadVC.secondTitleText = self.secondTitleText
                    }
                    if(self.imageDict["secondImagePath"] != nil) {
                        uploadVC.secondImagePath = self.imageDict["secondImagePath"] as! String?
                    }
                }
                if(self.imageDict["thirdImage"] != nil) {
                    uploadVC.thirdImage = self.imageDict["thirdImage"] as! UIImage?
                    uploadVC.isThirdDocSet = true
                    uploadVC.isThirdImageUploaded = self.isThirdImageUploaded
                    if(self.thirdTitleText != "") {
                        uploadVC.thirdTitleText = self.thirdTitleText
                    }
                    if(self.thirdURLText != ""){
                        uploadVC.thirdURLText = self.thirdURLText
                    }
                    if(self.imageDict["thirdImagePath"] != nil) {
                        uploadVC.thirdImagePath = self.imageDict["thirdImagePath"] as! String?
                    }
                    
                }
                
                if(self.editedImageArray.count > 0) {
                    for index in 0..<self.editedImageArray.count  {
                        uploadVC.editImageArray.add(self.editedImageArray.object(at: index ))
                    }
                }
                self.uploadImage = true
                self.navigationController?.pushViewController(uploadVC, animated: false)
            }
        }
        else {
            self.alertWithOkAndCancel("", message: Constants.SIGNUP_MESSAGE, actionHandler: {
                AppDelegate.presentRootViewController(false, rootViewIdentifier: .toShowLoginScreen)
            })
        }
        
    }
    
    //MARK: APImageDataDelegate
    func getImageData(dict: [String : Any],isFirstImageUploaded isfirstImageUploaded : Bool, isSecondImageUploaded : Bool, isThirdImageUploaded : Bool,imagesEdited: NSMutableArray ,completion: @escaping () -> Void) {
        self.imageDict["firstImage"] = dict["firstImage"]
        self.imageDict["secondImage"] = dict["secondImage"]
        self.imageDict["thirdImage"] = dict["thirdImage"]
        self.imageDict["firstImagePath"] = dict["firstImagePath"]
        self.imageDict["secondImagePath"] = dict["secondImagePath"]
        self.imageDict["thirdImagePath"] = dict["thirdImagePath"]
        self.firstTitleText = dict["firstTitleText"] as! String
        self.secondTitleText = dict["secondTitleText"] as! String
        self.thirdTitleText = dict["thirdTitleText"] as! String
        self.firstURLText = dict["firstURLText"] as! String
        self.secondURLText = dict["secondURLText"] as! String
        self.thirdURLText = dict["thirdURLText"] as! String
        
        self.isFirstImageUploaded = isfirstImageUploaded
        self.isSecondImageUploaded = isSecondImageUploaded
        self.isThirdImageUploaded = isThirdImageUploaded
        self.editedImageArray.removeAllObjects()
        if(imagesEdited.count > 0) {
            for index in 0..<imagesEdited.count {
                self.editedImageArray.add(imagesEdited.object(at: index))
            }
        }
        
        if((self.imageDict["firstImage"] != nil) || ( self.imageDict["secondImage"] != nil) || (self.imageDict["thirdImage"] != nil))
        {
            let image = UIImage(named: "ic_close")
            upArrowImageView.image = image
            lblUpload.text = ""
            lblUpload.text = Localization(Constants.LocalisedString.kViewDocuments)
            lblTitle.text = Localization(Constants.LocalisedString.kDocuments)
        }
        else{
            let image = UIImage(named: "ic_up_arrow")
            upArrowImageView.image = image
            lblTitle.text = Localization(Constants.LocalisedString.kDocuments)
            lblUpload.text = ""
            lblUpload.text = Localization(Constants.LocalisedString.kUpload)
        }
        
        completion()
    }
    
    func checkForDoc() {
        let imagePathArr = NSMutableArray()
        let imageTitleArr = NSMutableArray()
        let imageURLArr = NSMutableArray()
        if(self.isFirstImageUploaded) {
            imagePathArr.add(self.imageDict["firstImagePath"]!)
            imageTitleArr.add(self.firstTitleText)
            imageURLArr.add(self.firstURLText)
        }
        if(self.isSecondImageUploaded) {
            imagePathArr.add(self.imageDict["secondImagePath"]!)
            imageTitleArr.add(self.secondTitleText)
            imageURLArr.add(self.secondURLText)
        }
        if(self.isThirdImageUploaded) {
            imagePathArr.add(self.imageDict["thirdImagePath"]!)
            imageTitleArr.add(self.thirdTitleText)
            imageURLArr.add(self.thirdURLText)
        }
        if(imagePathArr.count != 0){
            param["verificationRequestImage"] = imagePathArr
            param["verificationRequestImageTitle"] = imageTitleArr
            param["verificationRequestImageUrl"] = imageURLArr
        }
    }
    
    func performContactUsOrReportUs() {
        
        self.navigationController!.view.showLoader(mainTitle: "", subTitle: "")
       
        if viewType == Constants.kViewTypeRequestProfileVerified {
            self.checkForDoc()
                UserManager.sharedManager().sendProfileVerificationRequest(param as [String : AnyObject],completion:{(success, error) -> (Void) in
                
                DispatchQueue.main.async {
                    self.navigationController!.view.hideLoader()
                    if (success) {
                        
                        let message = Localization("Verification request posted successfully!")
                        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        let closeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
                            self.backButtonTapped(self)
                        }
                        alertController.addAction(closeAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    } else {
                        self.view.makeToast((error?.localizedDescription)!, duration: 3, position: .center)
                    }
                }
                
            })
        }
        
        else{
            
            UserManager.sharedManager().sendReport(viewType, content: reportTextview.text, serviceRequestId: jobId, completion: {(success, error) -> Void in
                DispatchQueue.main.async {
                    self.navigationController!.view.hideLoader()
                    if (success) {
                        
                        let message = Localization("Your_comment_has_been_reported.")
                        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        let closeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
                            self.backButtonTapped(self)
                        }
                        alertController.addAction(closeAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    } else {
                        self.view.makeToast((error?.localizedDescription)!, duration: 3, position: .center)
                    }
                }
            })
            
        }
    }
    
    func declineJobAPI() {
        var param = [String:String]()
        param["serviceRequestId"] = jobId
        param["comment"] = reportTextview.text
        param = param.union(deviceInfo())
        //show loader
        self.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        
        Job.declineJobRequest(param: param,completion: { (success, error, feedbackId) -> (Void) in
            // hide loader
            DispatchQueue.main.async{
                
                self.view.hideLoader()
                
                if (success) {
                    
                    let alertController = UIAlertController(title: "", message: "Job declined successfully", preferredStyle: UIAlertControllerStyle.alert)
                    let closeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
                        if(feedbackId == nil){
                            
                            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                            self.setTabBarVisible(visible: true, animated: true)
                            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
                            
                        }else{
                            
                            let user = UserManager.sharedManager().activeUser
                            if user?.roleType == 2{
                            
                                self.serviceFeedbackId = feedbackId!
                                
                                if(self.feedbackHireView == nil){
                                    self.feedbackHireView = FeedBackHireView()
                                }
                                self.setTabBarVisible(visible: false, animated: true)
                                self.feedbackHireView?.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:(UIScreen.main.bounds.size.height))
                                
                                self.feedbackHireView?.delegate = self
                                self.view.addSubview(self.feedbackHireView!)
                                APPDELEGATE.isFeedbackProcessing = true
                                
                                if let name = self.job?.associateWorkers?.first?.name{
                                    self.feedbackHireView?.nameLabel.text = name
                                }
                                
                                if let thumbImageUrl = self.job?.associateWorkers?.first?.profileImage {
                                    self.feedbackHireView?.profileImage.sd_setImage(with: NSURL(string: thumbImageUrl)! as URL, placeholderImage:  UIImage(named: "ProfilePicBlank"))
                                }
                                
                                if let cityName = self.job?.associateWorkers?.first?.cityName{
                                    self.feedbackHireView?.locationLabel.text = cityName
                                }

                                self.feedbackHireView?.setStarImage(14)
                                self.feedbackHireView?.starRating = "5"
                                
                            }else{
                            
                                self.serviceFeedbackId = feedbackId!
                                
                                if(self.feedbackView == nil){
                                    self.feedbackView = FeedBackView()
                                }
                                self.setTabBarVisible(visible: false, animated: true)
                                self.feedbackView?.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:(UIScreen.main.bounds.size.height))
                                
                                self.feedbackView?.delegate = self
                                self.view.addSubview(self.feedbackView!)
                                APPDELEGATE.isFeedbackProcessing = true
                                self.feedbackView?.nameLabel.text = self.job?.posterName
                                if let thumbImageUrl = self.job?.posterProfileImage {
                                    self.feedbackView?.profileImage.sd_setImage(with: NSURL(string: thumbImageUrl)! as URL, placeholderImage:  UIImage(named: "ProfilePicBlank"))
                                    
                                }
                                self.feedbackView?.setStarImage(14)
                                self.feedbackView?.starRating = "5"
                            
                            }
                        }
                    }
                    alertController.addAction(closeAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    self.view.makeToast((error?.localizedDescription)!, duration: 3, position: .center)
                }
            }
        })
    }
}

extension SendReportVC:FeedbackDelegate{
    
    
    func removeFeedbackView() {
        
        let user = UserManager.sharedManager().activeUser
        if user?.roleType == 2{
            feedbackHireView?.removeFromSuperview()
        }else{
            feedbackView?.removeFromSuperview()
        }
    }
    
    func sendFeedback(_ rating: String, comment: String) {
        
        self.sendFeedback(feedbackId: "\((self.serviceFeedbackId)!)", ratingPoint: rating, comment: comment)
        
    }
    
    /* sendFeedback this method is called to send Feedback */
    
    func sendFeedback(feedbackId: String, ratingPoint : String , comment : String){
        
        // show loader
        self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        
        Feedback.sendFeedback(feedbackId, ratingPoint: ratingPoint, comment: comment, completion: { (success, error) -> (Void) in
            // hide loader
            
            DispatchQueue.main.async {
                
                self.navigationController!.view.hideLoader()
                
                if let _ = error {
                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                } else {
                    
                    let alertController = UIAlertController(title: UserManager.sharedManager().activeUser.successMessage, message: "", preferredStyle: UIAlertControllerStyle.alert)
                    let closeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
                        
                        APPDELEGATE.isFeedbackProcessing = false
                        let user = UserManager.sharedManager().activeUser
                        if user?.roleType == 2{
                            self.feedbackHireView?.removeFromSuperview()
                        }else{
                            self.feedbackView?.removeFromSuperview()
                        }
                        
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                        self.setTabBarVisible(visible: true, animated: true)
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);

                    }
                    alertController.addAction(closeAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
    }
}
