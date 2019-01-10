//
//  WorkListCell.swift
//  E3malApp
//
//  Created by Pawan Dhawan on 22/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

protocol WorkListCellDelegate {
    
    func detailButtonPressed(sender:WorkListCell)
    
}

protocol WorkListCellDetailType3Delegate {
    
    func bidButtonPressed(sender:WorkListCellDetailType3)
    
}

protocol WorkListCellDetailType4Delegate {
    
    func reportButtonPressed(sender:WorkListCellDetailType4)
    
}

protocol WorkListCellDetailType5Delegate {
    
    func downloadButtonPressed(sender:WorkListCellDetailType5)
    
}

protocol WorkListCellDetailType6Delegate {
    
    func postBidButtonPressed(sender:WorkListCellDetailType6)
    
}

protocol WorkListCellDetailType7Delegate {
    
    func sendMessageButtonPressed(sender:WorkListCellDetailType7)
    func cancelButtonPressed(sender:WorkListCellDetailType7)
}

protocol WorkListCellDetailType8Delegate {
    
    func editButtonPressed(sender:WorkListCellDetailType8)
}


protocol WorkListCellDetailType9Delegate {
    
    func viewMessageButtonPressed(sender:WorkListCellDetailType9)
    func markAsCompleteButtonPressed(sender:WorkListCellDetailType9)
    func declineButtonPressed(sender:WorkListCellDetailType9)
}


class WorkListCell: APRatingCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var jobName: UILabel!
    
    @IBOutlet weak var posterName: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var membersRatingCount: UILabel!
    
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var postDate: UILabel!
    
    @IBOutlet weak var detailsButton: UIButton!
    
    @IBOutlet weak var profileVerifiedIcon: UIImageView!
    
    
    var delegate: WorkListCellDelegate?
    var localtextDirection : NSTextAlignment?
    var starRating: String = "5"


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        localtextDirection = textDirection()
        self.location.textAlignment = localtextDirection!
        
    }
    
    
    @IBAction func detailButtonPressed(_ sender: Any) {
        
        delegate?.detailButtonPressed(sender: self)
        
    }

}


class WorkListCellDetailType1: APRatingCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var jobName: UILabel!
    
    @IBOutlet weak var posterName: UILabel!
    
    @IBOutlet weak var membersRatingCount: UILabel!
    
    @IBOutlet weak var profileVerifiedIcon: UIImageView!
    
    @IBOutlet weak var btnShare: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class WorkListCellDetailType2: UITableViewCell {
    
    var localtextDirection : NSTextAlignment?
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var value: UILabel!
    
    @IBOutlet weak var nameWidth: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        localtextDirection = textDirection()
        self.value.textAlignment = localtextDirection!
        if Localisator.sharedInstance.currentLanguage == "ar"{
            self.name.font = UIFont(name: "Geeza Pro", size: (self.name.font?.pointSize)!)
            self.value.font = UIFont(name: "Geeza Pro", size: (self.value.font?.pointSize)!)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}

class WorkListCellDetailType3: UITableViewCell {
    
    @IBOutlet weak var bidButton: UIButton!
    
    var delegate: WorkListCellDetailType3Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bidButton.addLocalization()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func bidButtonPressed(_ sender: Any) {
        delegate?.bidButtonPressed(sender: self)
    }
    
}

class WorkListCellDetailType4: UITableViewCell {
    
    @IBOutlet weak var reportButton: UIButton!
    var delegate: WorkListCellDetailType4Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        reportButton.addLocalization()
        self.reportButton.changeCornerAndColor(20, borderWidth: 1.0 , color: Constants.cornerColor)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func reportButtonPressed(_ sender: Any) {
        
        delegate?.reportButtonPressed(sender: self)
        
    }
    
}

class WorkListCellDetailType5: UITableViewCell {
    
    var delegate: WorkListCellDetailType5Delegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var uploadBtn: UIButton!
    
    @IBOutlet weak var uploadLabel: UILabel!
    
    @IBOutlet weak var upArrowImageView: UIImageView!
    
    var localtextDirection : NSTextAlignment?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        localtextDirection = textDirection()
        //self.uploadLabel.textAlignment = localtextDirection
        self.titleLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
        self.uploadLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
        if Localisator.sharedInstance.currentLanguage == "ar"{
            self.uploadLabel.font = UIFont(name: "Geeza Pro", size: (self.uploadLabel.font?.pointSize)!)
            self.titleLabel.font = UIFont(name: "Geeza Pro", size: (self.titleLabel.font?.pointSize)!)
        }
    }
    
    @IBAction func downloadButtonPressed(_ sender: Any) {
        
        delegate?.downloadButtonPressed(sender: self)
        
    }
 
}

class WorkListCellDetailType6: UITableViewCell {
    
    @IBOutlet weak var bidButton: UIButton!
    
    var delegate: WorkListCellDetailType6Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bidButton.addLocalization()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //bidButton.addLocalization()

    }
    
    @IBAction func bidButtonPressed(_ sender: Any) {
        
        delegate?.postBidButtonPressed(sender: self)
        
    }
    
}

class WorkListCellDetailType7: UITableViewCell {
    
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate: WorkListCellDetailType7Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sendMessageButton.addLocalization()
        cancelButton.addLocalization()

        self.cancelButton.changeCornerAndColor(20, borderWidth: 1.0 , color: Constants.cornerColor)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        
        delegate?.sendMessageButtonPressed(sender: self)
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        delegate?.cancelButtonPressed(sender: self)
        
    }
    
}


class WorkListCellDetailType8: UITableViewCell {
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var quoteDateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateValueLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    var localtextDirection : NSTextAlignment?
    var delegate: WorkListCellDetailType8Delegate?
    
    @IBOutlet weak var belowEditBg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        editButton.addLocalization()
        
        if editButton.isHidden {
            belowEditBg.isHidden = true
        }
        
        quoteDateLabel.addLocalization()
        quoteDateLabel.addTextSpacing(spacing: 1)
        dateLabel.addLocalization()
        priceLabel.addLocalization()
        
        localtextDirection = textDirection()
        self.dateValueLabel.textAlignment = localtextDirection!
        self.priceValueLabel.textAlignment = localtextDirection!
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
        delegate?.editButtonPressed(sender: self)
        
    }
    
}


class WorkListCellDetailType9: UITableViewCell {
    
    @IBOutlet weak var viewMessageButton: UIButton!
    @IBOutlet weak var markAsCompleteButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    var delegate: WorkListCellDetailType9Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewMessageButton.addLocalization()
        markAsCompleteButton.addLocalization()
        declineButton.addLocalization()
        
        self.declineButton.changeCornerAndColor(20, borderWidth: 1.0 , color: Constants.cornerColor)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func viewMessageButtonPressed(_ sender: Any) {
        
        delegate?.viewMessageButtonPressed(sender: self)
        
    }
    
    @IBAction func markAsCompleteButtonPressed(_ sender: Any) {
        
        delegate?.markAsCompleteButtonPressed(sender: self)
        
    }
    
    @IBAction func declineButtonPressed(_ sender: Any) {
        
        delegate?.declineButtonPressed(sender: self)
        
    }
    
}

class WorkListCellDetailType10: APRatingCell {
    
    @IBOutlet weak var quoteDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    
    @IBOutlet weak var paidAmountLabel: UILabel!
    @IBOutlet weak var paidAmountValueLabel: UILabel!
    @IBOutlet weak var myRatingLabel: UILabel!
    @IBOutlet weak var ratingByJobPosterLabel: UILabel!
    
    var localtextDirection : NSTextAlignment?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        quoteDateLabel.addLocalization()
        quoteDateLabel.addTextSpacing(spacing: 1)
        
        priceLabel.addLocalization()

        paidAmountLabel.addLocalization()
        myRatingLabel.addLocalization()
        ratingByJobPosterLabel.addLocalization()
        
        localtextDirection = textDirection()
        self.priceValueLabel.textAlignment = localtextDirection!
        self.paidAmountValueLabel.textAlignment = localtextDirection!
        
        
        if Localisator.sharedInstance.currentLanguage == "ar"{
            
            quoteDateLabel.textAlignment = .right

            priceLabel.textAlignment = .right
            paidAmountLabel.textAlignment = .right
            myRatingLabel.textAlignment = .right
            ratingByJobPosterLabel.textAlignment = .right
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class WorkListCellDisputed: UITableViewCell {
    
    @IBOutlet weak var quoteDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    
    @IBOutlet weak var disputeReasonLabel: UILabel!
    @IBOutlet weak var disputeReasonValueLabel: UILabel!
    @IBOutlet weak var statusLable: UILabel!
    @IBOutlet weak var statusValueLable: UILabel!
    
    var localtextDirection : NSTextAlignment?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        quoteDateLabel.addLocalization()
        quoteDateLabel.addTextSpacing(spacing: 1)

        priceLabel.addLocalization()

        disputeReasonLabel.addLocalization()
        statusLable.addLocalization()
        
        
        localtextDirection = textDirection()
        self.priceValueLabel.textAlignment = localtextDirection!
        self.disputeReasonValueLabel.textAlignment = localtextDirection!
        self.statusValueLable.textAlignment = localtextDirection!
        
        if Localisator.sharedInstance.currentLanguage == "ar"{
            priceLabel.textAlignment = .right
            disputeReasonLabel.textAlignment = .right
            statusLable.textAlignment = .right
        }
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}




