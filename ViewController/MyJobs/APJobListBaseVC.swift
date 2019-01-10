//
//  APJobListBaseVC.swift
//  OnDemandApp
//
//  Created by Shwetabh Singh on 21/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class APJobListBaseVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl : UIRefreshControl!
    var isRefreshAnimating = false
    var hasContent = true
    var canScrolldown = false
    var footerView  = UIView()
    var page:Int = 1 // used for pagination
    var jobList : [AnyObject]?
    var pendingFeedbackList : [AnyObject]?
    var indexPath : NSIndexPath?
    var searchServiceTypeId = -1
    
    var autocompleteUrls = [E3malServiceType]()
    var pastUrls = [E3malServiceType]()
    var feedBackView:FeedBackView?
    var starRating: String = "5"
    
    @IBOutlet var ratingsView: UIView!
    
    //MARK: - life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorColor = UIColor.black
        self.initializeRefreshControl()
        self.initFooterView()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // add refresh control
    func initializeRefreshControl(){
        self.refreshControl = UIRefreshControl.getRefreshControl(self)
        self.tableView.addSubview(refreshControl)
    }
    
    // refresh control methods
    func refreshView(){
        isRefreshAnimating = true
        self.page = 1
    }
    
    // initialize footerView
    func initFooterView(){
        footerView = UIView.init(frame: CGRect(x:0.0, y:0.0, width:self.view.frame.size.width, height:40.0))
        let actInd = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        actInd.tag = 10
        actInd.frame = CGRect(x:(self.view.frame.size.width/2)-15, y:5.0, width:30.0, height:30.0)
        actInd.hidesWhenStopped = true
        footerView.addSubview(actInd)
    }
}

extension APJobListBaseVC: UITableViewDelegate, UITableViewDataSource, ActionMethodsDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.jobList != nil && (self.jobList?.count)! > 0)
        {
            return (self.jobList?.count)!
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyJobCell", for: indexPath) as! MyJobCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
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
    
    // MARK:- Selector methods (cancel/complete job)
    func cancelJob(sender:UIButton) {
        let jobObj = self.jobList![sender.tag - 1] as! Job
        self.cancelJob(jobObj: jobObj, indexPath: NSIndexPath(row: sender.tag-1, section: 0))
    }
    
    func completeJob(sender:UIButton) {
        let jobObj = self.jobList![sender.tag - 1] as! Job
        self.completeJob(jobObj: jobObj, indexPath: NSIndexPath(row: sender.tag-1, section: 0))
    }
    
    func acceptJob(sender:UIButton) {
        let jobObj = self.jobList![sender.tag - 1] as! Job
        self.acceptJob(jobObj: jobObj, indexPath: NSIndexPath(row: sender.tag-1, section: 0))
    }
    
    // MARK:- ActionMethodsDelegate
    func cancelAction(_ jobID: Int) {
        self.jobList?.remove(at: self.indexPath!.row)
        self.tableView.reloadData()
    }
    
    func completeAction(_ jobID: Int) {
        self.jobList?.remove(at: self.indexPath!.row)
        self.tableView.reloadData()
    }
    
    func acceptAction(_ jobID: Int) {
        self.jobList?.remove(at: self.indexPath!.row)
        self.tableView.reloadData()
    }
}


extension APJobListBaseVC{
    
    func handleJobResponse(page : Int, jobList: [AnyObject]?, success: Bool, error: NSError?, calledPage: Int) {
        // hide loader
        
        DispatchQueue.main.async {
            
            self.navigationController?.view.hideLoader()
            
            if (self.isRefreshAnimating){
                
                self.isRefreshAnimating = false
                
                if((self.footerView.viewWithTag(10) as! UIActivityIndicatorView).isAnimating){
                    
                    (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                    self.tableView.tableFooterView = UIView()
                    
                }else{
                    
                    self.refreshControl.endRefreshing()
                    
                }
                
            }else{
                
                self.navigationController!.view.hideLoader()
            }
            
            
            if let _ = error {
                if (error!.localizedDescription == "No content")
                {
                    if(calledPage == 1){
                        
                        if(self.jobList != nil && (self.jobList?.count)! > 0)
                        {
                            self.jobList?.removeAll()
                        }
                    }
                    
                    if(self.canScrolldown){
                        self.hasContent = false
                        self.canScrolldown = false
                    }
                    self.tableView.reloadData()
                }
                else{

                    if(self.canScrolldown){
                        self.hasContent = false
                        self.canScrolldown = false
                    }
                    
                    if(self.jobList != nil && (self.jobList?.count)! > 0)
                    {
                        // do nothing
                    }else{
                        
                        self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                    }
                }
            } else {
                
                
                if (jobList?.count == 0)
                {
                    if(calledPage == 1){
                        
                        if(self.jobList != nil && (self.jobList?.count)! > 0)
                        {
                            self.jobList?.removeAll()
                        }
                    }
                    
                    if(self.canScrolldown){
                        self.hasContent = false
                        self.canScrolldown = false
                    }
                    if(self.jobList != nil && (self.jobList?.count)! > 0)
                    {
                        //do nothing
                    }
                    self.tableView.reloadData()
                    return
                }
                
                self.page = page
                
                if page > 1 {
                    
                    self.jobList?.append(contentsOf: jobList!)
                }
                else if page == 1
                {
                    
                    self.jobList = jobList
                    
                    if(CategoryManager.sharedManager().categories == nil){
                    
                        self.getCategoryList()
                    
                    }else{
                    
                        self.pastUrls = CategoryManager.sharedManager().tags!
                    }
                }
                
                self.tableView.reloadData()
                
            }
        }
        
       
    }
    
    
    func handleJobAndPendingFeedbackResponseResponse(page : Int, jobList: [AnyObject]?, pendingFeedbackList: [AnyObject]?, success: Bool, error: NSError?, calledPage: Int) {
        // hide loader
        
        DispatchQueue.main.async {
            
            self.navigationController?.view.hideLoader()
            
            if (self.isRefreshAnimating){
                
                self.isRefreshAnimating = false
                
                if((self.footerView.viewWithTag(10) as! UIActivityIndicatorView).isAnimating){
                    
                    (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                    self.tableView.tableFooterView = UIView()
                    
                }else{
                    
                    self.refreshControl.endRefreshing()
                    
                }
                
            }else{
                
                self.navigationController!.view.hideLoader()
            }
            
            
            if let _ = error {
                if (error!.localizedDescription == "No content")
                {
                    if(calledPage == 1){
                        
                        if(self.jobList != nil && (self.jobList?.count)! > 0)
                        {
                            self.jobList?.removeAll()
                        }
                    }
                    
                    if(self.canScrolldown){
                        self.hasContent = false
                        self.canScrolldown = false
                    }
                    self.tableView.reloadData()
                }
                else{
                    
                    if(self.canScrolldown){
                        self.hasContent = false
                        self.canScrolldown = false
                    }
                    
                    if(self.jobList != nil && (self.jobList?.count)! > 0)
                    {
                        // do nothing
                    }else{
                        
                        self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                    }
                }
            } else {
                
                
                if (jobList?.count == 0)
                {
                    if(calledPage == 1){
                        
                        if(self.jobList != nil && (self.jobList?.count)! > 0)
                        {
                            self.jobList?.removeAll()
                        }
                    }
                    
                    if(self.canScrolldown){
                        self.hasContent = false
                        self.canScrolldown = false
                    }
                    self.tableView.reloadData()
                    return
                }
                
                self.page = page
                
                if page > 1 {
                    
                    self.jobList?.append(contentsOf: jobList!)
                }
                else if page == 1
                {
                    
                    self.jobList = jobList
                    
                    if(CategoryManager.sharedManager().categories == nil){
                        
                        self.getCategoryList()
                        
                    }else{
                        
                        self.pastUrls = CategoryManager.sharedManager().tags!
                    }
                }
                
                self.tableView.reloadData()
                
                self.pendingFeedbackList = pendingFeedbackList
                if self.pendingFeedbackList != nil && (self.pendingFeedbackList?.count)! > 0 {
                    
                    if(self.feedBackView == nil){
                        self.feedBackView = FeedBackView()
                    }
                    self.feedBackView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: (UIScreen.main.bounds.size.height))
                    self.feedBackView?.delegate = self
                    self.view.addSubview(self.feedBackView!)
                    APPDELEGATE.isFeedbackProcessing = true
                    self.setTabBarVisible(visible: false, animated: true)
                    let feedback = self.pendingFeedbackList?.first as! Feedback
                    self.feedBackView?.nameLabel.text = feedback.name
                    //                    self.feedBackView?.serviceTypeLabel.text = feedback.serviceName
                    if let thumbImageUrl = feedback.profileImage {
                        self.feedBackView?.profileImage.sd_setImage(with: URL(string: thumbImageUrl), placeholderImage: UIImage(named: "ProfilePicBlank"))
                    }
                    
                }
                
            }
        }
        
        
    }
    
    //MARK:- fetch jobs
    /* myjobsforpage method is called to get list of all current and opened jobs */
    
    func jobForpage(page:Int, type : String){
        
        // show loader
        let calledPage = page
        
        if calledPage == 1 {
            
            hasContent = true
            canScrolldown = false
        }
        
        
        if (!self.isRefreshAnimating){
            
            self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
            
        }
        
        if(type == "JobList")
        {            
            if searchServiceTypeId != -1 {
                
                Job.myjobsforpageSearch(page,tagId: "\(searchServiceTypeId)",completion: { (page, jobList ,success, error) -> (Void) in
                    self.handleJobResponse(page: page, jobList: jobList, success: success, error: error, calledPage: calledPage)
                })
            }else{
            
                let user = UserManager.sharedManager().activeUser
                
                if user?.roleType == 3 {
                    
                    Job.myjobsforPageAndPendingList(page,completion: { (page, jobList , pendingFeedbackList,success, error) -> (Void) in
                        self.handleJobAndPendingFeedbackResponseResponse(page: page, jobList: jobList, pendingFeedbackList: pendingFeedbackList, success: success, error: error, calledPage: calledPage)
                    })
                    
                }else{
                
                    Job.myjobsforpage(page,completion: { (page, jobList ,success, error) -> (Void) in
                        self.handleJobResponse(page: page, jobList: jobList, success: success, error: error, calledPage: calledPage)
                    })
                }
                
                
            }
            
            
        }
        else if(type == "HistoryList")
        {
            Job.getHistoryJobsList(page, completion: { (page, jobHistoryList, success, error) -> (Void) in
                self.handleJobResponse(page: page, jobList: jobHistoryList, success: success, error: error, calledPage: calledPage)
            })
        }
        else if(type == "OpenList")
        {
//            Job.getOpenJobsList(page,completion: { (page, openJobsList ,success, error) -> (Void) in
//                self.handleJobResponse(page: page, jobList: openJobsList, success: success, error: error, calledPage: calledPage)
//            })
        }
        
    }
    
    
    
    
    //MARK:- action api call for jobs
    
    func cancelJob(jobObj:Job , indexPath : NSIndexPath) {
        //show loader
        self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        
        jobObj.cancelJob(Int(jobObj.id!)) { (success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async {
                self.navigationController!.view.hideLoader()
                if let _ = error {
                    self.showAlertViewWithMessage((error?.localizedDescription)!, message: "")
                } else {
                    
                    self.jobList?.remove(at: indexPath.row)
                    self.tableView.reloadData()
                    
                }
            }
            
        }
    }
    
    
    func completeJob(jobObj:Job , indexPath : NSIndexPath) {
        //show loader
        self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        
        jobObj.completeJob(Int(jobObj.id!)) { (success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async {
            self.navigationController!.view.hideLoader()
            if let _ = error {
                self.showAlertViewWithMessage((error?.localizedDescription)!, message: "")
            } else {
                
                self.jobList?.remove(at: indexPath.row)
                self.tableView.reloadData()
                
            }
            }
            
        }
    }
    
    func acceptJob(jobObj:Job , indexPath : NSIndexPath) {
        //show loader
        self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        jobObj.acceptJob(Int(jobObj.id!)) { (success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async {
            self.navigationController!.view.hideLoader()
            if let _ = error {
                self.showAlertViewWithMessage((error?.localizedDescription)!, message: "")
            } else {
                
                self.jobList?.remove(at: indexPath.row)
                self.tableView.reloadData()
                
            }
            }
        }
    }
    func getCategoryList(){
        
        // show loader

        self.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        E3malCategory.getCategories({ (userCategories, success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async {
                self.view.hideLoader()
                
                if let _ = error {
                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                } else {
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                     self.pastUrls = CategoryManager.sharedManager().tags!
                        
                    })
                }
                
            }
        })
    }
    
    @IBAction func starButtonPressed (_ sender:AnyObject) {
        let starButton = sender as! UIButton
        switch starButton.tag{
        case 10:
            setStarImage(starButton.tag)
            starRating = "1"
            break
        case 11:
            setStarImage(starButton.tag)
            starRating = "2"
            break
        case 12:
            setStarImage(starButton.tag)
            starRating = "3"
            break
        case 13:
            setStarImage(starButton.tag)
            starRating = "4"
            break
        case 14:
            setStarImage(starButton.tag)
            starRating = "5"
            break
        default:break
        }
    }
    //MARK:Instance Methods
    func setStarImage(_ selectedStarTag:NSInteger){
        
        for view in self.ratingsView.subviews {
            if let btn = view as? UIButton {
                if (btn.tag <= selectedStarTag) {
                    btn.setImage(UIImage(named: "Ic_starfilled"), for: UIControlState())
                }
                else{
                    btn.setImage(UIImage(named: "Ic_starblank"), for: UIControlState())
                }
            }
        }
    }
}

extension APJobListBaseVC:FeedbackDelegate{
    
    func removeFeedbackView() {
        feedBackView?.removeFromSuperview()
    }
    
    func sendFeedback(_ rating: String, comment: String) {
        
        if self.pendingFeedbackList != nil && (self.pendingFeedbackList?.count)! > 0 {
            let feedback = self.pendingFeedbackList?.first as! Feedback
            self.sendFeedback("\((feedback.id)!)", ratingPoint: rating, comment: comment)
        }
        
    }
    
    /* sendFeedback this method is called to send Feedback */
    
    
    func sendFeedback(_ feedbackId: String, ratingPoint : String , comment : String){
        
        // show loader
        self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        
        
        Feedback.sendFeedback(feedbackId, ratingPoint: ratingPoint, comment: comment) { (success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async {
                self.navigationController!.view.hideLoader()
                
                
                if let _ = error {
                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                } else {
                    
                    
                    
                    
                    self.pendingFeedbackList?.removeFirst()
                    self.feedBackView?.removeFromSuperview()
                    self.setTabBarVisible(visible: true, animated: true)
                    
                    if self.pendingFeedbackList != nil && (self.pendingFeedbackList?.count)! == 0 {
                        
                        self.pendingFeedbackList = nil
                        let alertController = UIAlertController(title: UserManager.sharedManager().activeUser.successMessage, message: "", preferredStyle: UIAlertControllerStyle.alert)
                        let closeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
                            // do nothing
                            APPDELEGATE.isFeedbackProcessing = false
                        }
                        alertController.addAction(closeAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    } else if self.pendingFeedbackList != nil && (self.pendingFeedbackList?.count)! > 0 {
                        
                        let alertController = UIAlertController(title: UserManager.sharedManager().activeUser.successMessage, message: "", preferredStyle: UIAlertControllerStyle.alert)
                        let closeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
                            
                            //                        self.feedBackView?.commentTextField.text = ""
                            self.feedBackView?.setStarImage(14)
                            self.feedBackView?.starRating = "5"
                            self.view.addSubview(self.feedBackView!)
                            self.setTabBarVisible(visible: false, animated: true)
                            let feedback = self.pendingFeedbackList?.first as! Feedback
                            self.feedBackView?.nameLabel.text = feedback.name
                            //                        self.feedBackView?.serviceTypeLabel.text = feedback.serviceName
                            if let thumbImageUrl = feedback.profileImage {
                                self.feedBackView?.profileImage.sd_setImage(with: URL(string: thumbImageUrl), placeholderImage: UIImage(named: "ProfilePicBlank"))
                            }
                            
                        }
                        alertController.addAction(closeAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }  
                }
            }
        }
    }
    
}
