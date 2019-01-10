//
//  APOpenJobsListVC.swift
//  OnDemandApp
//
//  Created by Pawan Dhawan on 22/08/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

let FOOTERVIEW_TAG = 10

class APOpenJobsListVC: APJobListBaseVC {
    
    //MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = NSLocalizedString("Open Jobs", comment: "")
        self.jobForpage(page: page, type: "OpenList")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // refresh control methods
    override func refreshView(){
        // Reload all pages from start
        isRefreshAnimating = true
        self.page = 1
        self.jobForpage(page: page, type: "OpenList")
    }
}

extension APOpenJobsListVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let jobObj = self.jobList![(indexPath as NSIndexPath).row] as! Job
        let storyBoard = UIStoryboard.init(name: "SeekerHome", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "APJobsDetailVC") as! APJobsDetailVC
        detailVC.jobObj = jobObj
        detailVC.delegate = self
        self.indexPath = indexPath as NSIndexPath?
        
        detailVC.jobType = JobDetailType.openJobs.rawValue
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyJobCell", for: indexPath as IndexPath) as! MyJobCell
        
        let myJob = self.jobList![(indexPath as NSIndexPath).row] as! Job
        
        cell.seekerNameLabel.text = self.jobStatusString(myJob)
        cell.nameLabel.text = self.nameString(myJob)
        
        if(UserManager.sharedManager().userType == .userTypeSeeker)
        {
            // do nothing
        }
        else
        {
            // open 1 , Under Process 2
            if (Int(myJob.jobStatus!) == JobStatus.pending.rawValue)
            {
                cell.dateTimeLabel.text = myJob.serviceDateTime!.getLocalDate()
                
            }else {
                cell.nameHeightConstant.constant = 20
                cell.dateTimeLabel.text = myJob.serviceDateTime!.getLocalDate()
            }
        }
        cell.dateTimeLabel.text = myJob.serviceDateTime?.getLocalDate()
        cell.jobIdLabel.text = NSLocalizedString("Job Id: ", comment: "") + String(describing: myJob.id!)
        cell.serviceTypeLabel.text = myJob.serviceName!
        cell.addressLabel.text = ""
        cell.paymentLabel.text = ""
        
        cell.cancelButton.setTitle(NSLocalizedString("Accept", comment: ""), for: .normal)
        cell.cancelButton.tag = indexPath.row + 1
        cell.cancelButton.addTarget(self, action: #selector(self.acceptJob(sender:)), for: .touchUpInside)

        return cell
    }
    
    // MARK: - UIScrollView Methods
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if(self.isRefreshAnimating == false && hasContent){
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height && self.jobList != nil && (self.jobList?.count)! >= 10 ){
                self.tableView.tableFooterView = footerView
                (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                isRefreshAnimating = true
                self.page = self.page + 1
                canScrolldown = true
                self.jobForpage(page: page, type: "OpenList")
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK:- For APOpenJobsListVC
    func jobStatusString(_ job : Job) -> String! {
        if(UserManager.sharedManager().userType == .userTypeSeeker)
        {
            if job.providerName != nil && job.providerName != ""{
                return job.providerName!
            }
            else if (Int(job.jobStatus!) == JobStatus.pending.rawValue)
            {
                return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Pending", comment: "")
            }
            else if (Int(job.jobStatus!) == JobStatus.canceled.rawValue)
            {
                return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Cancelled", comment: "")
            }
            else {
                return ""
            }
        }
        else
        {
            // open 1 , Under Process 2
            if (Int(job.jobStatus!) == JobStatus.pending.rawValue)
            {
                return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Pending", comment: "")
            }else {
                return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Unknown", comment: "")
            }
        }
    }
    
    func nameString(_ job: Job) -> String! {
        
        return NSLocalizedString("Seeker Name : ", comment: "") + job.seekerName!
    }
}

