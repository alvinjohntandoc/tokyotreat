//
//  ModalViewController.swift
//  Pairs
//
//  Created by Alvin John Tandoc on 07/08/2018.
//  Copyright © 2018 Tokyo Treat. All rights reserved.
//

import UIKit

protocol ModalViewControllerDelegate: class {
    func modalViewControllerPlayAgain()
}

class ModalViewController: UIViewController {

    @IBOutlet weak var starOneImageView: UIImageView!
    @IBOutlet weak var starTwoImageView: UIImageView!
    @IBOutlet weak var starThreeImageView: UIImageView!
    
    var score: Int = 0
    
    weak var delegate: ModalViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch score {
        case 1:
            self.starOneImageView.image = UIImage(named: "starratingon")
        case 2:
            self.starOneImageView.image = UIImage(named: "starratingon")
            self.starTwoImageView.image = UIImage(named: "starratingon")
        case 3:
            self.starOneImageView.image = UIImage(named: "starratingon")
            self.starTwoImageView.image = UIImage(named: "starratingon")
            self.starThreeImageView.image = UIImage(named: "starratingon")
        default:
            self.starOneImageView.image = UIImage(named: "starratingoff")
            self.starTwoImageView.image = UIImage(named: "starratingoff")
            self.starThreeImageView.image = UIImage(named: "starratingoff")
        }
    }
    
    //MARK: Play Again Action
    @IBAction func playAgainAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.modalViewControllerPlayAgain()
    }
    
}
