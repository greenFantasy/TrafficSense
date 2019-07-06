//
//  GameScene.swift
//  trafficSense
//
//  Created by Yousef Ahmed on 6/13/19.
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
    private var light : TrafficLight?
    private var line = SKShapeNode(rect: CGRect(x: 0, y: 300, width: 10, height: 200))
    private var carArray:[Car] = []
    private var firstStreet = Street(heightWidth: 0, direction: 0)
    private var carCar : Car?
    private var lightArray:[TrafficLight] = []
    private var streetArrayHorizontal:[Street] = []
    private var streetArrayVertical:[Street] = []
    private var intersectionArray:[Intersection] = []
    
    private var gameOverLabel = SKLabelNode(fontNamed: "Helvetica Neue UltraLight")
    
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        self.addChild(gameOverLabel)
        gameOverLabel.isHidden = true
        
        streetArrayHorizontal.append(firstStreet)
        carCar = Car(x:0, y:70, street: firstStreet)
//        light = TrafficLight(x:-200, y:120, location: firstStreet)
//        light!.getNode().name = "1"
//        light!.getNode().isUserInteractionEnabled = false
//        self.addChild(light!.getNode())
//        lightArray.append(light!)
//         createLight(0, 120, street: firstStreet)
//        firstStreet.addLight(trafficLight: light!)
        
        
        
        // Get label node from scene and store it for use later
        self.car = self.childNode(withName: "//car") as? SKShapeNode
        if let car = self.car {
            car.fillColor = SKColor.blue
            carCar!.setNode(node: car)
            carCar!.setPos(newX: 250, newY: 0)
            carArray.append(carCar!)
        }
        
        
        line.position.x = -self.frame.width/2 + 70
        // How to cure cancer:
//        let shape = SKShapeNode()
//        shape.path = UIBezierPath(arcCenter: CGPoint(x: 100, y:0), radius: 100, startAngle: 0, endAngle: 2*3.1415, clockwise: true).cgPath
// //       shape.position = CGPoint(x: frame.midX, y: frame.midY)
//        shape.fillColor = UIColor.red
//        addChild(shape)
        
        
        line.fillColor = SKColor.white
        self.addChild(line)
        
        let secondStreet = Street(heightWidth: -300, direction: 0)
        streetArrayHorizontal.append(secondStreet)
//        createLight(50, -300, street: secondStreet)
//        createCar(400,-300,street: secondStreet)
        
        let thirdStreetVertical = Street(heightWidth: 0,direction: 2)
        let testStreet = Street(heightWidth: 200,direction: 2)
        streetArrayVertical.append(thirdStreetVertical)
        streetArrayVertical.append(testStreet)
        // createLight(0, 300, street: thirdStreetVertical)
        createCar(0, -200, street: thirdStreetVertical)
        
        intersectionCreator() // creates all the intersections based on the horizontal and vertical streets created above
    }
    
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
            
            if let x = nameOfTappedNode {
            
                if let index = Int(x) {
                    //make it do whatever you want
                    switchLight(trafficLight: lightArray[index - 1])
                }
                
            }
            
        }

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func switchLight(trafficLight:TrafficLight) {
        trafficLight.changeState()
    }
    
    func move() {
        
        var elementsToRemove:[Int] = []
        for i in 0...carArray.count-1 {
            let vehicle = carArray[i]
            var moveVehicle = true
            let tempLight = vehicle.findLight()
            if (isVehicleCloseToLight(vehicle: vehicle, light: tempLight) && tempLight.isRed()) {
                moveVehicle = false
            }
            
            if (moveVehicle) {
                
                if let intersection = isCarAtAnyIntersectionChecker(vehicle) {
                    
                    vehicle.turn(streetToTurnOn: getStreetToTurnOn(car: vehicle, intersection: intersection), intersection: intersection)
                }
                
                let vec = vehicle.directionToVector()
                
                vehicle.move(xVel: vec[0] * Int(vehicle.getTopSpeed() * speedModifier(distance: absoluteValue(calcXDistance(car1: vehicle, car2: vehicle.getClosestCar())))), yVel: vec[1] * Int(vehicle.getTopSpeed() * speedModifier(distance: absoluteValue(calcYDistance(car1: vehicle, car2: vehicle.getClosestCar())))))
                
            }
            if (vehicle.getXPos() <= Int(-self.scene!.size.width/2) && vehicle.getDirection() == 0) {
                createCar(Int(self.scene!.size.width/2) + 100, vehicle.getYPos(), street: vehicle.getStreet())
                elementsToRemove.append(i)
                removeCar(vehicle)
                if (carArray.count < 10) {
                    createCar(600, 0, street: firstStreet)
                }
            }
            else if (vehicle.getYPos() <= Int(-self.scene!.size.height/2) && vehicle.getDirection() == 2) {
                createCar(vehicle.getXPos(), Int(self.scene!.size.height/2), street: vehicle.getStreet())
                elementsToRemove.append(i)
                removeCar(vehicle)
                if (carArray.count < 10) {
                    createCar(vehicle.getXPos(), 1000, street: vehicle.getStreet())
                }
            }
            else if (vehicle.getYPos() >= Int(self.scene!.size.height/2) && vehicle.getDirection() == 3) {
                createCar(vehicle.getXPos(), Int(-self.scene!.size.height/2), street: vehicle.getStreet())
                elementsToRemove.append(i)
                removeCar(vehicle)
                if (carArray.count < 10) {
                    createCar(vehicle.getXPos(), -vehicle.getYPos() - 100, street: vehicle.getStreet())
                }
            }
            else if (vehicle.getXPos() >= Int(self.scene!.size.width/2) && vehicle.getDirection() == 1) {
                createCar(Int(-self.scene!.size.width/2), vehicle.getYPos(), street: vehicle.getStreet())
                elementsToRemove.append(i)
                removeCar(vehicle)
            }
        }
        removeElementsFromArray(elementsToRemove: elementsToRemove, array: &carArray)
        
    }
    
    func removeCar(_ vehicle: Car) {
        vehicle.getNode().removeFromParent()
        vehicle.getStreet().removeCar(car: vehicle)
    }
    
    
    func removeElementsFromArray(elementsToRemove: [Int], array: inout [Car]) {
        let elementsReversed = elementsToRemove.reversed()
        for i in elementsReversed {
            array.remove(at: i)
        }
    }
    
    func isVehicleCloseToLight(vehicle: Car, light: TrafficLight) -> Bool {
        if vehicle.getDirection() == 0 {
            return vehicle.getXPos() > light.getXPos() && vehicle.getXPos() < light.getXPos() + 10
        } else if vehicle.getDirection() == 2 {
            return vehicle.getYPos() > light.getYPos() && vehicle.getYPos() < light.getYPos() + 10
        } else if vehicle.getDirection() == 1 {
            return vehicle.getXPos() < light.getXPos() && vehicle.getXPos() > light.getXPos() - 10
        } else {
            return vehicle.getYPos() < light.getYPos() && vehicle.getYPos() > light.getYPos() - 10
        }
    }
    
    func calcNewOffset(spacing base: Double) -> Double {
        var newOffset = base
        for vehicle in carArray {
            let boundingBox = vehicle.getNode().path!.boundingBox
            let vehicleWidth = boundingBox.size.width
            newOffset = newOffset + Double(vehicleWidth) + base
        }
        print(newOffset)
        return newOffset
    }
    
    func calcXDistance(car1: Car?, car2: Car?) -> Int {
//        let boundingBox1 = car1.getNode().path!.boundingBox
//        let vehicleWidth1 = boundingBox1.size.width/2
//        let boundingBox2 = car2.getNode().path!.boundingBox
//        let vehicleWidth2 = boundingBox2.size.width/2
//        return car1.getXPos() - car2.getXPos() - Int(vehicleWidth1) - Int(vehicleWidth2)
        if let vehicle1 = car1 {
            if let vehicle2 = car2 {
                return absoluteValue(vehicle1.getXPos(), vehicle2.getXPos())
            } else {
                return 1000000
            }
        } else {
            return 1000000
        }
    }
    
    func calcYDistance(car1: Car?, car2: Car?) -> Int {
        //        let boundingBox1 = car1.getNode().path!.boundingBox
        //        let vehicleWidth1 = boundingBox1.size.width/2
        //        let boundingBox2 = car2.getNode().path!.boundingBox
        //        let vehicleWidth2 = boundingBox2.size.width/2
        //        return car1.getXPos() - car2.getXPos() - Int(vehicleWidth1) - Int(vehicleWidth2)
        if let vehicle1 = car1 {
            if let vehicle2 = car2 {
                return absoluteValue(vehicle1.getYPos(),vehicle2.getYPos())
            } else {
                return 1000000
            }
        } else {
            return 1000000
        }
    }
    
    func absoluteValue(_ a:Int, _ b:Int) -> Int {
        if (a>b) {
            return a-b
        } else {
            return b-a
        }
    }
    
    func absoluteValue(_ a:Int) -> Int {
        if (a>=0) {
            return a
        } else {
            return -a
        }
    }
    
    func speedModifier(distance:Int) -> Double {
        let minDistance = 50
        let highSpeedDistance = 230
        if distance <= minDistance {
            return 0
        } else if (distance <= highSpeedDistance) {
            return Double((distance - minDistance))/Double(highSpeedDistance-minDistance)
        }
        else {
            return 1
        }
    }
    
    func createCar(_ xPos:Int, _ yPos:Int, street: Street) {
        // let number = Int.random(in: -700 ... 300)
        let streetCarArray = street.getCars()
        let car = Car(x: xPos, y: yPos, street: street)
        
        //let car2 = car.getNode()
        
        //car2.name = "car"
        
        
        
            
        self.addChild(car.getNode())
        carArray.append(car)
        for vehicle in streetCarArray {
            if let car2 = car.getClosestCar() {
                if (street.getDirection() == 0 && car2.getXPos() < vehicle.getXPos() && car.getXPos() > vehicle.getXPos()) {
                    vehicle.setClosestCar(car: vehicle)
                }
                if (street.getDirection() == 1 && car2.getXPos() > vehicle.getXPos() && car.getXPos() < vehicle.getXPos()) {
                    vehicle.setClosestCar(car: vehicle)
                }
            }
        }
    }
    
    func createLight(_ xPos:Int, _ yPos:Int, street: Street) {
        let light = TrafficLight(x: xPos, y: yPos, location: street)
        self.addChild(light.getNode())
        lightArray.append(light)
        light.getNode().name = String(lightArray.count)
    }
    
    func createLight(trafficLight: TrafficLight) {
        let light = trafficLight
        self.addChild(light.getNode())
        lightArray.append(light)
        light.getNode().name = String(lightArray.count)
    }
    
    func intersectionCreator() {
        for horizontalStreet in streetArrayHorizontal {
            for verticalStreet in streetArrayVertical {
                let intersection = Intersection(street1: horizontalStreet, street2: verticalStreet)
                intersectionArray.append(intersection)
                for trafficLight in intersection.getAllLights() {
                    createLight(trafficLight: trafficLight)
                }
                print("LOOK BELOW")
                print(intersection.getPosition())
            }
        }
    }
    
    func isCarAtAnyIntersectionChecker(_ car: Car) -> Intersection? {
        for intersection in intersectionArray {
            if (intersection.isCarAtIntersection(car)) {
                return intersection
            }
        }
        return nil
    }
    
    
    func checkCollisions() {
        
        var hitCars: [Car] = []
            
            //var hitCars: [Car] = []
            //enumerateChildNodes(withName: "car") { node, _ in
              //  let car2 = node as! SKShapeNode
                //    if car2.frame.intersects(car2.frame){
                  //      hitCars.append(car2)
                    //    print("HIT")
            //}
            
        //}
        
        for i in 0...carArray.count-2{
            
            if (carArray[i].getXPos() > -100 && carArray[i].getXPos()<100 && carArray[i].getYPos() > -100 && carArray[i].getYPos()<100 && carArray[i].getIntersected() == false){
                
                for j in i+1...carArray.count-1{
                
                    
                    
                    if (carArray[i].getNode().frame.intersects(carArray[j].getNode().frame)){
                        
                        carArray[i].changeIntersected()
                        carArray[j].changeIntersected()
                        hitCars.append(carArray[j])
                        hitCars.append(carArray[i])
                        
                        gameOverScreen()
                }
                    
                    
            }
        }
            
        }
        
        if (hitCars.count>0){
            
            for i in 0...hitCars.count-1 {
                
                if (i%2==0) {
                
                    print("hit car")
            }
            
        }
            
        }
        
    }
    
    
    
    func gameOverScreen() {
        
        gameOverLabel.isHidden = false
        gameOverLabel.text = "Game Over!"
    }
    
    
    func getStreetToTurnOn (car: Car, intersection: Intersection) -> Street {
        if (car.getDirection() <= 1) {
            return intersection.getVerticalStreet()
        } else {
            return intersection.getHorizontalStreet()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        move()
        checkCollisions()
        
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
