//
//  MainView.swift
//  Pairs
//
//  Created by Alvin John Tandoc on 07/08/2018.
//  Copyright © 2018 Tokyo Treat. All rights reserved.
//

import UIKit

protocol MainView {
    
    func mainViewCardsDidNotMatch(firstCard: Card, lastCard: Card)
    func mainViewCardsMatched(firstCard: Card, lastCard: Card)
}
