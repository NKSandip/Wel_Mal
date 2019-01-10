//
//  APProfileButtonTableViewCell.swift
//  E3malApp
//
//  Created by Rishav Tomar on 09/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
@objc protocol APProfileStartButtonDelegate {
    func profileStartBtnPressed()
}

class APProfileButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileStartButton: UIButton!
    var delegate :APProfileStartButtonDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.profileStartButton.changeCornerAndColor(20, borderWidth: 1.0 , color: Constants.cornerColor)
        if Localisator.sharedInstance.currentLanguage == "ar"{
            self.profileStartButton.titleLabel?.font = UIFont(name: "GeezaPro-Bold", size: ( self.profileStartButton.titleLabel?.font.pointSize)!)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func profileStartButtonPressed(_ sender: UIButton) {
        self.delegate?.profileStartBtnPressed()
    }
}
