//
//  HireOngoingJobCell.swift
//  E3malApp
//
//  Created by Rishav Tomar on 13/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

@objc protocol APOngoingButtonDelegate {
    
    func messageBtnPressed()
    func completeBtnPressed()
    func declineBtnPressed()
}

class HireOngoingJobCell: UITableViewCell {
    
    
    @IBOutlet weak var messageBtn: UIButton!
    
    @IBOutlet weak var completeBtn: UIButton!
    
    @IBOutlet weak var declineBtn: UIButton!
    
    var delegate : APOngoingButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         self.messageBtn.changeCornerAndColor(20, borderWidth: 1.0 , color: Constants.cornerColor)
        self.messageBtn.addLocalization()
        self.messageBtn.titleLabel?.addTextSpacing(spacing: 0)
        
        self.completeBtn.changeCornerAndColor(20, borderWidth: 1.0 , color: Constants.cornerColor)
        self.completeBtn.addLocalization()
        self.completeBtn.titleLabel?.addTextSpacing(spacing: 0)
        
        self.declineBtn.changeCornerAndColor(20, borderWidth: 1.0 , color: Constants.cornerColorGreen)
        self.declineBtn.addLocalization()
        self.declineBtn.titleLabel?.addTextSpacing(spacing: 0)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func messageBtnPressed(_ sender: UIButton) {
        self.delegate?.messageBtnPressed()
    }
    
    
    @IBAction func completeBtnPressed(_ sender: UIButton) {
        self.delegate?.completeBtnPressed()
    }
    
    
    @IBAction func declineBtnPressed(_ sender: UIButton) {
        self.delegate?.declineBtnPressed()
    }

}
