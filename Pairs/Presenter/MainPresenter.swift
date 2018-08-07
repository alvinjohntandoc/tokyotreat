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
    
    var firstBox: Box?
    var lastBox: Box?
    
    private var characters: String = ""
    
    var roundCounter: Int = 0
    var matchedCounter: Int = 0
    
    //all cards has been matched
    var isCompleted: Bool {
        return self.matchedCounter == self.characters.count
    }
    
    /*⭐️⭐️⭐️ = 8 rounds or fewer
     ⭐️⭐️ = 12 rounds or fewer
     ⭐️ = 13 rounds or more*/
    
    var score: Int? {
        if self.isCompleted {
            if roundCounter <= 8 {
                return 3
            } else if roundCounter <= 12 {
                return 2
            } else {
                return 1
            }
        }
        
        return nil
    }
    
    func attachView(view: MainView) {
        self.view = view
    }
    
    //MARK: Generate Cards
    func generateCards(characters: String) -> [Box] {
        self.characters = characters
        
        var boxes: [Box] = []
        for c in characters {
            let box1 = Box(value: c)
            let box2 = Box(value: c)
            
            boxes.append(box1)
            boxes.append(box2)
        }
        
        return boxes
    }
    
    //MARK: - Shuffle
    func shuffle(_ boxes: inout [Box]) -> [Box] {
        var counter = boxes.count
        let max: Int = boxes.count - 1
        
        while counter != 0 {
            let randomIndex: Int = Int(arc4random_uniform(UInt32(max)))
            boxes.swapAt(max, randomIndex)
            counter -= 1
        }
        
        return boxes
    }
    
    //MARK: - Remember
    func remember(_ box: inout Box) -> Box {
        if !box.isRemoved {
            if self.firstBox == nil {
                self.firstBox = box
                box.isShow = true
            } else if self.firstBox!.tag != box.tag {
                self.lastBox = box
                box.isShow = true
            }
        }
        
        return box
    }
    
    //MARK: - Check
    func check() {
        if self.firstBox != nil && self.lastBox != nil {
            if self.firstBox!.value != self.lastBox!.value {
                self.view?.mainViewCardsDidNotMatch(firstCard: self.firstBox!, lastCard: self.lastBox!)
                
                self.firstBox = nil
                self.lastBox = nil
            } else {
                
                self.view?.mainViewCardsMatched(firstBox: self.firstBox!, lastBox: self.lastBox!)
                
                self.firstBox = nil
                self.lastBox = nil
            }
        }
    }
    
    //MARK: - Remove Card
    func remove(_ box: inout Box) -> Box {
        box.isShow = true
        box.isRemoved = true
        return box
    }
    
    //MARK: - Hide Card
    func hide(_ box: inout Box) -> Box {
        box.isShow = false
        return box
    }
}
