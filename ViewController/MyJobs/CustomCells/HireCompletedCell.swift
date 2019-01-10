//
//  HireCompletedCell.swift
//  E3malApp
//
//  Created by Rishav Tomar on 13/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class HireCompletedCell: APRatingCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var awardedLabel: UILabel!
    
    @IBOutlet weak var agreedPriceStaticLabel: UILabel!
    
    @IBOutlet weak var amountPaidStaticLabel: UILabel!

    @IBOutlet weak var dateOfPaymentStaticLabel: UILabel!
    
    @IBOutlet weak var myRatingLabel: UILabel!
    
    @IBOutlet weak var userRatingLabel: UILabel!
    
    @IBOutlet weak var agreedPriceLabel: UILabel!
    
    @IBOutlet weak var amountPaidLabel: UILabel!
    
    @IBOutlet weak var dateOfPaymentLabel: UILabel!
    
    var localtextDirection : NSTextAlignment?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.awardedLabel.addLocalization()
        self.agreedPriceStaticLabel.text = Localization("Bid Price")
        self.agreedPriceStaticLabel.addLocalization()
        self.amountPaidStaticLabel.addLocalization()
        self.dateOfPaymentStaticLabel.addLocalization()
        self.myRatingLabel.addLocalization()
        self.userRatingLabel.addLocalization()
        
        localtextDirection = textDirection()
        self.nameLabel.textAlignment = localtextDirection!
        self.agreedPriceLabel.textAlignment = localtextDirection!
        self.amountPaidLabel.textAlignment = localtextDirection!
        self.dateOfPaymentLabel.textAlignment = localtextDirection!
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
