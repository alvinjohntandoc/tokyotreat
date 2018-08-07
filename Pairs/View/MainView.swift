//
//  MainView.swift
//  Pairs
//
//  Created by Alvin John Tandoc on 07/08/2018.
//  Copyright © 2018 Tokyo Treat. All rights reserved.
//

import UIKit

protocol MainView {
    func mainViewCardsDidNotMatch(firstCard: Box, lastCard: Box)
    func mainViewCardsMatched(firstBox: Box, lastBox: Box)
}
