//
//  WorkJobDetails.swift
//  E3malApp
//
//  Created by Pawan Dhawan on 26/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol WorkJobDetailsDelegate {
    
    func updatePage()
}

class WorkJobDetails:BaseViewController, UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alertCountLabel: UILabel!
    let currencyText = Localization("SAR")
    @IBOutlet weak var tableViewBg: UIView!
    @IBOutlet weak var bidMainView: UIView!
    @IBOutlet weak var bidContentView: UIView!
    @IBOutlet var bidView: UIView!
    @IBOutlet weak var yourQuoteLabel: UILabel!
    @IBOutlet weak var yourQuoteTableView: UITableView!
    @IBOutlet weak var btnCancelOnBidView: UIButton!
    var job:Job?
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
    
    var bidAmount = ""
    var bidDate = ""
    var bidCoverText = ""
    
    var delegate:WorkJobDetailsDelegate?
    
    var param = [String: Any]()
    
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    
    var flagHideTopButtons = false
    var flagShowNotification = false
    
    //MARK: - life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setUpLocalization()
        
        if flagHideTopButtons {
            notificationButton.isHidden = true
            alertCountLabel.isHidden = true
        }
    }
    
    
    func setupUI() {
        bidView.isHidden = true
        bidView.frame = self.view.frame
        self.view.addSubview(bidView)
        
        IQKeyboardManager.sharedManager().previousNextDisplayMode = .alwaysHide
        
        alertCountLabel.layer.cornerRadius = 6
        alertCountLabel.clipsToBounds = true
        alertCountLabel.layer.masksToBounds = true
        
        tableViewBg.layer.shadowOpacity = 0.3
        tableViewBg.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        tableViewBg.layer.shadowColor = UIColor.darkGray.cgColor
        tableViewBg.layer.shadowRadius = 20.0
        
        tableView.layer.cornerRadius = 5
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.white.cgColor
        tableView.layer.masksToBounds = true
        tableView.clipsToBounds = true
        
        bidMainView.layer.shadowOpacity = 0.3
        bidMainView.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        bidMainView.layer.shadowColor = UIColor.darkGray.cgColor
        bidMainView.layer.shadowRadius = 20.0
        
        bidContentView.layer.cornerRadius = 5
        bidContentView.layer.masksToBounds = true
        bidContentView.clipsToBounds = true
        
        self.reportButton.changeCornerAndColor(20, borderWidth: 1.0 , color: Constants.cornerColor)
        
    }
    
    func updateNotificationCount(_ notification: NSNotification) {
        //1
        if let userInfo = notification.userInfo as? [String: AnyObject] {
            DispatchQueue.main.async{
                self.alertCountLabel.text = "\((userInfo["unreadCount"])!)"
            }
        }
        //RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpLocalization(){
        
        titleLabel.text = Localization("DETAILS")
        titleLabel?.addTextSpacing(spacing: 1.0)
        btnCancelOnBidView.addLocalization()
        yourQuoteLabel.text = Localization("YOUR QUOTE")
        yourQuoteLabel?.addTextSpacing(spacing: 1.0)
        reportButton.addLocalization()
        
        if Localisator.sharedInstance.currentLanguage == "ar"{
            
            titleLabel.font = UIFont(name: "GeezaPro-Bold", size: titleLabel.font.pointSize)
            yourQuoteLabel.font = UIFont(name: "GeezaPro-Bold", size: titleLabel.font.pointSize)
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(WorkJobDetails.updateNotificationCount(_:)), name: Constants.NOTIFICATION_UNREAD_COUNT, object: nil)
        if UserManager.sharedManager().isUserLoggedIn() {
        if let count = UserManager.sharedManager().activeUser.unReadCount {
            
            if count.intValue > 99 {
                alertCountLabel.text = "99+"
            }else{
                alertCountLabel.text = "\(count)"
            }
            alertCountLabel.isHidden = count.intValue > 0 ? false : true
        }
        }
        if((self.imageDict["firstImage"] != nil) || ( self.imageDict["secondImage"] != nil) || (self.imageDict["thirdImage"] != nil))
        {
            self.yourQuoteTableView.reloadData()
        }
        if(self.bidView.isHidden == false) {
           self.setTabBarVisible(visible: false, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBAction func removeBidView(_ sender: Any) {
        
        bidView.isHidden = true
        self.setTabBarVisible(visible: true, animated: true)
    }
    
    @IBAction func reportButtonPressed(_ sender: Any) {
        
        self.setTabBarVisible(visible: false, animated: true)
        let vc = UIStoryboard.sendReportVC()
        vc?.jobId = "\((job?.jobId)!)"
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func openNotificationVC(_ sender: Any) {
        
        (sender as! UIButton).isExclusiveTouch =  true
        if flagShowNotification {
            return
        }
        flagShowNotification = true
        self.perform(#selector(WorkJobDetails.enableNotificationButton), with: nil, afterDelay: 3)
        self.tabBarController?.navigationController?.pushViewController(UIStoryboard.notificationsVC()!, animated: true)
        
    }
    
    func enableNotificationButton() {
        flagShowNotification = false
    }
    
}




extension WorkJobDetails: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == yourQuoteTableView{
            return 5
        }else{
            return 17
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView == yourQuoteTableView{
            
            switch indexPath.row {
            case 0:
                let cell = yourQuoteTableView.dequeueReusableCell(withIdentifier: "BidCellType1", for: indexPath) as! BidCellType1
                cell.nameLabel.text = Localization("Price")
                cell.delegate = self
                return cell
            case 1:
                let cell = yourQuoteTableView.dequeueReusableCell(withIdentifier: "BidCellType2", for: indexPath) as! BidCellType2
                cell.nameLabel.text = Localization("Date")
                cell.delegate = self
                return cell
            case 2:
                let cell = yourQuoteTableView.dequeueReusableCell(withIdentifier: "BidCellType3", for: indexPath) as! BidCellType3
                cell.nameLabel.text = Localization("Cover Text")
                cell.delegate = self
                return cell
            case 3:
                
                let cell = yourQuoteTableView.dequeueReusableCell(withIdentifier: "APPostJobSixthTableViewCell", for: indexPath) as! APPostJobSixthTableViewCell
                
                cell.titleLabel.text = Localization("Upload Documents")
                cell.delegate = self
                if(self.imageDict["firstImage"] == nil && self.imageDict["secondImage"] == nil && self.imageDict["thirdImage"] == nil ) {
                    let image = UIImage(named: "ic_up_arrow")
                    cell.upArrowImageView.image = image
                    //                    cell.titleLabel.text = Localization(Constants.LocalisedString.kDocuments)
                    cell.uploadLabel.text = ""
                    cell.uploadLabel.text = Localization(Constants.LocalisedString.kUpload)
                    
                }
                else {
                    let image = UIImage(named: "ic_close")
                    cell.upArrowImageView.image = image
                    cell.uploadLabel.text = ""
                    cell.uploadLabel.text = Localization(Constants.LocalisedString.kViewDocuments)
                }
                
                return cell
                
            case 4:
                let cell = yourQuoteTableView.dequeueReusableCell(withIdentifier: "WorkListCellDetailType6", for: indexPath) as! WorkListCellDetailType6
                cell.delegate = self
                return cell
            default:
                return UITableViewCell()
            }
            
        }
        
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkListCellDetailType1", for: indexPath) as! WorkListCellDetailType1
            
            cell.jobName.textAlignment = Localisator.sharedInstance.currentTextDirection
            cell.jobName.text = job?.title
            cell.posterName.text = job?.posterName
            if (job?.posterProfileImage != nil) {
                cell.profileImage.sd_setImage(with: NSURL(string: (job?.posterProfileImage!)! ) as URL!, placeholderImage: UIImage(named: "placeholder_square"))
            }
            let userCount = job?.totalFeedbackUser
            let pointCount = job?.totalFeedbackPoint
            if(userCount != 0 && userCount != nil && pointCount != nil) {
                cell.calculateRating(totalUser: userCount!, totalPoint: pointCount!)
                cell.membersRatingCount.text = String.localizedStringWithFormat(NSLocalizedString("%d Members",comment:""), Int(userCount!))
            }
            cell.profileVerifiedIcon.isHidden = true
            if let verified = job?.isProfileVerified{
                if verified.intValue == 1{
                    cell.profileVerifiedIcon.isHidden = false
                }
            }
            return cell
            
        }else if indexPath.row == 14 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkListCellDetailType5", for: indexPath) as! WorkListCellDetailType5
            cell.titleLabel.text = Localization("Download Documents")
            cell.delegate = self
            let image = UIImage(named: "ic_down_arrow")
            cell.upArrowImageView.image = image
            cell.uploadLabel.text = ""
            cell.uploadLabel.text = Localization(Constants.LocalisedString.kDownload)
            return cell
            
        }else if indexPath.row == 15 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkListCellDetailType3", for: indexPath) as! WorkListCellDetailType3
            cell.delegate = self
            return cell
            
        }else if indexPath.row == 16 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkListCellDetailType4", for: indexPath) as! WorkListCellDetailType4
            cell.delegate = self
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkListCellDetailType2", for: indexPath) as! WorkListCellDetailType2
            
            switch indexPath.row {
            case 1:
                cell.name.text = Localization("Job Id")
                cell.value.text = "\((job?.jobId)!)"
            case 2:
                cell.name.text = Localization("Date of Posting")
                let newDate = job?.createdAt?.components(separatedBy: " ").first
                if newDate == "0000-00-00"{
                    cell.value.text = ""
                } else {
                    cell.value.text = getDateAndTime(dateInString: newDate!)
                }
                
            case 3:
                cell.name.text = Localization("No of Members Applied")
                
                if (job?.membersApplied != nil){
                    if job?.membersApplied?.intValue == 0 {
                        cell.value.text = "0"
                    }else if job?.membersApplied?.intValue == 1 {
                        cell.value.text = "1"
                    }else{
                        cell.value.text = "\((job?.membersApplied?.intValue)!)"
                    }
                }else{
                    cell.value.text = "0"
                }
                
            case 4:
                cell.name.text = Localization("Job Type")
                
                if job?.jobType == 1 {
                    cell.value.text = Localization("Physical")
                }else{
                    cell.value.text = Localization("Virtual")
                }
                
                
            case 5:
                cell.name.text = Localization("Location")
                cell.value.text = job?.cityName
            case 6:
                cell.name.text = Localization("Start Date")
                let newDate = job?.serviceStartTime?.components(separatedBy: " ").first
                if newDate == "0000-00-00"{
                    cell.value.text = ""
                } else {
                    cell.value.text = getDateAndTime(dateInString: newDate!)
                }
            case 7:
                cell.name.text = Localization("End Date")
                let newDate = job?.serviceEndTime?.components(separatedBy: " ").first
                if newDate == "0000-00-00"{
                    cell.value.text = ""
                } else {
                    cell.value.text = getDateAndTime(dateInString: newDate!)
                }
            case 8:
                cell.name.text = Localization("Price Range")
                cell.value.text = "\((job?.priceMin)!) - \((job?.priceMax)!) \(currencyText)"
            case 9:
                cell.name.text = Localization("Deposit Money")
                cell.value.text = "\((job?.moneyDeposite)!) \(currencyText)"
            case 10:
                cell.name.text = Localization("Bidding End Date")
                let newDate = job?.biddingEndDate?.components(separatedBy: " ").first
                if newDate == "0000-00-00"{
                    cell.value.text = ""
                } else {
                    cell.value.text = getDateAndTime(dateInString: newDate!)
                }
            case 11:
                
                cell.name.text = Localization("Description")
                cell.value.text = "\((job?.jobDescription)!)"
                cell.value.numberOfLines = 0
                cell.value.lineBreakMode = .byWordWrapping
                
            case 12:
                cell.name.text = Localization("Category")
                cell.value.text = "\((job?.categoryName)!)"
            case 13:
                cell.name.text = Localization("Tags")
                cell.value.text = job?.tagNames
                cell.nameWidth.constant = 60.0
            default:
                cell.name.text = Localization("TO DO")
                cell.value.text = job?.cityName
            }
            
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if tableView == yourQuoteTableView {
            
            if indexPath.row == 1 {
                return 0
            }
            else if indexPath.row == 2 {
                return 90
            }else {
                return 61
            }
            
        }else{
            if(indexPath.row == 11) {
                var height:CGFloat = 0.0
                if(Localisator.sharedInstance.currentLanguage == "en"){
                    height = requiredRowHeight(text: "\((job?.jobDescription)!)", width: tableView.frame.size.width - 255, fontName: "FSJoey-Medium", fontSize: 12.0)
                }else{
                    height = requiredRowHeight(text: "\((job?.jobDescription)!)", width: tableView.frame.size.width - 255, fontName: "GeezaPro", fontSize: 12.0)
                }
                
                if height < 35 {
                    return 35
                }
                return (height)
            }
            
            if indexPath.row == 0 {
                return 90
            }else if indexPath.row == 15 || indexPath.row == 16 {
                return 90
            } else if indexPath.row == 9 {
                return 0
            }
            else{
                return 35
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
    }
    
}

extension WorkJobDetails: WorkListCellDetailType4Delegate, WorkListCellDetailType3Delegate, APUploadButtonDelegate, APImageDataDelegate, WorkListCellDetailType5Delegate, WorkListCellDetailType6Delegate{
    
    func reportButtonPressed(sender:WorkListCellDetailType4){
        if UserManager.sharedManager().isUserLoggedIn() {
            self.setTabBarVisible(visible: false, animated: true)
            let vc = UIStoryboard.sendReportVC()
            vc?.jobId = "\((job?.jobId)!)"
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else {
            self.alertWithOkAndCancel("", message: Constants.SIGNUP_MESSAGE, actionHandler: {
                AppDelegate.presentRootViewController(false, rootViewIdentifier: .toShowLoginScreen)
            })
        }
    }
    
    func bidButtonPressed(sender:WorkListCellDetailType3){
        
        if UserManager.sharedManager().isUserLoggedIn() {
            bidView.isHidden = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            bidDate = dateFormatter.string(from: Date())
            self.setTabBarVisible(visible: false, animated: true)
        }
        else {
            self.alertWithOkAndCancel("", message: Constants.SIGNUP_MESSAGE, actionHandler: {
                AppDelegate.presentRootViewController(false, rootViewIdentifier: .toShowLoginScreen)
            })
        }
        
    }
    
    func postBidButtonPressed(sender: WorkListCellDetailType6) {
        
        self.view.endEditing(true)
        
        if(textValidations()) {
            self.checkForDoc()
            self.bidJobAPI()
        }
    }
    
    
    func downloadButtonPressed(sender:WorkListCellDetailType5){
        if UserManager.sharedManager().isUserLoggedIn() {
            self.setTabBarVisible(visible: false, animated: true)
            let postJob  = UIStoryboard(name: "PostJob", bundle: nil)
            let docVC = postJob.instantiateViewController(withIdentifier: "DownloadDocVC") as! APDownloadDocumentVC
            docVC.serviceRequestId = job?.jobId
            self.navigationController?.pushViewController(docVC, animated: false)
        }
        else {
            self.alertWithOkAndCancel("", message: Constants.SIGNUP_MESSAGE, actionHandler: {
                AppDelegate.presentRootViewController(false, rootViewIdentifier: .toShowLoginScreen)
            })
        }
    }
    
    //MARK: APUploadButtonDelegate
    func uploadBtnPressed() {
        
        self.setTabBarVisible(visible: false, animated: true)
        
        let uploadStoryboard  = UIStoryboard(name: "PostJob", bundle: nil)
        if let uploadVC = uploadStoryboard.instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.kUploadVC) as? APUploadDocumentVC {
            uploadVC.delegate = self
            
            if self.flagHideTopButtons{
                
                uploadVC.flagHideTopButtons = true
            }
            
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
            self.navigationController?.pushViewController(uploadVC, animated: false)
        }
    }
    
    
    //MARK: APImageDataDelegate
    func getImageData(dict: [String : Any],isFirstImageUploaded isfirstImageUploaded : Bool, isSecondImageUploaded : Bool, isThirdImageUploaded : Bool ,imagesEdited: NSMutableArray ,completion: @escaping () -> Void) {
        
        //self.setTabBarVisible(visible: true, animated: true)
        
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
        self.yourQuoteTableView.reloadData()
        completion()
    }
    
    /// Adds All uploaded document parameters To Requset param
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
            param["serviceImage"] = imagePathArr
            param["serviceImageTitle"] = imageTitleArr
            param["serviceImageUrl"] = imageURLArr
        }
    }
    
    func bidJobAPI() {
        
        param = param.union(deviceInfo())
        //show loader
        if self.navigationController == nil {
            self.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        }else{
            self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
            
        }
        
        Job.bidJobRequest(param: param,completion: { (success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async{
                if self.navigationController == nil{
                    self.view.hideLoader()
                }else{
                    self.navigationController!.view.hideLoader()
                }
                
                if success {
                    
                    let alertController = UIAlertController(title: "", message: Localization("Bidding done successfully!"), preferredStyle: UIAlertControllerStyle.alert)
                    let closeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
                        
                        self.bidView.isHidden = true
                        self.setTabBarVisible(visible: true, animated: true)
                        self.delegate?.updatePage()
                        let _ =  self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(closeAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                }
                else {
                    self.view.makeToast((error?.localizedDescription)!, duration: 3, position: .center)
                }
            }
        })
        
    }
    
    func textValidations() -> Bool {
        
        //        let cell1 = yourQuoteTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as!BidCellType1
        //        let cell2 = yourQuoteTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as!BidCellType2
        //        let cell3 = yourQuoteTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as!BidCellType3
        
        let text = bidAmount.replacingOccurrences(of: " SAR", with: "").trimmed()
        
        if (text.trimmed() == ""){
            self.view.makeToast("Please enter price.", duration: 3, position: .center)
            return false
        }
        //NOTE: removed after client feedback to allow arabic numbers
        //        if (Int(text)! > 999999){
        //            self.view.makeToast("Price should not be greater than 999999 SAR", duration: 3, position: .center)
        //            return false
        //        }
        if( bidDate == "") {
            self.view.makeToast("Please provide end time.", duration: 3, position: .center)
            return false
        }
        if( bidCoverText == Localization("Enter cover text.") ) {
            self.view.makeToast(Localization("Enter cover text."), duration: 3, position: .center)
            return false
        }
        
        if(bidCoverText.length > 255) {
            self.view.makeToast("Cover letter text should not be greater than 255 characters.", duration: 3, position: .center)
            return false
        }
        
        param["serviceRequestId"] = "\((job?.jobId)!)"
        param["price"] = text
        param["endTime"] = "11/03/2017"//bidDate
        param["coverText"] = bidCoverText.replacingOccurrences(of: "\u{00a0}", with: " ")
        
        return true
    }
  
}

extension WorkJobDetails: BidCellValues{
    
    func setAmount(text:String){
        bidAmount = text
    }
    
    func setDate(text:String){
        bidDate = text
    }
    
    func setCoverText(text:String){
        bidCoverText = text
    }
    
}
