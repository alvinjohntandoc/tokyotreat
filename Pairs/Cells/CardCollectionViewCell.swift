//
//  CardCollectionViewCell.swift
//  Pairs
//
//  Created by Alvin John Tandoc on 07/08/2018.
//  Copyright © 2018 Tokyo Treat. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func bind(_ card: Card) {
        if card.isRemoved {
            self.backgroundColor = UIColor.white
        } else {
            self.backgroundColor = UIColor.black
        }
        
        if card.isShow {
            self.valueLabel.text = "\(card.value)"
        } else {
            self.valueLabel.text = ""
        }
    }
    
}
