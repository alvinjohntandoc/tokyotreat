//
//  CardCollectionViewCell.swift
//  Pairs
//
//  Created by Alvin John Tandoc on 07/08/2018.
//  Copyright © 2018 Tokyo Treat. All rights reserved.
//

import UIKit

class BoxCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func bind(_ box: Box) {
        if box.isRemoved {
            self.backgroundColor = UIColor.white
        } else {
            self.backgroundColor = UIColor.black
        }
        
        if box.isShow {
            self.valueLabel.text = "\(box.value)"
        } else {
            self.valueLabel.text = ""
        }
    }
    
}
