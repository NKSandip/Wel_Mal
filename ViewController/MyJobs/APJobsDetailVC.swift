//
//  APJobsDetailVC.swift
//  OnDemandApp
//
//  Created by Shwetabh Singh on 16/08/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

@objc protocol ActionMethodsDelegate
{
    @objc optional func cancelAction(_ jobID:Int)
    @objc optional func completeAction(_ jobID:Int)
    @objc optional func acceptAction(_ jobID:Int)
}

class APJobsDetailVC: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    
    @IBOutlet weak var cancelFullWidthButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
  
    
    var jobType = 0
    
    var jobObj : Job?
    var addStr = "" // address string
    
    var delegate : ActionMethodsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        detailTableView.separatorInset = UIEdgeInsets.zero
        detailTableView.separatorColor = UIColor.black
        detailTableView.tableFooterView = UIView()
        self.detailTableView.estimatedRowHeight = 90
        self.detailTableView.rowHeight = UITableViewAutomaticDimension
        self.title = NSLocalizedString("Job Details", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialization() {
        if(UserManager.sharedManager().userType == .userTypeSeeker)
        {
            if self.jobType == JobDetailType.myJobs.rawValue {
                self.cancelButton.isHidden = true
                self.completeButton.isHidden = true
                self.acceptButton.isHidden = true
            } else if self.jobType == JobDetailType.historyJobs.rawValue {
                self.cancelButton.isHidden = true
                self.completeButton.isHidden = true
                self.cancelFullWidthButton.isHidden = true
                self.acceptButton.isHidden = true
            }
        } else {
            if self.jobType == JobDetailType.myJobs.rawValue {
                self.cancelFullWidthButton.isHidden = true
                self.acceptButton.isHidden = true
            }
            else if self.jobType == JobDetailType.openJobs.rawValue {
                self.cancelButton.isHidden = true
                self.completeButton.isHidden = true
                self.cancelFullWidthButton.isHidden = true
            }
            else  if self.jobType == JobDetailType.historyJobs.rawValue {
                self.cancelButton.isHidden = true
                self.completeButton.isHidden = true
                self.cancelFullWidthButton.isHidden = true
                self.acceptButton.isHidden = true
                self.cancelButton.alpha = 0
                self.completeButton.alpha = 0
                self.cancelFullWidthButton.alpha = 0
                self.acceptButton.alpha = 0
            }
        }
    }
}


extension APJobsDetailVC : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if((indexPath as NSIndexPath).row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyJobCell", for: indexPath) as! MyJobCell
            cell.nameHeightConstant.constant = 20
            cell.seekerNameLabel.text = self.jobStatusString()
            cell.nameLabel.text = self.nameString()
            if(UserManager.sharedManager().userType == .userTypeSeeker)
            {
                if self.jobType == JobDetailType.historyJobs.rawValue {
                    
                    if (Int(jobObj!.jobStatus!) == JobStatus.canceled.rawValue)
                    {
                        cell.nameHeightConstant.constant = 0
                        cell.dateTimeLabel.text = jobObj!.canceledAt!.getLocalDate()
                        
                    } else if (Int(jobObj!.jobStatus!) == JobStatus.canceledByProvider.rawValue)
                    {
                        cell.dateTimeLabel.text = jobObj!.canceledAt!.getLocalDate()
                        
                    }else if (Int(jobObj!.jobStatus!) == JobStatus.completed.rawValue)
                    {
                        cell.dateTimeLabel.text = jobObj!.serviceEndTime!.getLocalDate()
                        
                    }else if (Int(jobObj!.jobStatus!) == JobStatus.pending.rawValue)
                    {
                        if( jobObj!.canceledAt == nil || jobObj!.canceledAt == "" || jobObj!.canceledAt == "<null>" ){
                            cell.dateTimeLabel.text = jobObj!.serviceDateTime!.getLocalDate()
                        }
                        cell.nameHeightConstant.constant = 0
                    }else {
                        cell.nameHeightConstant.constant = 0
                        cell.dateTimeLabel.text = jobObj!.serviceDateTime!.getLocalDate()
                    }
                    
                }else{
                    
                    // open 1 , Under Process 2
                    if (Int(jobObj!.jobStatus!) == JobStatus.pending.rawValue)
                    {
                        cell.dateTimeLabel.text = jobObj!.serviceDateTime!.getLocalDate()
                        cell.nameHeightConstant.constant = 0
                    }else {
                        cell.nameHeightConstant.constant = 20
                        cell.dateTimeLabel.text = jobObj!.serviceDateTime!.getLocalDate()
                    }
                }
            }
            else
            {
                
                if self.jobType == JobDetailType.historyJobs.rawValue {
                    
                    if (Int(jobObj!.jobStatus!) == JobStatus.pending.rawValue)
                    {
                        if( jobObj!.canceledAt == nil || jobObj!.canceledAt == "" || jobObj!.canceledAt == "<null>"){
                            cell.dateTimeLabel.text = jobObj!.serviceDateTime!.getLocalDate()
                            cell.nameHeightConstant.constant = 0
                        }else{
                            cell.dateTimeLabel.text = jobObj!.canceledAt!.getLocalDate()
                        }
                    }
                    else if (Int(jobObj!.jobStatus!) == JobStatus.canceled.rawValue || Int(jobObj!.jobStatus!) == JobStatus.canceledByProvider.rawValue)
                    {
                        cell.dateTimeLabel.text = jobObj!.canceledAt!.getLocalDate()
                        
                    } else {
                        cell.dateTimeLabel.text = jobObj!.serviceEndTime!.getLocalDate()
                    }
                }else{
                    // open 1 , Under Process 2
                    if (Int(jobObj!.jobStatus!) == JobStatus.pending.rawValue)
                    {
                        cell.dateTimeLabel.text = jobObj!.serviceDateTime!.getLocalDate()
                    }else {
                        cell.nameHeightConstant.constant = 20
                        cell.dateTimeLabel.text = jobObj!.serviceDateTime!.getLocalDate()
                    }
                }
            }
            
            cell.jobIdLabel.text = NSLocalizedString("Job Id: ", comment: "") + String(describing: jobObj!.id!)
            cell.serviceTypeLabel.text = jobObj!.serviceName!
            cell.addressLabel.text = self.addStr
            cell.paymentLabel.text = ""
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if((indexPath as NSIndexPath).row == 0)
        {
            return UITableViewAutomaticDimension
        }
        else
        {
            let height : CGFloat = UIScreen.main.bounds.height            
            return (height * 2/3)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- IBAction methods
    
    @IBAction func cancelJobAction(_ sender: AnyObject) {
        self.cancelJob()
    }
    
    @IBAction func completeJobAction(_ sender: AnyObject) {
        self.completeJob()
    }
    @IBAction func acceptAction(_ sender: AnyObject) {
        self.acceptJob()
    }
    
    
    //MARK:- For APJobsDetailVC
    
    func jobStatusString() -> String! {
        if(UserManager.sharedManager().userType == .userTypeSeeker)
        {
            if self.jobType == JobDetailType.historyJobs.rawValue {
                
                if (Int(jobObj!.jobStatus!) == JobStatus.canceled.rawValue)
                {
                    return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Cancelled By Me", comment: "")
                    
                } else if (Int(jobObj!.jobStatus!) == JobStatus.canceledByProvider.rawValue)
                {
                    return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Cancelled By Provider", comment: "")
                    
                }else if (Int(jobObj!.jobStatus!) == JobStatus.completed.rawValue)
                {
                    return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Completed", comment: "")
                    
                }else if (Int(jobObj!.jobStatus!) == JobStatus.pending.rawValue)
                {
                    if( jobObj!.canceledAt == nil || jobObj!.canceledAt == "" || jobObj!.canceledAt == "<null>" ){
                        return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Expired", comment: "")
                    }
                    return ""
                }else {
                    return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Unknown", comment: "")
                }
                
            }else{
                
                // open 1 , Under Process 2
                if (Int(jobObj!.jobStatus!) == JobStatus.pending.rawValue)
                {
                    return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Pending", comment: "")
                    
                }else {
                    return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Under Process", comment: "")
                }
            }
        }
        else
        {
            if self.jobType == JobDetailType.historyJobs.rawValue {
                
                if (Int(jobObj!.jobStatus!) == JobStatus.pending.rawValue)
                {
                    if( jobObj!.canceledAt == nil || jobObj!.canceledAt == "" || jobObj!.canceledAt == "<null>"){
                        return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Expired", comment: "")
                    }else{
                        return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Cancelled By Me", comment: "")
                    }
                }
                else if (Int(jobObj!.jobStatus!) == JobStatus.canceled.rawValue)
                {
                    return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Cancelled By Seeker", comment: "")
                }
                else if (Int(jobObj!.jobStatus!) == JobStatus.canceledByProvider.rawValue)
                {
                    return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Cancelled By Me", comment: "")
                }
                else {
                    return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Completed", comment: "")
                }
            }else{
                
                // open 1 , Under Process 2
                if (Int(jobObj!.jobStatus!) == JobStatus.pending.rawValue)
                {
                    return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Pending", comment: "")
                }else {
                    return NSLocalizedString("Status: ", comment: "") + NSLocalizedString("Under Process", comment: "")
                }
            }
        }
    }
    
    func nameString() -> String! {
        if(UserManager.sharedManager().userType == .userTypeSeeker)
        {
            if self.jobType == JobDetailType.historyJobs.rawValue {
                
                if (Int(jobObj!.jobStatus!) == JobStatus.canceledByProvider.rawValue || Int(jobObj!.jobStatus!) == JobStatus.completed.rawValue) {
                    return NSLocalizedString("Provider Name : ", comment: "") + jobObj!.providerName!
                    
                } else {
                    return ""
                }
            }else{
                // open 1 , Under Process 2
                if (Int(jobObj!.jobStatus!) == JobStatus.pending.rawValue)
                {
                    return ""
                }else {
                    return NSLocalizedString("Provider Name : ", comment: "") + jobObj!.providerName!
                }
            }
        }
        else
        {
            if self.jobType == JobDetailType.historyJobs.rawValue {
                
                if (Int(jobObj!.jobStatus!) == JobStatus.pending.rawValue)
                {
                    if( jobObj!.canceledAt == nil || jobObj!.canceledAt == "" || jobObj!.canceledAt == "<null>"){
                        return ""
                    }else{
                        return NSLocalizedString("Seeker Name : ", comment: "") + jobObj!.seekerName!
                    }
                }else {
                    return NSLocalizedString("Seeker Name : ", comment: "") + jobObj!.seekerName!
                }
            } else {
                
                return NSLocalizedString("Seeker Name : ", comment: "") + jobObj!.seekerName!
                
            }
        }
    }
}
