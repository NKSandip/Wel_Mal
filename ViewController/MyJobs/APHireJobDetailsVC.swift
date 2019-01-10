//
//  APHireJobDetailsVC.swift
//  E3malApp
//
//  Created by Rishav Tomar on 26/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class APHireJobDetailsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,APHireJobDetailsButtonDelegate, APHeaderButtonDelegate, APImageDataDelegate, APOngoingButtonDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var postJobBtn: UIButton!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var adminBankDetailView: UIView!
    @IBOutlet weak var BidView: UIView!
    @IBOutlet weak var projectPaymentLabel: UILabel!
    @IBOutlet weak var paymentDescLabel: UILabel!
    @IBOutlet weak var bankNameStaticLabel: UILabel!
    @IBOutlet weak var accountNumberStaticLabel: UILabel!
    @IBOutlet weak var IBANStaticLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var IBANLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var bidHeaderLablel: UILabel!
    @IBOutlet weak var priceStaticLabel: UILabel!
    @IBOutlet weak var documentsStaticLabel: UILabel!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var alertCountLabel: UILabel!
    @IBOutlet weak var IBnumberLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var uploadDocImage: UIImageView!
    @IBOutlet weak var uploadLabel: UILabel!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bankNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendForReviewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var shadowImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var workDocLabel: UILabel!
    
    var checkoutProvider: OPPCheckoutProvider?
    var transaction: OPPTransaction?
    
    // MARK: - Constants
    let currencyText = Localization("SAR")
    let memebersApplied = Localization("MEMBERS APPLIED")
    
    
    //MARK: - Variables
    var refreshControl : UIRefreshControl!
    var isRefreshAnimating = false
    var hasContent = true
    var canScrolldown = false
    var footerView  = UIView()
    var page:Int = 1 // used for pagination
    var flagShowNotification = false
    var selectedIndexPath : Int?
    var isShowMorePressed = false
    var jobRequestedId : Int?
    var jobDetail: Job?
    var selectedIndexes = NSMutableArray()
    var bankDetails: AdminBankDetail?
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
    var activeTextField: UITextField?
    var param = [String: Any]()
    var jobDesc = [String: Any]()
    var isOngoingJob = false
    var isNewJob = false
    var isCompletedJob = false
    var localtextDirection : NSTextAlignment?
    var delegate:JobProgressBaseVCDelegate?
    var flagHideTopButtons = false
    
    @IBOutlet weak var bidViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reviewBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelBottomConstraint: NSLayoutConstraint!
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().previousNextDisplayMode = .alwaysHide
        if let requestId = self.jobRequestedId {
            self.getNewjobList(page: 1,requestId: requestId)
        }
        
        self.setupUI()
        self.initFooterView()
        if flagHideTopButtons {
            alertCountLabel.isHidden = true
            notificationButton.isHidden = true
            postJobBtn.isHidden = true
            cancelBottomSpace.constant = 10
        }
        self.detailsTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func updateNotificationCount(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo as? [String: AnyObject] {
            DispatchQueue.main.async{
                self.alertCountLabel.text = "\((userInfo["unreadCount"])!)"
            }
        }
        //RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))
    }
    
    deinit {
        //NotificationCenter.default.removeObserver(self)
    }
    
    // initialize footerView
    func initFooterView(){
        footerView = UIView.init(frame: CGRect(x:0.0, y:0.0, width:self.view.frame.size.width, height:40.0))
        let actInd = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        actInd.tag = 10
        actInd.frame = CGRect(x:(self.view.frame.size.width/2)-15, y:5.0, width:30.0, height:30.0)
        actInd.hidesWhenStopped = true
        footerView.addSubview(actInd)
        //self.view.addSubview(footerView)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if(UIDevice.current.model.range(of: "iPad") != nil) {
            self.cancelBottomSpace.constant = 5
            self.reviewBtnBottomConstraint.constant = 5
            self.bidViewHeightConstraint.constant = -30
            self.backBtn.frame.size.height = 20
            self.backBtn.frame.size.width = 20
            self.postJobBtn.frame.size.height = 20
            self.postJobBtn.frame.size.width = 20
            self.notificationButton.frame.size.width = 20
            self.notificationButton.frame.size.height = 20
            self.alertCountLabel.frame.origin.x = 283
           self.alertCountLabel.frame.origin.y = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(APHireJobDetailsVC.updateNotificationCount(_:)), name: Constants.NOTIFICATION_UNREAD_COUNT, object: nil)
        
        if !UserManager.sharedManager().isUserLoggedIn() {
            return
        }
        if let count = UserManager.sharedManager().activeUser.unReadCount {
            alertCountLabel.isHidden = false
            if count.intValue > 99 {
                alertCountLabel.text = "99+"
            } else {
                alertCountLabel.text = "\(count)"
            }
            alertCountLabel.isHidden = count.intValue > 0 ? false : true
        }
        if(self.paymentView.isHidden == false){
            self.setTabBarVisible(visible: false, animated: true)
        }
    }
    
    @IBAction func openNotificationVC(_ sender: UIButton) {
        sender.isExclusiveTouch =  true
        if flagShowNotification {
            return
        }
        flagShowNotification = true
        self.perform(#selector(APHireJobDetailsVC.enableNotificationButton), with: nil, afterDelay: 3)
        self.tabBarController?.navigationController?.pushViewController(UIStoryboard.notificationsVC()!, animated: true)
    }
    
    func enableNotificationButton() {
        flagShowNotification = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func setupUI() {
        self.titleLabel.text = Localization("DETAILS")
        self.titleLabel.addLocalizationBold()
        self.titleLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
        self.titleLabel.addTextSpacing(spacing: 1.4)
        
        self.detailsTableView.separatorStyle = .none
        
        let nib = UINib(nibName: "HireListHeaderView", bundle: nil)
        self.detailsTableView.register(nib, forHeaderFooterViewReuseIdentifier: "HireListHeaderView")
        
        let sectionNib = UINib(nibName: "HireListSectionView", bundle: nil)
        self.detailsTableView.register(sectionNib, forHeaderFooterViewReuseIdentifier: "HireListSectionView")
        
        self.reviewBtn.setTitle("SEND FOR REVIEW", for: .normal)
        self.reviewBtn.titleLabel?.font = UIFont(name: "FSJoey-Bold", size: 12)
        self.reviewBtn.addLocalization()
        self.reviewBtn.changeCornerAndColor(20, borderWidth: 0.5 , color: Constants.cornerColor)
        
        self.cancelBtn.setTitle("CANCEL", for: .normal)
        self.cancelBtn.addLocalization()
        
        self.projectPaymentLabel.text = Localization("PROJECT PAYMENT")
        self.projectPaymentLabel.addLocalizationBold()
        self.projectPaymentLabel.addTextSpacing(spacing: 1.4)
        
        self.priceTxtField.keyboardType = .numberPad
        self.priceTxtField.tag = 1
        self.priceTxtField.delegate = self
        self.textDirection()
        self.priceTxtField.textAlignment = self.localtextDirection!
        if (self.isCompletedJob) {
            self.tableViewBottomConstraint.constant = 120
            if(UIScreen.main.bounds.height > 667) {
                self.shadowImageTopConstraint.constant = 480
            }
        }
        else {
            self.detailsTableView.estimatedRowHeight = 198.0
        }
        if(UIScreen.main.bounds.width == 320) {
            self.notificationButton.frame.size.height = 30
            self.backBtn.frame.size.height = 30
            self.postJobBtn.frame.size.height = 30
            self.alertCountLabel.frame.size.height = 10
            self.bankNameTopConstraint.constant = 20
            self.sendForReviewBottomConstraint.constant = 10
            self.cancelBottomSpace.constant = 15
            
        }
        self.paymentViewLocalization()
    }
    
    func paymentViewLocalization() {
        self.IBANStaticLabel.addLocalization()
        self.bankNameStaticLabel.addLocalization()
        self.accountNumberStaticLabel.addLocalization()
        self.priceStaticLabel.addLocalization()
        self.documentsStaticLabel.addLocalization()
        self.paymentDescLabel.addLocalization()
        self.bidHeaderLablel.addLocalization()
        self.IBnumberLabel.addLocalization()
        self.reviewBtn.addLocalization()
        self.priceTxtField.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - APHireJobDetailsButtonDelegate
    func showMoreBtnPressed(tag : Int) {
        let _:HireJobDetailCell = (self.detailsTableView.cellForRow(at: IndexPath(row: tag, section: 1)) as? HireJobDetailCell)!
        let indexPath: IndexPath = IndexPath(row: tag, section: 1)
        if (jobDetail?.associateWorkers?[indexPath.row].isMore.boolValue)! {
            jobDetail?.associateWorkers?[indexPath.row].isMore = NSNumber(value: false)
        }else{
            jobDetail?.associateWorkers?[indexPath.row].isMore = NSNumber(value: true)
        }
        self.detailsTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func chatBtnPressed(tag: Int) {
        self.chatTestAction(jobBidMemberObj:jobDetail!.associateWorkers![tag])
    }
    
    func imageTapped(tag: Int) {
        let userId = jobDetail!.associateWorkers![tag].providerId as? Int
        let viewController:PublicProfileViewController = UIStoryboard(name: "PublicProfile", bundle: nil).instantiateViewController(withIdentifier: "PublicProfileViewController") as UIViewController as! PublicProfileViewController
        viewController.userId = userId!
        viewController.hidesBottomBarWhenPushed = true
        self.present(viewController, animated: true, completion: nil)
    }
    
    func acceptBtnPressed(tag: Int) {
        if(jobDetail?.associateWorkers?[tag].acceptanceStatus != 2) {
            self.setTabBarVisible(visible: false, animated: true)
            param["serviceAssignmentId"] =  jobDetail?.associateWorkers?[tag].id!
            param["acceptancePrice"] =  jobDetail?.associateWorkers?[tag].price!
            self.getAdminBankDetail()
        }
        else {
            self.view.makeToast("The job is already sent for review.", duration: 3, position: .center)
        }
    }
    
    func messageBtnPressed() {
        if let jobBidMember = jobDetail!.associateWorkers?[0]{
            self.chatTestAction(jobBidMemberObj:jobBidMember)
        }
    }
    
    func downloadBtnPressed(tag: Int){
        if let bidId =  ((jobDetail?.associateWorkers?[tag])! as JobBidMember).id
        {
            self.setTabBarVisible(visible: false, animated: true)
            let postJob  = UIStoryboard(name: "PostJob", bundle: nil)
            let docVC = postJob.instantiateViewController(withIdentifier: "DownloadDocVC") as! APDownloadDocumentVC
            docVC.navigationType = NavType.kNavTypeBidder
            docVC.serviceRequestId = bidId
            self.navigationController?.pushViewController(docVC, animated: false)
        }
    }
    
    func declineBtnPressed() {
        let reportVC  = UIStoryboard.sendReportVC()
        reportVC?.viewType = Constants.kViewTypeDecline
        reportVC?.jobId = String((self.jobDetail?.id?.intValue)!)
        reportVC?.job = self.jobDetail
        self.navigationController?.pushViewController(reportVC!, animated: false)
    }
    
    func completeBtnPressed() {
        self.markAsComplete()
        
    }
    
    // MARK: - Action Methods
    @IBAction func postjobBtnPressed(_ sender: UIButton) {
        let postJob  = UIStoryboard(name: "PostJob", bundle: nil)
        let postJobVC = postJob.instantiateViewController(withIdentifier: "PostJobVC")
        
        self.navigationController?.pushViewController(postJobVC, animated: false)
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        self.paymentView.isHidden = true
        self.setTabBarVisible(visible: true, animated: true)
    }
    
    @IBAction func uploadBtnPressed(_ sender: UIButton) {
        self.setTabBarVisible(visible: false, animated: true)
        
        let uploadStoryboard  = UIStoryboard(name: "PostJob", bundle: nil)
        if let uploadVC = uploadStoryboard.instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.kUploadVC) as? APUploadDocumentVC {
            
            if self.flagHideTopButtons{
                
                uploadVC.flagHideTopButtons = true
            }
            
            uploadVC.delegate = self
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
    
    @IBAction func reviewBtnPressed(_ sender: UIButton) {
        self.checkForDoc()
        if textValidations() {
            self.sendForReview()
        }
    }
    
    //MARK: - APImageDataDelegate
    func getImageData(dict: [String : Any],isFirstImageUploaded isfirstImageUploaded : Bool, isSecondImageUploaded : Bool, isThirdImageUploaded : Bool,imagesEdited: NSMutableArray,completion: @escaping () -> Void) {
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
        if(isfirstImageUploaded || isSecondImageUploaded || isThirdImageUploaded) {
            let image = UIImage(named: "ic_close")
            self.uploadDocImage.image = image
            self.uploadLabel.text = ""
            self.uploadLabel.text = Localization(Constants.LocalisedString.kViewDocuments)
        }
        else {
            let image = UIImage(named: "ic_up_arrow")
            self.uploadDocImage.image = image
            self.uploadLabel.text = ""
            self.uploadLabel.text = Localization(Constants.LocalisedString.kUpload)
        }
        completion()
    }
    
    //MARK: - Validations Method
    func textValidations() -> Bool {
        if(self.priceTxtField.text?.isEmpty)! {
            self.view.makeToast("Please enter acceptence price", duration: 3, position: .bottom)
            return false
        }
        else if(param["arrInvoiceFile"] == nil) {
            self.view.makeToast("Please upload Invoice.", duration: 3, position: .bottom)
            return false
        }
        
        return true
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
            param["arrInvoiceFile"] = imagePathArr
            param["arrInvoiceTitle"] = imageTitleArr
        }
    }
    
    //MARK: - APHeaderButtonDelegate
    func editBtnPressed() {
        let postJob  = UIStoryboard(name: "PostJob", bundle: nil)
        let postJobVC = postJob.instantiateViewController(withIdentifier: "PostJobVC") as? APPostJobViewController
        if flagHideTopButtons {
            postJobVC?.flagHideTopButtons = true
        }
        
        postJobVC?.param["title"] = self.jobDesc["title"]
        if let jobType: Int = self.jobDesc["jobType"] as? Int  {
            if (jobType == 1) {
                postJobVC?.jobType = 1
            }
            else {
                postJobVC?.jobType = 2
            }
        }
        postJobVC?.param["minPrice"] = self.jobDesc["minPrice"]
        postJobVC?.param["maxPrice"] = self.jobDesc["maxPrice"]
        postJobVC?.param["serviceDescription"] = self.jobDesc["serviceDescription"]
        if(self.jobDesc["serviceDescription"] != nil) {
            postJobVC?.isTextViewEmpty = false
        }
        postJobVC?.selectedCountryName = self.jobDesc["countryName"] as! String?
        postJobVC?.selectedCityName  = self.jobDesc["cityName"] as! String?
        postJobVC?.selectedCityId = self.jobDesc["cityId"] as! NSNumber?
        postJobVC?.selectedCountryId = self.jobDesc["countryId"] as! NSNumber?
        postJobVC?.isEditJob = true
        postJobVC?.jobId = self.jobDetail?.id
        postJobVC?.startDate = self.jobDesc["startDate"] as! Date?
        postJobVC?.endDate = self.jobDesc["endDate"] as! Date?
        postJobVC?.biddingDate = self.jobDesc["biddingEndDate"] as! Date?
        postJobVC?.categoryName = (self.jobDetail?.categoryName)!
        postJobVC?.categoryId = self.jobDetail?.selectedCategoryId
        postJobVC?.tagNames = (self.jobDetail?.tagNames)!
        postJobVC?.tagIds = (self.jobDetail?.tagIds)!
        postJobVC?.doclist = self.jobDetail?.serviceDocument
        
        self.navigationController?.pushViewController(postJobVC!, animated: false)
    }
    
    func deleteBtnPressed() {
        let actionSheet = UIAlertController(title: Localization("Confirm to Delete"), message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.deleteJob()
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func shareBtnPressed() {
        var shareText = (self.jobDetail?.title)!  + "\n" + (self.jobDetail?.jobDescription)!
        
        let newDate = self.jobDetail?.createdAt?.components(separatedBy: " ").first
        if newDate == "0000-00-00"{
            
        } else {
            shareText = shareText + "Date of Posting :" + getDateAndTime(dateInString: newDate!) + "\n"
        }
        
        let endDate = self.jobDetail?.serviceEndTime?.components(separatedBy: " ").first
        if endDate == "0000-00-00"{
            
        } else {
            
            shareText = shareText + "Job End Date :" + getDateAndTime(dateInString: endDate!) + "\n"
        }
        
        let bidEndDate = self.jobDetail?.biddingEndDate?.components(separatedBy: " ").first
        if bidEndDate == "0000-00-00"{
            
        } else {
            
            shareText = shareText + "Bid End Date :" + getDateAndTime(dateInString: bidEndDate!) + "\n"
        }
        shareText = shareText + "Price Range :" + "\((self.jobDetail?.priceMin)!) - \((self.jobDetail?.priceMax)!) \(currencyText)" + "\n"
        shareText = shareText + "Deposit Amount :" + "\((self.jobDetail?.moneyDeposite)!) \(currencyText)" + "\n"
        
        shareText = shareText + "E3mal : https://itunes.apple.com/us/app/e3mal-%D8%A7%D8%B9%D9%85%D9%84/id1193940966?ls=1&mt=8"
        
        let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
        
        present(vc, animated: true)
        
    }
    
    func docBtnPressed() {
        self.setTabBarVisible(visible: false, animated: true)
        let postJob  = UIStoryboard(name: "PostJob", bundle: nil)
        if let docVC = postJob.instantiateViewController(withIdentifier: "DownloadDocVC") as? APDownloadDocumentVC {
            docVC.serviceRequestId = self.jobRequestedId as NSNumber?
            self.navigationController?.pushViewController(docVC, animated: false)
        }
    }
    
    func textDirection() {
        localtextDirection = .right
        if Localisator.sharedInstance.currentLanguage == "en" {
            localtextDirection = .right
        } else if Localisator.sharedInstance.currentLanguage  == "ar" {
            localtextDirection = .left
        }
    }
    
    // MARK: - Picker Methods
    func openDatePicker() {
        let datePickerView:UIDatePicker = UIDatePicker()
        let locale = NSLocale.init(localeIdentifier: "en_US") as Locale
        datePickerView.locale = locale
        datePickerView.datePickerMode = UIDatePickerMode.date
        activeTextField?.inputView = datePickerView
        
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        let newDateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        newDateFormatter.locale = locale
        newDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        datePickerView.minimumDate = currentDate as Date
        DispatchQueue.main.async {
            self.activeTextField?.text = dateFormatter.string(from: currentDate as Date)
            self.param["acceptanceEndDate"] = newDateFormatter.string(from: currentDate as Date)
        }
        
        datePickerView.addTarget(self, action: #selector(APPostSignupProfileViewController.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(_ sender : UIDatePicker)  {
        let locale = NSLocale.init(localeIdentifier: "en_US") as Locale
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "dd MMM yyyy"
        let newDateFormatter = DateFormatter()
        newDateFormatter.locale = locale
        newDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        activeTextField?.text = dateFormatter.string(from: sender.date)
        self.param["acceptanceEndDate"] = newDateFormatter.string(from: sender.date)
    }
    
    //MARK: - TableView Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.isCompletedJob) {
            return 290
        }
        else if(self.isOngoingJob && indexPath.row == 1) {
            return 250
        }
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.isCompletedJob) {
            return 290
        }
        else if(self.isOngoingJob && indexPath.row == 1) {
            return 250
        }
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 1) {
            if(self.isNewJob) {
                if let count = jobDetail?.associateWorkers?.count {
                    return count
                }
                return 0
            }
            else if(self.isOngoingJob) {
                if let count = jobDetail?.associateWorkers?.count {
                    if(count != 0) {
                        return count + 1
                    }
                    else {
                        return 0
                    }
                }
                return 0
            }
            else {
                if let count = jobDetail?.associateWorkers?.count {
                    if(count != 0) {
                        return 1
                    }
                    else {
                        return 0
                    }
                }
                return 0
            }
        }
        return 0
    }
    
    //MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        if(self.isNewJob) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HireDetailCell" , for: indexPath) as! HireJobDetailCell
            self.configureCell(cell: cell, indexPath: indexPath)
            returnCell = cell
            
        }
        else if(self.isOngoingJob) {
            if(indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HireDetailCell" , for: indexPath) as! HireJobDetailCell
                self.configureCell(cell: cell, indexPath: indexPath)
                returnCell = cell
            }
            else if( indexPath.row == 1) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HireOngoingCell" , for: indexPath) as! HireOngoingJobCell
                cell.delegate = self
                returnCell = cell
            }
        }
        else if(self.isCompletedJob) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HireCompletedJob" , for: indexPath) as! HireCompletedCell
            cell.nameLabel.text = jobDetail?.associateWorkers?[indexPath.row].name
            
            let acceptancePrice = jobDetail?.associateWorkers?[indexPath.row].price!
            cell.agreedPriceLabel.text = String(describing: acceptancePrice!) + " " + self.currencyText
            
            let amtPaid = jobDetail?.associateWorkers?[indexPath.row].acceptancePrice!
            
            cell.dateOfPaymentLabel.text = getDateAndTime(dateInString: (jobDetail?.associateWorkers?[indexPath.row].acceptanceEndDate)!)
            
            cell.amountPaidLabel.text = String(describing: amtPaid!) + " " + self.currencyText
            
            if let seekerPoint = jobDetail?.seekerFeedbackPoint {
                cell.calculateRating(totalUser: 0, totalPoint: seekerPoint)
            }
            if let providerPoint =  jobDetail?.providerFeedbackPoint {
                cell.calculateRating2(totalUser: 0, totalPoint:providerPoint)
            }
            returnCell = cell
        }
        
        return returnCell
    }
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.size.width, height: rect.size.height)
        return size
    }
    
    func configureCell(cell: HireJobDetailCell, indexPath: IndexPath) {
        cell.delegate = self
        cell.nameLabel.text = jobDetail?.associateWorkers?[indexPath.row].name
        cell.locationLabel.text = jobDetail?.associateWorkers?[indexPath.row].cityName
        
        let price = jobDetail?.associateWorkers?[indexPath.row].price!
        cell.amountLabel.text = String(describing: price!) + " " + self.currencyText
        cell.amountLabel.addTextSpacing(spacing: 0.8)

        let endTime = getDateAndTimeForHireJobDetail(dateInString: (jobDetail?.associateWorkers?[indexPath.row].createdAt!)!)
        cell.dateLabel.text = endTime
        
        if (jobDetail?.associateWorkers?[indexPath.row].profileImage != nil) {
            let url = jobDetail?.associateWorkers?[indexPath.row].profileImage
            cell.personImage.sd_setImage(with: NSURL(string: url!) as URL!, placeholderImage: UIImage(named: "placeholder_square"))
        }
        cell.showMoreBtn.tag = indexPath.row
        cell.imageBtn.tag = indexPath.row
        if(self.isOngoingJob) {
            cell.chatBtn.isHidden  = true
            cell.acceptBtn.isHidden = true
            cell.chatLabel.isHidden = true
            cell.chatImage.isHidden = true
            cell.acceptLabel.isHidden = true
            cell.tickImage.isHidden = true
            cell.AmtTrailingConstraint.constant = 20
        }
        else {
            cell.chatBtn.tag   = indexPath.row
            cell.acceptBtn.tag = indexPath.row
            cell.downloadBtn.tag = indexPath.row
            if(UIScreen.main.bounds.size.width == 320) {
                cell.chatImageLeadingConstraint.constant = 15
                cell.AmtTrailingConstraint.constant = 138
            }
        }
        
        let text:String? = jobDetail?.associateWorkers?[indexPath.row].coverText
        let dynamicSize:CGSize?
        if Localisator.sharedInstance.currentLanguage  == "ar" {
            dynamicSize =  self.rectForText(text: text!, font: UIFont(name: "GeezaPro", size: 10)!, maxSize: CGSize(width:( UIScreen.main.bounds.size.width - 75), height: 999))
            
        }else{
            dynamicSize =  self.rectForText(text: text!, font: UIFont(name: "FSJoey", size: 10)!, maxSize: CGSize(width:( UIScreen.main.bounds.size.width - 75), height: 999))
        }
        
        cell.descTxtLabel?.text = text;
        if (jobDetail?.associateWorkers?[indexPath.row].isMore.boolValue)! {
            cell.descTxtLabel?.text = text;
            cell.descheightConstraint.constant = (dynamicSize?.height)!
            cell.showMoreBtn.setTitle(Localization("less"), for: .normal)
        }else{
            if(text?.length)! < 200 {
                cell.showMoreBtn.isHidden = true
                cell.descHeightOfMoreBtnConstraint.constant = 0
            }else {
                cell.showMoreBtn.isHidden = false
                cell.showMoreBtn.setTitle(Localization("more"), for: .normal)
                let str:String?
                if (text?.length)! > 200{
                    let index = text?.index((text?.startIndex)!, offsetBy: 200)
                    str =  text!.substring(to: index!)
                }else{
                    let index = text?.index((text?.startIndex)!, offsetBy: (text?.length)!)
                    str =  text!.substring(to: index!)
                }
                cell.descTxtLabel?.text =  str;
                cell.descheightConstraint.constant = 20
            }
        }
        cell.descTxtLabel.numberOfLines = 0
        cell.descTxtLabel?.lineBreakMode = .byWordWrapping
        cell.layoutIfNeeded()
        let userCount = jobDetail?.associateWorkers?[indexPath.row].totalFeedbackUser
        let pointCount = jobDetail?.associateWorkers?[indexPath.row].totalFeedbackPoint
        if(userCount != 0 && userCount != nil && pointCount != nil) {
            cell.calculateRating(totalUser: userCount!, totalPoint: pointCount!)
            cell.memberCountLabel.text = String.localizedStringWithFormat(NSLocalizedString("%d Members",comment:""), Int(userCount!))
        }
        if Localisator.sharedInstance.currentLanguage  == "ar" {
            cell.showMoreBtn.titleLabel?.textAlignment = .right
            cell.showMoreBtn.contentHorizontalAlignment = .right
            cell.showMoreBtn.titleEdgeInsets  = UIEdgeInsetsMake(0,
                                                                 0,
                                                                 0,-1)
            cell.downloadBtn.titleEdgeInsets  = UIEdgeInsetsMake(0,
                                                                 0,
                                                                 0,-1)
            
        }
        cell.profileVerifiedIcon.isHidden = true
        if let verified = jobDetail?.associateWorkers?[indexPath.row].isProfileVerified {
            if verified.intValue == 1 {
                cell.profileVerifiedIcon.isHidden = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view : UIView?
        if(section == 0){
            let headerView = self.detailsTableView.dequeueReusableHeaderFooterView(withIdentifier: "HireListHeaderView") as? HireListHeaderView
            if let jobDetail = self.jobDetail {
                headerView?.delegate = self
                let postDateTime = getDateAndTimeForHireJobDetail(dateInString: jobDetail.serviceStartTime!)
                let endDateTime = getDateAndTimeForHireJobDetail(dateInString: jobDetail.serviceEndTime!)
                headerView?.postDateLabel.text = postDateTime
                headerView?.endDateLabel.text = endDateTime
                headerView?.depositAmtLabel.text = String(describing: jobDetail.moneyDeposite!) + " \(self.currencyText)"
                headerView?.priceRangeLabel.text = "\(jobDetail.priceMin!)" + "-" + "\(jobDetail.priceMax!)" + " \(self.currencyText)"
                headerView?.jobNameLabel.text = jobDetail.title!
                headerView?.jobType.text = String(describing: jobDetail.id!)
                if (jobDetail.profileImage != nil) {
                    headerView?.profileImage.sd_setImage(with: NSURL(string: jobDetail.profileImage! ) as URL!, placeholderImage: UIImage(named: "placeholder_square"))
                }
                if(self.isOngoingJob || self.isCompletedJob) {
                    headerView?.editBtn.isHidden = true
                    headerView?.shadowEditBtn.isHidden = true
                    headerView?.bidEndDateLabel.isHidden = true
                    headerView?.bidEndDateStaticLabel.isHidden = true
                    headerView?.deleteBtn.isHidden = true
                }
                else{
                    let bidEndDate = getDateAndTime(dateInString: jobDetail.biddingEndDate!)
                    headerView?.bidEndDateLabel.text = bidEndDate
                    self.jobDesc["title"] = jobDetail.title
                    self.jobDesc["jobType"] = jobDetail.jobType
                    self.jobDesc["minPrice"] = jobDetail.priceMin
                    self.jobDesc["maxPrice"] = jobDetail.priceMax
                    self.jobDesc["serviceDescription"] = jobDetail.jobDescription
                    self.jobDesc["countryName"] = jobDetail.countryName
                    self.jobDesc["countryId"] = jobDetail.countryId
                    self.jobDesc["cityName"] = jobDetail.cityName
                    self.jobDesc["cityId"] = jobDetail.cityId
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    self.jobDesc["startDate"] = dateFormatter.date(from: jobDetail.serviceStartTime!)
                    self.jobDesc["endDate"] = dateFormatter.date(from: jobDetail.serviceEndTime!)
                    let newDateFormatter = DateFormatter()
                    newDateFormatter.dateFormat = "yyyy-MM-dd"
                    self.jobDesc["biddingEndDate"] = newDateFormatter.date(from: jobDetail.biddingEndDate!)
                }
            }
            view =  headerView
        }
        else if (section == 1){
            let sectionHeader = self.detailsTableView.dequeueReusableHeaderFooterView(withIdentifier: "HireListSectionView") as? HireListSectionView
            if(self.isNewJob) {
                if let workers = jobDetail?.membersApplied {
                    if(workers != 0 ) {
                        let count : String = String(describing: workers)
                        sectionHeader?.membersCountLabel.text = count + " " + self.memebersApplied
                        sectionHeader?.membersCountLabel.addTextSpacing(spacing: 1.1)
                        sectionHeader?.membersCountLabel.addLocalization()
                    }
                }
            }
            else if(self.isOngoingJob) {
                sectionHeader?.membersCountLabel.text = Localization("AWARDED TO")
                sectionHeader?.membersCountLabel.addTextSpacing(spacing: 1.1)
                sectionHeader?.topConstraint.constant = 15
                sectionHeader?.membersCountLabel.addLocalization()
            }
            view = sectionHeader
        }
        return view!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 195
        }
        else if(self.isNewJob && section == 1) {
            return 50
        }
        else if(self.isOngoingJob && section == 1) {
            return 35
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        
        if isRefreshAnimating {
            return footerView.frame.size.height
        }else{
            
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if(self.isRefreshAnimating == false && hasContent){
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height - 0.5)  && jobDetail?.associateWorkers != nil && (jobDetail?.associateWorkers?.count)! >= 10 ){
                self.detailsTableView.tableFooterView = footerView
                (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                isRefreshAnimating = true
                print("scrollViewDidEndDecelerating")
                self.page = self.page + 1
                canScrolldown = true
                self.getNewjobList(page: self.page , requestId: self.jobRequestedId!)
                
//                DispatchQueue.main.async(execute: { () -> Void in
//                    //self.detailsTableView.reloadData()
//                })
            }
        }
    }
}



// MARK: - UITextFieldDelegate
extension APHireJobDetailsVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let isFirstResponder = textField.isFirstResponder
        if isFirstResponder == true {
            activeTextField = textField
            switch textField.tag {
            case 2:
                self.openDatePicker()
            default:()
            }
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            param["acceptancePrice"] = textField.text
            if !((textField.text?.isEmpty)!) {
                textField.text = textField.text! + " " + currencyText
            }
        default:()
        }
        if (textField == priceTxtField )&&(  textField.text?.contains("SAR"))! == false {
            textField.text = textField.text! + " " + "SAR"
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField == priceTxtField ){
            
            if ((textField.text?.contains("SAR"))!) {
                textField.text = textField.text!.replacingOccurrences(of: "SAR", with: "")
            }
            textField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == self.priceTxtField) {
            if((textField.text?.characters.count)! > 5 && range.length == 0) {
                return false;
            }
        }
        return true;
    }
}
