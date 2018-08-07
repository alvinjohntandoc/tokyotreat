//
//  ViewController.swift
//  Pairs
//
//  Created by Alvin John Tandoc on 07/08/2018.
//  Copyright © 2018 Tokyo Treat. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let kDefaultMessage = "Pick 2 Cards"
    let kSuccessMessage = "Well done!"
    let kDidNotMatchMessage = "Card did not match! Try Again!"
    
    let presenter: MainPresenter = MainPresenter()
    var cards: [Card] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        presenter.attachView(view: self)
        self.start()
    }
    
    //MARK: - Start
    func start() {
        self.cards.removeAll()
        self.cards = self.presenter.generateCards(characters: "abcdefgh")
        self.cards = self.presenter.shuffle(&self.cards)
        
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
        
        delay(0.3) {
            self.presenter.check()
        }
    }
    
}

extension MainViewController: MainView {
    
    func mainViewCardsDidNotMatch(firstCard: Card, lastCard: Card) {
        self.messageLabel.text = self.kDidNotMatchMessage
        
        self.presenter.roundCounter += 1
        
        self.cards[firstCard.tag!] = self.presenter.hide(&self.cards[firstCard.tag!])
        self.cards[lastCard.tag!] = self.presenter.hide(&self.cards[lastCard.tag!])
        
        delay(1.0) {
            self.collectionView.reloadData()
            self.messageLabel.text = self.kDefaultMessage
        }
    }
    
    func mainViewCardsMatched(firstCard: Card, lastCard: Card) {
        self.presenter.matchedCounter += 1
        
        self.messageLabel.text = self.kSuccessMessage
        
        self.presenter.roundCounter += 1
        
        self.cards[firstCard.tag!] = self.presenter.remove(&self.cards[lastCard.tag!])
        
        delay(1.0) {
            self.collectionView.reloadData()
            self.messageLabel.text = self.kDefaultMessage
            
            if self.presenter.isCompleted {
                self.showRating()
            }
        }
    }
    
}

extension MainViewController: ModalViewControllerDelegate {
    
    func modalViewControllerPlayAgain() {
        self.start()
    }
    
}
