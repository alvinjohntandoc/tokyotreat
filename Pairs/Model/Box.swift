//
//  Card.swift
//  Pairs
//
//  Created by Alvin John Tandoc on 07/08/2018.
//  Copyright © 2018 Tokyo Treat. All rights reserved.
//

import UIKit

struct Box {
    var value: Character
    var isShow: Bool = false
    var isRemoved: Bool = false
    var tag: Int?
    
    init(value: Character) {
        self.value = value
    }
}
