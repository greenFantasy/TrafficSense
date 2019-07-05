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
    //private var car : SKShapeNode?
    private var spinnyNode : SKShapeNode?
    private var light : TrafficLight?
    private var line = SKShapeNode(rect: CGRect(x: 0, y: 300, width: 10, height: 200))
    private var carArray:[Car] = []
    private var lightArray:[TrafficLight] = []
    private var intersectionArray:[Intersection] = []
    private var streetArray:[StreetProtocol] = []
    private var twoWayHorizontalArray:[TwoWayHorizontal] = []
    private var twoWayVerticalArray:[TwoWayVertical] = []
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        let firstTwoWay = TwoWayHorizontal(midline: 100)
        twoWayHorizontalArray.append(firstTwoWay)
        createCar(-100, 100, leftStreet: firstTwoWay.getLeftStreet())
        createCar(-100, 100, leftStreet: firstTwoWay.getRightStreet())
        
        let secondTwoWay = TwoWayVertical(midline: 100)
        twoWayVerticalArray.append(secondTwoWay)
        createCar(100, -100, leftStreet: secondTwoWay.getDownStreet())
        createCar(100, -200, leftStreet: secondTwoWay.getUpStreet())
        
        let third = TwoWayVertical(midline: -300)
        twoWayVerticalArray.append(third)
        createCar(-300, -100, leftStreet: third.getDownStreet())
        createCar(-300, -200, leftStreet: third.getUpStreet())
        
        let fourth = TwoWayHorizontal(midline: -300)
        twoWayHorizontalArray.append(fourth)
        
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
                createCar(Int(self.scene!.size.width/2) + 100, vehicle.getYPos(), leftStreet: vehicle.getStreet())
                elementsToRemove.append(i)
                removeCar(vehicle)
                if (carArray.count < 25) {
                    //createCar(600, 0, street: firstStreet)
                }
            }
            else if (vehicle.getYPos() <= Int(-self.scene!.size.height/2) && vehicle.getDirection() == 2) {
                createCar(vehicle.getXPos(), Int(self.scene!.size.height/2), leftStreet: vehicle.getStreet())
                elementsToRemove.append(i)
                removeCar(vehicle)
                if (carArray.count < 25) {
                    //createCar(vehicle.getXPos(), 1000, leftStreet: vehicle.getStreet())
                }
            }
            else if (vehicle.getYPos() >= Int(self.scene!.size.height/2) && vehicle.getDirection() == 3) {
                createCar(vehicle.getXPos(), Int(-self.scene!.size.height/2), leftStreet: vehicle.getStreet())
                elementsToRemove.append(i)
                removeCar(vehicle)
                if (carArray.count < 25) {
                    //createCar(vehicle.getXPos(), -vehicle.getYPos() - 100, leftStreet: vehicle.getStreet())
                }
            }
            else if (vehicle.getXPos() >= Int(self.scene!.size.width/2) && vehicle.getDirection() == 1) {
                createCar(Int(-self.scene!.size.width/2), vehicle.getYPos(), leftStreet: vehicle.getStreet())
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
    
    func createCar(_ xPos:Int, _ yPos:Int, leftStreet: StreetProtocol) {
        // let number = Int.random(in: -700 ... 300)
        let streetCarArray = leftStreet.getCars()
        let car = Car(x: xPos, y: yPos, street: leftStreet)
        self.addChild(car.getNode())
        carArray.append(car)
        for vehicle in streetCarArray {
            if let car2 = car.getClosestCar() {
                if (leftStreet.getDirection() == 0 && car2.getXPos() < vehicle.getXPos() && car.getXPos() > vehicle.getXPos()) {
                    vehicle.setClosestCar(car: vehicle)
                }
                if (leftStreet.getDirection() == 1 && car2.getXPos() > vehicle.getXPos() && car.getXPos() < vehicle.getXPos()) {
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
        for horizontalTwoWay in twoWayHorizontalArray {
            for verticalTwoWay in twoWayVerticalArray {
                let intersection = Intersection(horizontal: horizontalTwoWay, vertical: verticalTwoWay)
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
                print(car.getPositionArray())
                return intersection
            }
        }
        return nil
    }
    
    func getStreetToTurnOn (car: Car, intersection: Intersection) -> StreetProtocol {
        let number = Int.random(in: 0 ... 1)
        if (car.getDirection() <= 1) {
            if number == 0 {
                return intersection.getVerticalTwoWay().getDownStreet()
            } else {
                return intersection.getVerticalTwoWay().getUpStreet()
            }
        } else {
            if number == 0 {
                return intersection.getHorizontalTwoWay().getLeftStreet()
            } else {
                return intersection.getHorizontalTwoWay().getRightStreet()
            }
        }
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
