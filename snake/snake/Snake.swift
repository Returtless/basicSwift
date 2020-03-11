//
//  Snake.swift
//  snake
//
//  Created by Владислав Лихачев on 10.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit
import SpriteKit

class Snake: SKShapeNode {
    var body = [SnakeBodyPart]()
    let moveSpeed : CGFloat = 125.0
    var angle : CGFloat = 0.0
    
    convenience init(atPoint point: CGPoint) {
        self.init()
        let head = SnakeHead(atPoint: point)
        body.append(head)
        addChild(head)
        addBodyPart()
    }
    
    func addBodyPart(){
        let newBodyPart = SnakeBodyPart(atPoint: CGPoint(x: body.last!.position.x, y: body.last!.position.y - 8))
        body.append(newBodyPart)
        addChild(newBodyPart)
    }
    
    func move(){
        guard !body.isEmpty else {
            return
        }
        let head = body[0]
        moveHead(head)
        for i in 1..<body.count {
            moveBodyPart(previousPart: body[i-1], body[i])
        }
    }
    
    func moveHead(_ head: SnakeBodyPart) {
        let dx = moveSpeed * sin(angle)
        let dy = moveSpeed * cos(angle)
        let nextPosition = CGPoint(x: head.position.x+dx, y: head.position.y + dy)
        
        let moveAction = SKAction.move(to: nextPosition, duration: 1.0)
        
        head.run(moveAction)
    }
    
    func moveBodyPart(previousPart p : SnakeBodyPart, _ current : SnakeBodyPart) {
        let moveAction = SKAction.move(to: CGPoint(x: p.position.x, y: p.position.y), duration: 0.1)
        current.run(moveAction)
    }
    
    func moveClockwise(){
        angle += CGFloat(Double.pi / 2)
    }
    
    func moveCounterClockwise(){
        angle -= CGFloat(Double.pi / 2)
    }
}
