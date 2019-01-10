//
//  NotificationListVC.swift
//  OnDemandApp
//
//  Created by Pawan Dhawan on 29/09/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class APNotificationsVC: UIViewController, ActionMethodsDelegate {
    
    // MARK: - IBOUTLET
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alertCountLabel: UILabel!
    @IBOutlet weak var HireAlertView: UIView!
    @IBOutlet weak var hireAlertLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var noNotificationsFoundLabel: UILabel!
    //MARK: - Variables
    var refreshControl : UIRefreshControl!
    var isRefreshAnimating = false
    var hasContent = true
    var canScrolldown = false
    var footerView  = UIView()
    var page:Int = 1 // used for pagination
    var indexPath : IndexPath?
    var notificationList : [AnyObject]?
    var selectedNotificationId : Int?
    var selectedIndex : IndexPath?
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateCounter()
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorColor = UIColor.black
        self.initializeRefreshControl()
        self.initFooterView()
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 110
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        titleLabel.addLocalizationBold()
        titleLabel.addTextSpacing(spacing: 1)
        getNotificationsList(page)
        
        NotificationCenter.default.addObserver(self, selector: #selector(APNotificationsVC.updateNotificationCount(_:)), name: Constants.NOTIFICATION_UNREAD_COUNT, object: nil)
        
        let user = UserManager.sharedManager().activeUser
        
        if user?.roleType == 2 {
            editButton.isHidden  = true
            HireAlertView.isHidden  = true
            alertButton.isHidden  = true
            alertCountLabel.isHidden  = true
        }
        
        self.view.bringSubview(toFront: noNotificationsFoundLabel)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func postJobButtonAction(_ sender: Any) {
        let postJob  = UIStoryboard(name: "PostJob", bundle: nil)
        let postJobVC = postJob.instantiateViewController(withIdentifier: "PostJobVC")
        self.navigationController?.pushViewController(postJobVC, animated: false)
    }
    
    func updateCounter(){
        let user = UserManager.sharedManager().activeUser
        if user?.unReadCount != nil {
            user?.unReadCount = NSNumber(value: 0)
            NotificationCenter.default.post(name: Constants.NOTIFICATION_UNREAD_COUNT, object: self, userInfo: ["unreadCount":"0"])
        }
    }
    
    
    func updateNotificationCount(_ notification: NSNotification) {
        if let userInfo = notification.userInfo as? [String: AnyObject] {
            DispatchQueue.main.async{
                self.alertCountLabel.text = "\((userInfo["unreadCount"])!)"
                self.hireAlertLabel.text = "\((userInfo["unreadCount"])!)"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserManager.sharedManager().isUserLoggedIn() {
            if let count = UserManager.sharedManager().activeUser.unReadCount {
                if count.intValue > 99 {
                    alertCountLabel.text = "99+"
                    hireAlertLabel.text = "99+"
                }else{
                    alertCountLabel.text = "\(count)"
                    hireAlertLabel.text = "\(count)"
                    alertCountLabel.isHidden = count.intValue > 0 ? false : true
                    hireAlertLabel.isHidden = count.intValue > 0 ? false : true
                }
            }
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: AnyObject) {
        self.setTabBarVisible(visible: true, animated: true)
        _ = self.navigationController?.popToRootViewController(animated: true)
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
        updateCounter()
        isRefreshAnimating = true
        getNotificationsList(1)
        
    }
    
    // initialize footerView
    func initFooterView(){
        footerView = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 40.0))
        let actInd = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        actInd.tag = 10
        actInd.frame = CGRect(x: (self.view.frame.size.width/2)-15, y: 5.0, width: 30.0, height: 30.0)
        actInd.hidesWhenStopped = true
        footerView.addSubview(actInd)
        
    }
}
// MARK: - UITableViewDelegate And UITableViewDataSource
extension APNotificationsVC:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.notificationList?.count > 0)
        {
            noNotificationsFoundLabel.isHidden = true
            return (self.notificationList?.count)!
        }
        else
        {
            noNotificationsFoundLabel.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "E3malNotificationCell", for: indexPath) as! E3malNotificationCell
        cell.selectionStyle = .none
        
        let myJob = self.notificationList![indexPath.row] as! Notification
        
        let newDate = myJob.createdAt?.getCurrentDate()
        
        if(Localisator.sharedInstance.currentLanguage == "en"){
            
            let normalText = " \(myJob.message!)"
            let boldText  = "\(myJob.senderName!)"
            let attributedString = NSMutableAttributedString(string:normalText)
            let attrs = [NSFontAttributeName : UIFont(name: "FSJoey-Bold", size: 14.0)]
            let boldString = NSMutableAttributedString(string:boldText, attributes:attrs)
            boldString.append(attributedString)
            cell.messageLabelNew.attributedText = boldString
        }else{
            
            let normalText = " \(myJob.message!)"
            let boldText  = "\(myJob.senderName!)"
            let attributedString = NSMutableAttributedString(string:normalText)
            let attrs = [NSFontAttributeName : UIFont(name: "GeezaPro-Bold", size: 14.0)]
            let boldString = NSMutableAttributedString(string:boldText, attributes:attrs)
            boldString.append(attributedString)
            cell.messageLabelNew.attributedText = boldString
            
        }
        
        cell.time.text = timeAgoSinceDate(newDate!, currentDate: Date(), numericDates: true)
        cell.name.text = myJob.senderName!
        cell.message.text = myJob.message!
        
        if myJob.readAt == "" {
            cell.bg_cell.image = UIImage(named: "notification-cell-bg-selected")
        }else{
            cell.bg_cell.image = UIImage(named: "notification-cell-bg")
        }
        
        if (myJob.senderProfileImage != nil) {
            cell.profileImage.sd_setImage(with: NSURL(string: myJob.senderProfileImage! ) as URL!, placeholderImage: UIImage(named: "placeholder_circle"))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let myJob = self.notificationList![indexPath.row] as! Notification
        var height:CGFloat = 0.0
        let text = "\(myJob.senderName!) \(myJob.message!)"
        if(Localisator.sharedInstance.currentLanguage == "en"){
            height = requiredRowHeight(text: text, width: tableView.frame.size.width, fontName: "FS Joey", fontSize: 14.0)
        }else{
            height = requiredRowHeight(text: text, width: tableView.frame.size.width, fontName: "Geeza Pro", fontSize: 14.0)
        }
        
        if height < 16 {
            return 110
        }
        let newH = (110 + height)
        return (newH)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let myJob = self.notificationList![indexPath.row] as! Notification
        selectedNotificationId = myJob.notificationId?.intValue
        selectedIndex = indexPath
        
        if myJob.type == 6 {
            
            self.getChatDetails("\((myJob.serviceRequestChatId)!)")
            
        }else{
            self.getJobDetails("\((myJob.serviceRequestId)!)")
        }
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
    
    
    // MARK: - UIScrollView Methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if(self.isRefreshAnimating == false && hasContent){
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height && self.notificationList != nil && (self.notificationList?.count)! >= 10 ){
                self.tableView.tableFooterView = footerView
                (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                isRefreshAnimating = true
                self.page = self.page + 1
                canScrolldown = true
                self.getNotificationsList(page)
                self.tableView.reloadData()
            }
        }
    }
    
    func timeAgoStringFromDate(date: Date) -> NSString? {
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        
        let units: Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfMonth,.month, .year]
        
        let components = Calendar.current.dateComponents(units, from: date as Date)
        
        if components.year > 0 {
            formatter.allowedUnits = .year
        } else if components.month > 0 {
            formatter.allowedUnits = .month
        } else if components.weekOfMonth > 0 {
            formatter.allowedUnits = .weekOfMonth
        } else if components.day > 0 {
            formatter.allowedUnits = .day
        } else if components.hour > 0 {
            formatter.allowedUnits = .hour
        } else if components.minute > 0 {
            formatter.allowedUnits = .minute
        } else {
            formatter.allowedUnits = .second
        }
        
        let formatString = NSLocalizedString("%@ ago", comment: "Used to say how much time has passed. e.g. '2 hours ago'")
        
        guard let timeString = formatter.string(from: components) else {
            return nil
        }
        return String(format: formatString, timeString) as NSString?
    }
    
    func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        
        var latest:Date?
        if earliest.equalToDate(now){
            latest = date
        }else{
            latest = now
        }
        
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest!, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 6) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
    
    
    func markAsReadAPI(notificationId:String, indexPath:IndexPath) {
        var param = [String:String]()
        param["notificationId"] = notificationId
        param = param.union(deviceInfo())
        //show loader
        
        Notification.markAsReadRequest(param: param,completion: { (success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async{
                
                if (success) {
                    let myJob = self.notificationList![indexPath.row] as! Notification
                    myJob.readAt = "read"
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                    let user = UserManager.sharedManager().activeUser
                    if user?.unReadCount != nil {
                        
                        let val = user?.unReadCount?.intValue
                        let value = NSNumber(value: (val! - 1) )
                        if value.intValue <= 0 {
                            user?.unReadCount = NSNumber(value: 0)
                        }else{
                            user?.unReadCount =  value
                        }
                        
                        if (user?.unReadCount?.intValue)! > 99 {
                            
                            NotificationCenter.default.post(name: Constants.NOTIFICATION_UNREAD_COUNT, object: self, userInfo: ["unreadCount":"99+"])
                            
                        }else{
                            
                            if (user?.unReadCount?.intValue)! <= 0{
                                
                                NotificationCenter.default.post(name: Constants.NOTIFICATION_UNREAD_COUNT, object: self, userInfo: ["unreadCount":"0"])
                                
                            }else{
                                
                                NotificationCenter.default.post(name: Constants.NOTIFICATION_UNREAD_COUNT, object: self, userInfo: ["unreadCount":"\((user?.unReadCount!)!)"])
                            }
                        }
                    }
                    
                } else {
                    self.view.makeToast((error?.description)!, duration: 3, position: .center)
                }
            }
        })
    }
}

extension Date {
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
}

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

