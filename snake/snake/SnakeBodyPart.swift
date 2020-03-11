//
//  SnakeBodyPart.swift
//  snake
//
//  Created by Владислав Лихачев on 10.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit
import SpriteKit

class SnakeBodyPart : SKShapeNode {
    let diameter = 10.0
    
    init(atPoint : CGPoint) {
        super.init()
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: diameter, height: diameter)).cgPath
        fillColor = .green
        strokeColor = .green
        lineWidth = 5
        self.position = atPoint
        self.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(diameter - 8), center: CGPoint(x: 5, y:5))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = CollisionCategories.Snake
        self.physicsBody?.contactTestBitMask = CollisionCategories.EdgeBody | CollisionCategories.Apple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
