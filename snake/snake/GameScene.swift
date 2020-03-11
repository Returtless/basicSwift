//
//  GameScene.swift
//  snake
//
//  Created by Владислав Лихачев on 10.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import SpriteKit
import GameplayKit

struct CollisionCategories{
    // Тело змеи
    static let Snake: UInt32 = 0x1 << 0
    // Голова змеи
    static let SnakeHead: UInt32 = 0x1 << 1
    // Яблоко
    static let Apple: UInt32 = 0x1 << 2
    // Край сцены (экрана)
    static let EdgeBody:   UInt32 = 0x1 << 3
}

class GameScene: SKScene {
    
    var snake : Snake?
    
    override func didMove(to view: SKView) {
        backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.allowsRotation = false
        view.showsPhysics = true
        self.physicsWorld.contactDelegate = self
        
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        self.physicsBody?.collisionBitMask = CollisionCategories.Snake | CollisionCategories.SnakeHead
        
        restartGame(view)
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            for child in self.children {
                //для обработки ситуации, когда змея ползет по кнопке, нужно перебрать существующие ноды и выбрать ту, которая является кнопкой и имеет соответствующую координату
                if child.calculateAccumulatedFrame().contains(touchLocation){
                    guard child.name == "counterClockwiseButton" || child.name == "clockwiseButton"  || child.name == "restartButton" else {
                        return
                    }
                    if child.name == "restartButton" {
                        restartGame(view!)
                        return
                    } else if child.name == "clockwiseButton" {
                        snake!.moveClockwise()
                    } else {
                        snake!.moveCounterClockwise()
                    }
                    (child as! SKShapeNode).fillColor = .green
                    return
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            for child in self.children {
                if child.calculateAccumulatedFrame().contains(touchLocation){
                    guard child.name == "counterClockwiseButton" || child.name == "clockwiseButton" else {
                        return
                    }
                    (child as! SKShapeNode).fillColor = .gray
                    return
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if let snake = snake {
            snake.move()
        }
    }
    
    func createApple(){
        let randX  = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX-5)) + 1)
        let randY  = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY-5)) + 1)
        
        let apple = Apple(position: CGPoint(x: randX, y: randY))
        self.addChild(apple)
    }
    
    func createNewSnake(_ view: SKView) {
        snake = Snake(atPoint: CGPoint(x: view.scene!.frame.midX, y: view.scene!.frame.midY))
        self.addChild(snake!)
    }
    
    func restartGame(_ view: SKView){
        self.children.forEach({$0.removeFromParent()})
        let counterClockwiseButton = SKShapeNode(ellipseIn: CGRect(x: 0, y: 0, width: 45, height: 45))
        counterClockwiseButton.position = CGPoint(x: view.scene!.frame.minX+30, y: view.scene!.frame.minY+30)
        counterClockwiseButton.fillColor = UIColor.gray
        counterClockwiseButton.strokeColor = UIColor.gray
        counterClockwiseButton.lineWidth = 10
        counterClockwiseButton.name = "counterClockwiseButton"
        self.addChild(counterClockwiseButton)
        
        let clockwiseButton = SKShapeNode(ellipseIn: CGRect(x: 0, y: 0, width: 45, height: 45))
        clockwiseButton.position = CGPoint(x: view.scene!.frame.maxX-80, y: view.scene!.frame.minY+30)
        clockwiseButton.fillColor = UIColor.gray
        clockwiseButton.strokeColor = UIColor.gray
        clockwiseButton.lineWidth = 10
        clockwiseButton.name = "clockwiseButton"
        self.addChild(clockwiseButton)
        
        let scoreNode = SKLabelNode(text: "GAME OVER")
        scoreNode.position = CGPoint(x: view.scene!.frame.midX-10, y: view.scene!.frame.minY)
        
        scoreNode.name = "scoreLabel"
        scoreNode.text = "Съедено: 0 яблок"
        scoreNode.fontColor = .white
        scoreNode.fontSize = 26
        
        self.addChild(scoreNode)
        
        
        createApple()
        
        createNewSnake(view)
    }
}


extension GameScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let bodies = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        let collisionObject = bodies ^ CollisionCategories.SnakeHead
        switch collisionObject {
        case CollisionCategories.Apple:
            let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node
            snake?.addBodyPart()
            apple?.removeFromParent()
            createApple()
            if let label = self.childNode(withName: "scoreLabel") as? SKLabelNode {
                label.text = "Съедено: \(snake!.body.isEmpty ? 0 : snake!.body.count - 2) яблок"
            }
        case CollisionCategories.Snake:
            createGameOverScene(view)
        case CollisionCategories.EdgeBody:
            createGameOverScene(view)
        default:
            break
        }
        
    }
    
    func createGameOverScene(_ view : UIView?) {
        self.children.forEach({$0.removeFromParent()})
        let labelNode = SKLabelNode(text: "Съедено: \(snake!.body.isEmpty ? 0 : snake!.body.count - 2) яблок")
        labelNode.fontName = "AmericanTypewriter-Bold"
        labelNode.position = CGPoint(x: view!.center.x, y: view!.center.y)
        labelNode.fontColor = .green
        labelNode.name = "gameOverLabel"
        self.addChild(labelNode)
        
        snake = nil
        
        let restartButton = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 160, height: 28))
        restartButton.position = CGPoint(x: view!.center.x-80, y: view!.center.y - 50)
        restartButton.fillColor = UIColor.gray
        restartButton.strokeColor = UIColor.gray
        restartButton.lineWidth = 10
        restartButton.name = "restartButton"
        self.addChild(restartButton)
        
        let textNode = SKLabelNode(text: "RESTART")
        textNode.fontName = "AmericanTypewriter-Bold"
        textNode.fontColor = .green
        textNode.position = CGPoint(x: view!.center.x, y: view!.center.y - 50)
        
        textNode.name = "gameOverLabel"
        self.addChild(textNode)
    }
}
