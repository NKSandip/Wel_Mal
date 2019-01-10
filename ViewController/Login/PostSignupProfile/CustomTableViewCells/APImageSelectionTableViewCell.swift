//
//  APImageSelectionTableViewCell.swift
//  E3malApp
//
//  Created by Rishav Tomar on 09/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

@objc protocol APProfileImageDelegate {
    func openActionSheet(sender: UIButton)
}


class APImageSelectionTableViewCell: UITableViewCell,APProfilePickerImageDelgate {
    
    //MARK: OutLets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profilePicButton: UIButton!
    @IBOutlet weak var profilePicTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewForShadow: UIImageView!
    
    //Mark: Varibles
    var delegate: APProfileImageDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutIfNeeded()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
        self.profileImageView.clipsToBounds = true
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func profilePicButtonPressed(_ sender: AnyObject) {
        self.delegate?.openActionSheet(sender: sender as! UIButton)
    }
    
    func getPickedImage(pickedImage: UIImage) {
        self.profileImageView.image = pickedImage
        self.profileImageView.contentMode = .scaleAspectFill
        self.profilePicButton.imageView?.alpha = 0.3
    }


}
