//
//  JobListHireVC.swift
//  E3malApp
//
//  Created by Rishav Tomar on 25/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class JobListHireVC:APJobListBaseVC {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alertCountLabel: UILabel!
    let currencyText = Localization("SAR")
    @IBOutlet weak var tableViewbg: UIView!
    @IBOutlet weak var postJobBtn: UIButton!
    
    var flagShowNotification = false
    
    //MARK: - life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.jobForpage(page: page, type: "JobList")
        
        self.titleLabel.text = Localization("MY PROJECTS")
        self.titleLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
        self.titleLabel.addTextSpacing(spacing: 1.4)
        
        if Localisator.sharedInstance.currentLanguage == "ar" {
            self.titleLabel.font = UIFont(name: "GeezaPro-Bold", size: (self.titleLabel.font?.pointSize)!)
        }
        
        alertCountLabel.layer.cornerRadius = 6
        alertCountLabel.clipsToBounds = true
        alertCountLabel.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
        
        tableViewbg.layer.shadowOpacity = 0.1
        tableViewbg.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        tableViewbg.layer.shadowColor = UIColor.darkGray.cgColor
        tableViewbg.layer.shadowRadius = 0.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(JobListHireVC.updateNotificationCount(_:)), name: Constants.NOTIFICATION_UNREAD_COUNT, object: nil)
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
        if let count = UserManager.sharedManager().activeUser.unReadCount {
            if count.intValue > 99 {
                alertCountLabel.text = "99+"
            }else{
                alertCountLabel.text = "\(count)"
            }
            alertCountLabel.isHidden = count.intValue > 0 ? false : true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
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
    
    @IBAction func postJobBtnPressed(_ sender: UIButton) {
        let postJob  = UIStoryboard(name: "PostJob", bundle: nil)
        let postJobVC = postJob.instantiateViewController(withIdentifier: "PostJobVC")
        
        self.navigationController?.pushViewController(postJobVC, animated: false)
    }
    
    @IBAction func openNotificationVC(_ sender: Any) {
        
        (sender as! UIButton).isExclusiveTouch =  true
        if flagShowNotification {
            return
        }
        flagShowNotification = true
        self.perform(#selector(JobListHireVC.enableNotificationButton), with: nil, afterDelay: 3)
        self.tabBarController?.navigationController?.pushViewController(UIStoryboard.notificationsVC()!, animated: true)
        
    }
    
    func enableNotificationButton() {
        flagShowNotification = false
    }
    
}

extension JobListHireVC {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "HireListCell") as! HireListCell
        
        cell.contentView.layer.shadowOpacity = 0.1
        cell.contentView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.contentView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.contentView.layer.shadowRadius = 20.0
        
        let myJob = self.jobList![(indexPath as NSIndexPath).row] as! Job
        cell.jobNameLabel.text = myJob.title
        
        //cell.awardedToLabel.text = myJob.posterName
        cell.amountLabel.text = "\((myJob.priceMax)!) \(currencyText)"
        cell.dateLabel.text = getDateAndTime(dateInString: myJob.biddingEndDate!)
        if(myJob.jobStatus == 1){
            cell.jobTypeLabel.text = Localization("NEW")
            cell.awardedToLabel.text = Localization("Open for bid")
            cell.countLabel.text = "(" + "\(myJob.bidderCount!)" + " members applied" + ")"
        }
        if (myJob.profileImage != nil) {
            cell.profileImage.sd_setImage(with: NSURL(string: myJob.profileImage! ) as URL!, placeholderImage: UIImage(named: "newPlaceholder"))
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 137
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let jobObj = self.jobList![(indexPath as NSIndexPath).row] as! Job
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "HireDetailVC") as! APHireJobDetailsVC
        if(jobObj.id != nil){
            detailVC.jobRequestedId = jobObj.id as Int?
        }
        self.navigationController?.pushViewController(detailVC, animated: true)
        
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
