//
//  MainPresenter.swift
//  Pairs
//
//  Created by Alvin John Tandoc on 07/08/2018.
//  Copyright © 2018 Tokyo Treat. All rights reserved.
//

import UIKit

class MainPresenter: NSObject {
    
    var view: MainView?
    
    var firstCard: Card?
    var lastCard: Card?
    
    private var characters: String = ""
    
    var roundCounter: Int = 0 {
        didSet {
            print(roundCounter)
        }
    }
    
    var matchedCounter: Int = 0
    
    func attachView(view: MainView) {
        self.view = view
    }
    
    //MARK: Generate Cards
    func generateCards(characters: String) -> [Card] {
        self.characters = characters
        
        var cards: [Card] = []
        for c in characters {
            let card1 = Card(value: c)
            let card2 = Card(value: c)
            
            cards.append(card1)
            cards.append(card2)
        }
        
        return cards
    }
    
    //MARK: - Shuffle
    func shuffle(_ cards: inout [Card]) -> [Card] {
        var counter = cards.count
        let lastCount: Int = cards.count - 1
        
        while counter != 0 {
            let randomIndex: Int = Int(arc4random_uniform(UInt32(lastCount)))
            cards.swapAt(lastCount, randomIndex)
            counter -= 1
        }
        
        return cards
    }
    
    //MARK: - Remember
    func remember(_ card: inout Card) -> Card {
        if self.firstCard == nil {
            self.firstCard = card
            card.isShow = true
        } else {
            self.lastCard = card
            card.isShow = true
        }
        
        return card
    }
    
    func check() {
        if self.firstCard != nil && self.lastCard != nil {
            if self.firstCard!.value != self.lastCard!.value {
                self.view?.mainViewCardsDidNotMatch(firstCard: self.firstCard!, lastCard: self.lastCard!)
                
                self.firstCard = nil
                self.lastCard = nil
            } else {
                
                self.view?.mainViewCardsMatched(firstCard: self.firstCard!, lastCard: self.lastCard!)
                
                self.firstCard = nil
                self.lastCard = nil
            }
        }
    }
    
    var isCompleted: Bool {
        return self.matchedCounter == self.characters.count / 2
    }
}
