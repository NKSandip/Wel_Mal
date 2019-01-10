//
//  APJobsHistoryListVC.swift
//  OnDemandApp
//
//  Created by Pawan Dhawan on 22/08/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class APJobsHistoryListVC: APJobListBaseVC {
    
    //MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Jobs History", comment: "")
//        self.tableView.register(MyJobCell.self, forCellReuseIdentifier: "MyJobCell")
        self.jobForpage(page: page, type: "HistoryList")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- IBActions
//    @IBAction func menuButtonAction(sender: AnyObject) {
//        
//        if let container = APSideMenuManager.sharedManager().container {
//            container.toggle(.left, animated: true) { (val) -> Void in
//                
//            }
//        }
//    }
    
    // refresh control methods
    override func refreshView(){
        isRefreshAnimating = true
        self.page = 1
        self.jobForpage(page: page, type: "HistoryList")
    }
}

extension APJobsHistoryListVC {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyJobCell", for: indexPath) as! MyJobCell
        cell.nameHeightConstant.constant = 20

        let myJob = self.jobList![(indexPath as NSIndexPath).row] as! Job
        
        cell.seekerNameLabel.text = self.jobStatusString(myJob)
        cell.nameLabel.text = self.nameString(myJob)
        if(UserManager.sharedManager().userType == .userTypeSeeker)
        {
            
            if (Int(myJob.jobStatus!) == JobStatus.canceled.rawValue)
            {
                cell.nameHeightConstant.constant = 0
                cell.dateTimeLabel.text = myJob.canceledAt!.getLocalDate()
                
            } else if (Int(myJob.jobStatus!) == JobStatus.canceledByProvider.rawValue)
            {
                cell.dateTimeLabel.text = myJob.canceledAt!.getLocalDate()
                
            }else if (Int(myJob.jobStatus!) == JobStatus.completed.rawValue)
            {
                cell.dateTimeLabel.text = myJob.serviceEndTime!.getLocalDate()
                
            }else if (Int(myJob.jobStatus!) == JobStatus.pending.rawValue)
            {
                if(myJob.canceledAt == nil || myJob.canceledAt == "" || myJob.canceledAt == "<null>"){
                    cell.dateTimeLabel.text = myJob.serviceDateTime!.getLocalDate()
                }
                cell.nameHeightConstant.constant = 0
            }else {
                cell.nameHeightConstant.constant = 0
                cell.dateTimeLabel.text = myJob.serviceDateTime!.getLocalDate()
            }
        }
        else
        {
            
            if (Int(myJob.jobStatus!) == JobStatus.pending.rawValue)
            {
                if( myJob.canceledAt == nil || myJob.canceledAt == "" || myJob.canceledAt == "<null>"){
                    cell.dateTimeLabel.text = myJob.serviceDateTime!.getLocalDate()
                    cell.nameHeightConstant.constant = 0
                }else{
                    cell.dateTimeLabel.text = myJob.canceledAt!.getLocalDate()
                }
                
            } else if (Int(myJob.jobStatus!) == JobStatus.canceled.rawValue || Int(myJob.jobStatus!) == JobStatus.canceledByProvider.rawValue)
            {
                cell.dateTimeLabel.text = myJob.canceledAt!.getLocalDate()
                
            } else {
                cell.dateTimeLabel.text = myJob.serviceEndTime!.getLocalDate()
            }
        }
        
        
        cell.jobIdLabel.text = NSLocalizedString("Job Id: ", comment: "") + String(describing: myJob.id!)
        cell.serviceTypeLabel.text = myJob.serviceName!
        cell.addressLabel.text = ""
        cell.paymentLabel.text = ""
        cell.cancelButton.isHidden = true
        return cell
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){

        tableView.deselectRow(at: indexPath, animated: true)
        
        let jobObj = self.jobList![(indexPath as NSIndexPath).row] as! Job

        let storyBoard = UIStoryboard.init(name: "SeekerHome", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "APJobsDetailVC") as! APJobsDetailVC
        detailVC.jobObj = jobObj
        detailVC.jobType = JobDetailType.historyJobs.rawValue
        
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
                self.jobForpage(page: page, type: "HistoryList")
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK:- For APJobsHistoryListVC
    func jobStatusString(_ myJob : Job) -> String! {
        if(UserManager.sharedManager().userType == .userTypeSeeker)
        {
            if (Int(myJob.jobStatus!) == JobStatus.canceled.rawValue)
            {
                return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Cancelled By Me", comment: "")
                
            } else if (Int(myJob.jobStatus!) == JobStatus.canceledByProvider.rawValue)
            {
                return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Cancelled By Provider", comment: "")
                
            }else if (Int(myJob.jobStatus!) == JobStatus.completed.rawValue)
            {
                return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Completed", comment: "")
                
            }else if (Int(myJob.jobStatus!) == JobStatus.pending.rawValue)
            {
                if(myJob.canceledAt == nil || myJob.canceledAt == "" || myJob.canceledAt == "<null>"){
                    
                    return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Expired", comment: "")
                }
                return ""
            }else {
                return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Unknown", comment: "")
            }
        }
        else
        {
            if (Int(myJob.jobStatus!) == JobStatus.pending.rawValue)
            {
                if( myJob.canceledAt == nil || myJob.canceledAt == "" || myJob.canceledAt == "<null>"){
                    return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Expired", comment: "")
                }else{
                    return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Cancelled By Me", comment: "")
                }
            }
            else if (Int(myJob.jobStatus!) == JobStatus.canceled.rawValue)
            {
                return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Cancelled By Seeker", comment: "")
            }
            else if (Int(myJob.jobStatus!) == JobStatus.canceledByProvider.rawValue)
            {
                return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Cancelled By Me", comment: "")
            }
            else {
                return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Completed", comment: "")
            }
        }
    }
    
    func nameString(_ myJob: Job) -> String! {
        
        if(UserManager.sharedManager().userType == .userTypeSeeker)
        {
            if (Int(myJob.jobStatus!) == JobStatus.canceledByProvider.rawValue || Int(myJob.jobStatus!) == JobStatus.completed.rawValue)
            {
                return NSLocalizedString("Provider Name : ", comment: "") + myJob.providerName!
                
            } else {
                return ""
            }
        }
        else
        {
            if (Int(myJob.jobStatus!) == JobStatus.pending.rawValue)
            {
                if( myJob.canceledAt == nil || myJob.canceledAt == "" || myJob.canceledAt == "<null>"){
                    return ""
                }else{
                    return NSLocalizedString("Seeker Name : ", comment: "") + myJob.seekerName!
                }
            } else {
                return NSLocalizedString("Seeker Name : ", comment: "") + myJob.seekerName!
            }
        }
    }
    
}
