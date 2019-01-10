//
//  APJobsListVC.swift
//  OnDemandApp
//
//  Created by Shwetabh Singh on 16/08/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import SDWebImage
import IQKeyboardManagerSwift



class APJobsListVC: APJobListBaseVC , AutoCompleteTableViewDelegate , UITextFieldDelegate{
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alertCountLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var searchBgView: UIView!
    @IBOutlet weak var tableViewbg: UIView!
    @IBOutlet weak var noJobsFoundLabel: UILabel!
    @IBOutlet weak var searchView: UIView!
    
    // MARK: - Variables
    var autoCompleteTableView:AutoCompleteTableView?
    var flagShowNotification = false
    
    // MARK: - Constants
    let currencyText = Localization("SAR")
    
    //MARK: - life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(searchBgView)
        searchBgView.frame = self.view.frame
        
        self.jobForpage(page: page, type: "JobList")
        
        if CategoryManager.sharedManager().tags != nil {
            self.pastUrls = CategoryManager.sharedManager().tags!
        }
        
        searchTextField.textAlignment = Localisator.sharedInstance.currentTextDirection
        titleLabel.text = Localization("HOME")
        searchTextField.placeholder = Localization("Search by tag")
        searchTextField.delegate = self
        
        alertCountLabel.layer.cornerRadius = 6
        alertCountLabel.clipsToBounds = true
        alertCountLabel.layer.masksToBounds = true
        
        searchView.layer.cornerRadius = 5
        searchView.layer.borderWidth = 0.5
        searchView.layer.borderColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        searchView.clipsToBounds = true
        searchView.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
        
        tableViewbg.layer.shadowOpacity = 0.1
        tableViewbg.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        tableViewbg.layer.shadowColor = UIColor.darkGray.cgColor
        tableViewbg.layer.shadowRadius = 0.0
        
        setUpAutoPopulateTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(APJobsListVC.updateNotificationCount(_:)), name: Constants.NOTIFICATION_UNREAD_COUNT, object: nil)
        self.view.bringSubview(toFront: noJobsFoundLabel)
        
        UIApplication.shared.statusBarStyle = .default
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func setUpAutoPopulateTableView() -> Void {
        let frame = CGRect(x:searchView.frame.minX + searchTextField.frame.minX, y:searchView.frame.minY + searchView.frame.size.height, width:searchTextField.frame.size.width - 20, height:0)
        autoCompleteTableView = AutoCompleteTableView(frame: frame)
        autoCompleteTableView?.delegate = self
        self.view.addSubview(autoCompleteTableView!)
        
        autoCompleteTableView?.layer.cornerRadius = 5
        autoCompleteTableView?.layer.borderWidth = 1
        autoCompleteTableView?.layer.borderColor = UIColor.white.cgColor
        autoCompleteTableView?.clipsToBounds = true
        autoCompleteTableView?.layer.masksToBounds = true
    }
    
    func updateNotificationCount(_ notification: NSNotification) {
        if let userInfo = notification.userInfo as? [String: AnyObject] {
            DispatchQueue.main.async{
                self.alertCountLabel.text = "\((userInfo["unreadCount"])!)"
            }
        }
        //RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // refresh control methods
    override func refreshView(){
        super.refreshView()
        isRefreshAnimating = true
        self.page = 1
        self.jobForpage(page: page, type: "JobList")
    }
    
    //MARK: - AutoCompleteTableViewDelegate
    func updateTextFieldWithText(text: String, tagId: NSNumber) {
        self.view.endEditing(true)
        self.searchTextField.text = text
        self.searchServiceTypeId = Int(tagId)
        self.page = 1
        self.jobForpage(page: page, type: "JobList")
    }
    
    func showSearchBg(flag: Bool) {
        
        searchBgView.isHidden = !flag
        
        if !flag {
            self.view.bringSubview(toFront: searchBgView)
            self.view.bringSubview(toFront: searchView)
            self.view.bringSubview(toFront: autoCompleteTableView!)
        }
        
    }
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        searchAutocompleteEntriesWithSubstring(substring: substring)
        return true
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        autocompleteUrls.removeAll(keepingCapacity: false)
        for curString in pastUrls
        {
            let myString:NSString! = curString.serviceName as NSString!
            if (myString.lowercased.contains(substring.lowercased()))
            {
                autocompleteUrls.append(curString)
            }
        }
        autoCompleteTableView?.updateDataSource(dataSource: autocompleteUrls)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        autoCompleteTableView?.updateDataSource(dataSource: nil)
        
        if self.searchServiceTypeId != -1 {
            self.view.endEditing(true)
            self.page = 1
            self.searchServiceTypeId = -1
            self.jobForpage(page: page, type: "JobList")
            
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        if((textField.text?.characters.count)! == 0 && self.searchServiceTypeId != -1) {
            self.view.endEditing(true)
            self.page = 1
            self.searchServiceTypeId = -1
            self.jobForpage(page: page, type: "JobList")
        }
    }
    
    
    @IBAction func openNotificationVC(_ sender: Any) {
        
        (sender as! UIButton).isExclusiveTouch =  true
        
        if flagShowNotification {
            return
        }
        flagShowNotification = true
        self.perform(#selector(APJobsListVC.enableNotificationButton), with: nil, afterDelay: 3)
        self.tabBarController?.navigationController?.pushViewController(UIStoryboard.notificationsVC()!, animated: true)
        
    }
    
    func enableNotificationButton() {
        flagShowNotification = false
    }
    
    
}
extension APJobsListVC : WorkListCellDelegate, WorkJobDetailsDelegate{
    
    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.jobList != nil && (self.jobList?.count)! > 0)
        {
            noJobsFoundLabel.isHidden = true
            return (self.jobList?.count)!
        }
        else
        {
            noJobsFoundLabel.isHidden = false
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkListCell", for: indexPath) as! WorkListCell
        
        cell.contentView.layer.shadowOpacity = 0.1
        cell.contentView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.contentView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.contentView.layer.shadowRadius = 20.0
        cell.delegate = self
        cell.jobName.textAlignment = Localisator.sharedInstance.currentTextDirection
        let myJob = self.jobList![(indexPath as NSIndexPath).row] as! Job
        cell.jobName.text = myJob.title
        cell.posterName.text = myJob.posterName
        cell.amount.text = "\((myJob.priceMax)!) \(currencyText)"
        cell.postDate.text = getDateAndTime(dateInString: myJob.biddingEndDate!)
        cell.location.text = myJob.cityName
        cell.detailsButton.setTitle(Localization("DETAILS"), for: .normal)
        if (myJob.posterProfileImage != nil) {
            cell.profileImage.sd_setImage(with: NSURL(string: myJob.posterProfileImage! ) as URL!, placeholderImage: UIImage(named: "placeholder_square"))
        }
        cell.profileVerifiedIcon.isHidden = true
        if let verified = myJob.isProfileVerified{
            if verified.intValue == 1{
                cell.profileVerifiedIcon.isHidden = false
            }
        }
        
        let userCount = myJob.totalFeedbackUser
        let pointCount = myJob.totalFeedbackPoint
        if(userCount != 0 && userCount != nil && pointCount != nil) {
            cell.calculateRating(totalUser: userCount!, totalPoint: pointCount!)
            cell.membersRatingCount.text = String.localizedStringWithFormat(NSLocalizedString("%d Members",comment:""), Int(userCount!))
        }else{
        
            cell.calculateRating(totalUser: NSNumber(value: 0), totalPoint: NSNumber(value: 0))
            cell.membersRatingCount.text = ""
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 137
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func detailButtonPressed(sender: WorkListCell) {
        
        let indexPath = tableView.indexPath(for: sender)
        let jobObj = self.jobList![(indexPath?.row)!] as! Job
        let dashboardStoryboard  = UIStoryboard(name: "Dashboard", bundle: nil)
        let viewController = dashboardStoryboard.instantiateViewController(withIdentifier: "WorkJobDetails") as! WorkJobDetails
        viewController.job = jobObj
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func updatePage() {
        self.jobForpage(page: 1, type: "JobList")
    }
    
    // MARK: - UIScrollView Methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if(self.isRefreshAnimating == false && hasContent){
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height && self.jobList != nil && (self.jobList?.count)! >= 10 ){
                self.tableView.tableFooterView = footerView
                (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                isRefreshAnimating = true
                self.page = self.page + 1
                canScrolldown = true
                self.jobForpage(page: page, type: "JobList")
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    //MARK:- For APJobsListVC
    func jobStatusString(_ job : Job) -> String! {
        if(UserManager.sharedManager().userType == .userTypeSeeker)
        {
            if (Int(job.jobStatus!) == JobStatus.pending.rawValue)
            {
                return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Pending", comment: "")
                
            }else if (Int(job.jobStatus!) == JobStatus.underProcess.rawValue)
            {
                return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Under Process", comment: "")
                
            }else
            {
                return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Unknown", comment: "")
            }
        }
        else
        {
            if (Int(job.jobStatus!) == JobStatus.underProcess.rawValue)
            {
                return NSLocalizedString("Status: ", comment: "") + "Under Process"
                
            }else
            {
                return ""
            }
        }
    }
    
    func nameString(_ job : Job) -> String! {
        if(UserManager.sharedManager().userType == .userTypeSeeker)
        {
            if (Int(job.jobStatus!) == JobStatus.underProcess.rawValue)
            {
                return NSLocalizedString("Provider Name : ", comment: "") + job.providerName!
                
            }else
            {
                return ""
            }
        }
        else
        {
            if (Int(job.jobStatus!) == JobStatus.underProcess.rawValue)
            {
                return NSLocalizedString("Seeker Name : ", comment: "") + job.seekerName!
                
            }else
            {
                return ""
            }
        }
    }
}
