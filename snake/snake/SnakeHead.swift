//
//  SnakeHead.swift
//  snake
//
//  Created by Владислав Лихачев on 10.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit
import SpriteKit

class SnakeHead : SnakeBodyPart {
    override init(atPoint: CGPoint) {
        super.init(atPoint: atPoint)
        self.physicsBody?.categoryBitMask = CollisionCategories.SnakeHead
        self.physicsBody?.contactTestBitMask = CollisionCategories.EdgeBody | CollisionCategories.Apple | CollisionCategories.Snake
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
