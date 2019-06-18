//
//  GameScene.swift
//  trafficSense
//
//  Created by Mohamed Ahmed on 6/13/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var car : SKShapeNode?
    private var spinnyNode : SKShapeNode?
    private var light = SKShapeNode(circleOfRadius: 100)
    private var line = SKShapeNode(rect: CGRect(x: 0, y: 300, width: 10, height: 200))
    private var carArray:[SKShapeNode] = []
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.car = self.childNode(withName: "//car") as? SKShapeNode
        if let car = self.car {
            car.fillColor = SKColor.blue
            carArray.append(car)
        }
        
        line.position.x = -self.frame.width/2 + 70
        // How to cure cancer:
//        let shape = SKShapeNode()
//        shape.path = UIBezierPath(arcCenter: CGPoint(x: 100, y:0), radius: 100, startAngle: 0, endAngle: 2*3.1415, clockwise: true).cgPath
// //       shape.position = CGPoint(x: frame.midX, y: frame.midY)
//        shape.fillColor = UIColor.red
//        addChild(shape)
        
        light.position = CGPoint(x: -200, y: 300)
        light.fillColor = SKColor.red
        light.name = "light"
        light.isUserInteractionEnabled = false
        self.addChild(light)
        
        line.fillColor = SKColor.white
        self.addChild(line)
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
    }
    
    
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let car = self.car {
//            car.position = pos
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
    //    for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            let nameOfTappedNode = nodeITapped.name
            
            if nameOfTappedNode == "light"{
                //make it do whatever you want
                switchLight()
                
            }
            
        }

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func switchLight() {
        if (light.fillColor == SKColor.red){
            light.fillColor = SKColor.green
        }
        else {
            light.fillColor = SKColor.red
        }
    }
    
    func move() {
//        if let car = self.car {
//            if (!(car.position.x > light.position.x && car.position.x < light.position.x + 10 && checkLight())) {
//                car.position.x -= 5
//                previouslyMoving = true
//            }
//            else if (previouslyMoving) {
//                createCar()
//                previouslyMoving = false
//            }
//        }
//        if (car!.position.x <= -self.scene!.size.width/2 ) {
//            print(car!.position.x)
//            car!.position.x = self.scene!.size.width/2
//            print(car!.position.x)
//        }
//
        for vehicle in carArray {
            if (!(vehicle.position.x > light.position.x && vehicle.position.x < light.position.x + 10 && checkLight())) {
                vehicle.position.x -= 5
            }
            if (vehicle.position.x <= -self.scene!.size.width/2 ) {
                vehicle.position.x = self.scene!.size.width/2
                if (vehicle.fillColor == SKColor.blue && carArray.count < 12) {
                    createCar()
                }
            }
        }
    }
    
    func createCar() {
        var car = SKShapeNode(circleOfRadius: 20)
        car.fillColor = SKColor.orange
        let number = Int.random(in: -500 ... 300)
        car.position = CGPoint(x: 0, y: number)
        self.addChild(car)
        carArray.append(car)
    }
    
    func checkLight() -> Bool {
        return light.fillColor == SKColor.red
    }
    
    override func update(_ currentTime: TimeInterval) {
        move()
        
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
