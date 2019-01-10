//
//  HireListCell.swift
//  E3malApp
//
//  Created by Rishav Tomar on 26/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class HireListCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var verifiedCheckImage: UIImageView!
    
    
    @IBOutlet weak var jobNameLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var awardedToLabel: UILabel!
    
    @IBOutlet weak var jobTypeView: UIView!

    @IBOutlet weak var jobTypeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var progressShadowImg: UIImageView!
    
    @IBOutlet weak var progressShadowImgTop: UIImageView!
    
    
    @IBOutlet weak var viewForShadow:
    UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
          self.jobNameLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
          self.awardedToLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
          self.countLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
          self.jobTypeLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
          self.jobTypeLabel.text = Localization("New")
        
        if Localisator.sharedInstance.currentLanguage == "ar" {
             self.jobNameLabel.font = UIFont(name: "Geeza Pro", size: (self.jobNameLabel.font?.pointSize)!)
            self.awardedToLabel.font = UIFont(name: "Geeza Pro", size: (self.awardedToLabel.font?.pointSize)!)
            self.jobTypeLabel.font = UIFont(name: "Geeza Pro", size: (self.jobTypeLabel.font?.pointSize)!)
            self.countLabel.font = UIFont(name: "Geeza Pro", size: (self.countLabel.font?.pointSize)!)
        }
        
          self.jobTypeView.layer.borderWidth = 0.5
          self.jobTypeView.layer.cornerRadius = 2
        
          self.progressView.progress = 0.0
        
        viewForShadow.layer.shadowOpacity = 0.1
        viewForShadow.layer.shadowOffset = CGSize(width: 0.0, height: 12.0)
        viewForShadow.layer.shadowColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class HireListCellOnGoing: HireListCell {
    
    @IBOutlet weak var progressShadowWidth: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.jobNameLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
        self.awardedToLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
        self.countLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
        self.jobTypeLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
        self.jobTypeLabel.text = Localization("New")
        
        if Localisator.sharedInstance.currentLanguage == "ar" {
            self.jobNameLabel.font = UIFont(name: "Geeza Pro", size: (self.jobNameLabel.font?.pointSize)!)
            self.awardedToLabel.font = UIFont(name: "Geeza Pro", size: (self.awardedToLabel.font?.pointSize)!)
            self.jobTypeLabel.font = UIFont(name: "Geeza Pro", size: (self.jobTypeLabel.font?.pointSize)!)
            self.countLabel.font = UIFont(name: "Geeza Pro", size: (self.countLabel.font?.pointSize)!)
        }
        
        self.jobTypeView.layer.borderWidth = 0.5
        self.jobTypeView.layer.cornerRadius = 2
        
        self.progressView.progress = 0.0
        
        viewForShadow.layer.shadowOpacity = 0.1
        viewForShadow.layer.shadowOffset = CGSize(width: 0.0, height: 12.0)
        viewForShadow.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class WorkProggressListCell: APRatingCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var jobName: UILabel!
    
    @IBOutlet weak var posterName: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var membersRatingCount: UILabel!
    
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var membersAppliedLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
//    @IBOutlet weak var viewForShadow:UIImageView!
    
    @IBOutlet weak var progressShadowImg: UIImageView!
    
    @IBOutlet weak var progressShadowImgTop: UIImageView!
    
    var localtextDirection : NSTextAlignment?
    
    @IBOutlet weak var profileVerifiedIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if Localisator.sharedInstance.currentLanguage == "ar" {
            self.jobName.font = UIFont(name: "Geeza Pro", size: (self.jobName.font?.pointSize)!)
            self.posterName.font = UIFont(name: "Geeza Pro", size: (self.posterName.font?.pointSize)!)
            self.location.font = UIFont(name: "Geeza Pro", size: (self.location.font?.pointSize)!)
            self.membersRatingCount.font = UIFont(name: "Geeza Pro", size: (self.membersRatingCount.font?.pointSize)!)
            
            self.amount.font = UIFont(name: "Geeza Pro", size: (self.amount.font?.pointSize)!)
            self.membersAppliedLabel.font = UIFont(name: "Geeza Pro", size: (self.membersAppliedLabel.font?.pointSize)!)
            self.dateLabel.font = UIFont(name: "Geeza Pro", size: (self.dateLabel.font?.pointSize)!)
        }
        
        self.progressView.progress = 0.0
        
//        viewForShadow.layer.shadowOpacity = 0.15
//        viewForShadow.layer.shadowOffset = CGSize(width: 0.0, height: 12.0)
//        viewForShadow.layer.shadowColor = UIColor.gray.cgColor
        //        viewForShadow.layer.shadowRadius = 5.0
        
        
        localtextDirection = textDirection()
        self.location.textAlignment = localtextDirection!
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    

    
}

class WorkProggressListCellOnGoing: WorkProggressListCell {
    

    @IBOutlet weak var progressShadowWidth: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if Localisator.sharedInstance.currentLanguage == "ar" {
            self.jobName.font = UIFont(name: "Geeza Pro", size: (self.jobName.font?.pointSize)!)
            self.posterName.font = UIFont(name: "Geeza Pro", size: (self.posterName.font?.pointSize)!)
            self.location.font = UIFont(name: "Geeza Pro", size: (self.location.font?.pointSize)!)
            self.membersRatingCount.font = UIFont(name: "Geeza Pro", size: (self.membersRatingCount.font?.pointSize)!)
            
            self.amount.font = UIFont(name: "Geeza Pro", size: (self.amount.font?.pointSize)!)
            self.membersAppliedLabel.font = UIFont(name: "Geeza Pro", size: (self.membersAppliedLabel.font?.pointSize)!)
            self.dateLabel.font = UIFont(name: "Geeza Pro", size: (self.dateLabel.font?.pointSize)!)
        }
        
        self.progressView.progress = 0.0
        localtextDirection = textDirection()
        self.location.textAlignment = localtextDirection!
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
    
}

