//
//  HireJobDetailCell.swift
//  E3malApp
//
//  Created by Rishav Tomar on 26/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

@objc protocol APHireJobDetailsButtonDelegate {
    func showMoreBtnPressed(tag : Int)
    func chatBtnPressed(tag : Int)
    func acceptBtnPressed(tag: Int)
    func downloadBtnPressed(tag: Int)
    func imageTapped(tag: Int)
}

class HireJobDetailCell: APRatingCell {
    
    @IBOutlet weak var chatBtn: UIButton!
    
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBOutlet weak var downloadBtn: UIButton!

    @IBOutlet weak var doucmentLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var memberCountLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var personImage: UIImageView!
    
    @IBOutlet weak var showMoreBtn: UIButton!
    
    @IBOutlet weak var descTxtLabel: UILabel!
    
    @IBOutlet weak var chatLabel: UILabel!
    
    @IBOutlet weak var acceptLabel: UILabel!
    
    @IBOutlet weak var chatImage: UIImageView!
    
    @IBOutlet weak var tickImage: UIImageView!
    
    @IBOutlet weak var AmtTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var acceptTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descheightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descHeightOfMoreBtnConstraint: NSLayoutConstraint!

    @IBOutlet weak var chatImageLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileVerifiedIcon: UIImageView!
    
    @IBOutlet weak var imageBtn: UIButton!
    
    var delegate: APHireJobDetailsButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.personImage.image = nil
        self.locationLabel.text = ""
        self.chatLabel.text = ""
        self.acceptLabel.text = ""
        self.nameLabel.text = ""
        self.doucmentLabel.text = ""
        
        self.personImage.layer.cornerRadius = self.personImage.frame.size.width/2
        self.personImage.clipsToBounds = true
        self.locationLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
        self.chatLabel.text = Localization("CHAT")
        self.chatLabel.addTextSpacing(spacing: 0.8)
        self.chatLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
        self.acceptLabel.text = Localization("ACCEPT")
        self.acceptLabel.addTextSpacing(spacing: 0.8)
        self.acceptLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
        self.nameLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
        self.doucmentLabel.addLocalizationBold()
        self.doucmentLabel.textAlignment = Localisator.sharedInstance.currentTextDirection
        self.doucmentLabel.addTextSpacing(spacing: 0.8)
        if Localisator.sharedInstance.currentLanguage == "ar"{
            self.locationLabel.font = UIFont(name: "Geeza Pro", size: (self.locationLabel.font?.pointSize)!)
             self.chatLabel.font = UIFont(name: "GeezaPro-Bold", size: 10)
            self.acceptLabel.font = UIFont(name: "GeezaPro-Bold", size: 10)
            self.acceptTrailingConstraint.constant = 23
        }
        self.personImage.isUserInteractionEnabled = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func chatBtnPressed(_ sender: UIButton) {
        self.delegate?.chatBtnPressed(tag: sender.tag)
    }
    
    
    @IBAction func acceptBtnPressed(_ sender: UIButton) {
        self.delegate?.acceptBtnPressed(tag: sender.tag)
    }
    
    
    @IBAction func downloadBtnPressed(_ sender: UIButton) {
        self.delegate?.downloadBtnPressed(tag: sender.tag)
    }
    
    @IBAction func showMoreBtnPressed(_ sender: UIButton) {
         self.delegate?.showMoreBtnPressed(tag: sender.tag)
    }
    
    
    @IBAction func imageTapped(_ sender: UIButton) {
        self.delegate?.imageTapped(tag: sender.tag)
    }
  
    
  
    
    class func requiredHeight(text:String) -> CGFloat{
        let width = (UIApplication.shared.keyWindow?.bounds.width)! - 100
        let font = UIFont(name: "FSJoey-Regular", size: 10.0)
        let label:UILabel = UILabel(frame: CGRect(x:0, y:0,width: width
            , height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height + 40 //126
    }
    
}
