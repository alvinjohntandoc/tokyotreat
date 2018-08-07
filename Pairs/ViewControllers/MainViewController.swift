//
//  ViewController.swift
//  Pairs
//
//  Created by Alvin John Tandoc on 07/08/2018.
//  Copyright © 2018 Tokyo Treat. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let kFindPairMessage = "Pick a Pair"
    let kSuccessMessage = "Well done!"
    let kDidNotMatchMessage = "Card did not match! Try Again!"
    
    let presenter: MainPresenter = MainPresenter()
    var cards: [Card] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        presenter.attachView(view: self)
        
        self.cards = self.presenter.generateCards(characters: "abcdefgh")
        self.cards = self.presenter.shuffle(&self.cards)
        
        self.collectionView.reloadData()
        
        for card in cards {
            print(card.value)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let inset: CGFloat = 5.0
        
        let size = ((screenSize.width - (inset * 5)) / 4)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CardCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
        
        cell.bind(self.cards[indexPath.row])
        self.cards[indexPath.row].tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cards[indexPath.row] = self.presenter.remember(&self.cards[indexPath.row])
        self.collectionView.reloadData()
        self.presenter.check()
    }
    
}

extension MainViewController: MainView {
    
    func mainViewCardsDidNotMatch(firstCard: Card, lastCard: Card) {
        self.view.isUserInteractionEnabled = false
        
        self.messageLabel.text = self.kDidNotMatchMessage
        
        self.presenter.roundCounter += 1
        
        delay(1.0) {
            self.cards[firstCard.tag!].isShow = false
            self.cards[lastCard.tag!].isShow = false
            self.view.isUserInteractionEnabled = true
            
            self.collectionView.reloadData()
            
            self.messageLabel.text = ""
        }
    }
    
    func mainViewCardsMatched(firstCard: Card, lastCard: Card) {
        self.view.isUserInteractionEnabled = false
        self.presenter.matchedCounter += 1
        
        self.messageLabel.text = self.kSuccessMessage
        
        self.presenter.roundCounter += 1
        
        delay(1.0) {
            self.cards[firstCard.tag!].isShow = true
            self.cards[lastCard.tag!].isShow = true
            self.cards[firstCard.tag!].isRemoved = true
            self.cards[lastCard.tag!].isRemoved = true
            self.view.isUserInteractionEnabled = true

            self.collectionView.reloadData()
            self.messageLabel.text = ""
            
            if self.presenter.isCompleted {
                print("Round: \(self.presenter.roundCounter)")
            }
        }
    }
    
}
