//
//  ViewController.swift
//  Pairs
//
//  Created by Alvin John Tandoc on 07/08/2018.
//  Copyright © 2018 Tokyo Treat. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let kDefaultMessage = "Pick 2 Box"
    let kSuccessMessage = "Well done!"
    let kDidNotMatchMessage = "Boxes did not match! Try Again!"
    
    let presenter: MainPresenter = MainPresenter()
    var boxes: [Box] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageLabel: UILabel!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        presenter.attachView(view: self)
        self.start()
    }
    
    //MARK: - Start
    func start() {
        self.boxes.removeAll()
        self.boxes = self.presenter.generateCards(characters: "abcdefgh")
        self.boxes = self.presenter.shuffle(&self.boxes)
        
        self.collectionView.reloadData()
        
        //uncomment if you want to know the positions
        /*for (index, card) in self.cards.enumerated() {
            print("index: \(index) - \(card.value)")
        }*/
    }

    //MARK: - Show Rating
    func showRating() {
        guard let score = self.presenter.score else {return}
        let modalViewController: ModalViewController = self.storyboard?.instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        modalViewController.score = score
        modalViewController.delegate = self
        AJModalViewController.show(viewController: modalViewController, height: 320, width: 320, parent: self)
    }
    
}

//MARK: - CollectionView Data Source and Delegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.boxes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let inset: CGFloat = 5.0
        
        let size = ((screenSize.width - (inset * 5)) / 4)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BoxCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoxCollectionViewCell", for: indexPath) as! BoxCollectionViewCell
        
        cell.bind(self.boxes[indexPath.row])
        self.boxes[indexPath.row].tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.boxes[indexPath.row] = self.presenter.remember(&self.boxes[indexPath.row])
        self.collectionView.reloadData()
        
        delay(0.3) {
            self.presenter.check()
        }
    }
    
}

//MARK: Main View
extension MainViewController: MainView {
    
    func mainViewCardsDidNotMatch(firstCard: Box, lastCard: Box) {
        self.messageLabel.text = self.kDidNotMatchMessage
        
        self.presenter.roundCounter += 1
        
        self.boxes[firstCard.tag!] = self.presenter.hide(&self.boxes[firstCard.tag!])
        self.boxes[lastCard.tag!] = self.presenter.hide(&self.boxes[lastCard.tag!])
        
        delay(1.0) {
            self.collectionView.reloadData()
            self.messageLabel.text = self.kDefaultMessage
        }
    }
    
    func mainViewCardsMatched(firstBox: Box, lastBox: Box) {
        self.presenter.matchedCounter += 1
        
        self.messageLabel.text = self.kSuccessMessage
        
        self.presenter.roundCounter += 1
        
        self.boxes[firstBox.tag!] = self.presenter.remove(&self.boxes[firstBox.tag!])
        self.boxes[firstBox.tag!] = self.presenter.remove(&self.boxes[lastBox.tag!])
        
        delay(1.0) {
            self.collectionView.reloadData()
            self.messageLabel.text = self.kDefaultMessage
            
            if self.presenter.isCompleted {
                self.showRating()
            }
        }
    }
    
}

//MARK: - Modal View Controller Delegate
extension MainViewController: ModalViewControllerDelegate {
    
    func modalViewControllerPlayAgain() {
        self.start()
    }
    
}
