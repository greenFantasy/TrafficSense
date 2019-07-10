//
//  Car.swift
//  trafficSense
//
//  Created by Rajat Mittal on 6/20/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit


class Car: SKShapeNode {  // Car implements SKShapeNode class
    
    private var shapeNode = SKShapeNode(rectOf: CGSize(width: 60, height: 40))
    private let topSpeed:Double = 5.0
    private var xPos:Int
    private var yPos:Int
    private var currentStreet:StreetProtocol
    private var closestCar: Car?
    private var intersectionArray:[Intersection] = [] // contains all intersections a car has turned at, a car cannot turn at the same intersection twice
    private var intersected = false
    private var turnArray:[Int] = [] // when 0, it's going to continue straight, when 1, the car will turn right, when 2, the car will turn left
    private var completedTurnsArray:[Bool] = []
    
    //private let finalDestination
    
    init (x: Int, y: Int, street: StreetProtocol, imageNamed: String) {
        xPos = x
        yPos = y
        shapeNode.fillColor = SKColor.orange
        currentStreet = street
        closestCar = nil
        super.init()
        shapeNode.strokeColor = UIColor.clear
        shapeNode.fillTexture = SKTexture.init(image: UIImage(named: imageNamed)!)  // Covers the shape with the texture (image) of the correct car based on imageName pass through
        currentStreet.addCar(car: self)
        updateShapeNodePos()
        fixPosOnStreet()
        updateTurnArray()
    }
    
    func fixPosOnStreet() {
        if (currentStreet.getDirection() <= 1) {
            yPos = currentStreet.getPosition()
        } else {
            xPos = currentStreet.getPosition()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {  // Required for SKShapeNode implementation
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateShapeNodePos() {
        shapeNode.position = getCGPoint()
    }
    
    func setNode(node: SKShapeNode) {
        shapeNode = node
    }
    
    func move(xVel:Int, yVel:Int) {
        //if (!intersected) {
        xPos += xVel
        yPos += yVel
        //}
        updateShapeNodePos()
    }
    
    func getDirection() -> Int {
        return currentStreet.getDirection()
    }
    
    func getClosestCar() -> Car? {
        return closestCar
    }
    
    func setClosestCar(car: Car) {
        closestCar = car
    }
    
    func clearClosestCar() {
        closestCar = nil
    }
    
    func setPos(newX: Int, newY: Int) {
        xPos = newX
        yPos = newY
        updateShapeNodePos()
    }
    
    func getMovingDirectionPosition() -> Int {
        if (getDirection() == 0 || getDirection() == 1) {
            return getXPos()
        } else {
            return getYPos()
        }
    }
    
    func getNode() -> SKShapeNode
    {
        return shapeNode
    }
    
    func getTopSpeed() -> Double {
        return topSpeed
    }
    
    func getXPos() -> Int {
        return xPos
    }
    
    func getYPos() -> Int {
        return yPos
    }
    
    func getCGPoint() -> CGPoint {
        return CGPoint(x: xPos, y:yPos)
    }
    
    func getPositionArray() -> [Int] {
        return [xPos,yPos]
    }
    
    func getStreet() -> StreetProtocol {
        return currentStreet
    }
    
    func findLight() -> TrafficLight {
        return currentStreet.lightFinder(car: self)
    }
    
    func directionToVector() -> [Int] {
        switch currentStreet.getDirection() {
        case 0:
            return [-1,0]
        case 1:
            return [1,0]
        case 2:
            return [0,-1]
        case 3:
            return [0,1]
        default:
            return [0,0]
        }
    }
    
    func getIntersected() -> Bool {
        return intersected
    }
    
    func changeIntersected(){
        intersected = true
    }
    
    func isAtIntersection (intersection: Intersection) -> Bool {
        return intersection.isCarAtIntersection(self)
    }
    
    func turn(streetToTurnOn: StreetProtocol, intersection: Intersection) {
        let number = Int.random(in: 0 ... 2)
        var used = false
        for usedIntersection in intersectionArray {
            if (usedIntersection === intersection) {
                used = true
            }
        }
        if (number == 0 && !used) {
            currentStreet.removeCar(car: self)
            currentStreet = streetToTurnOn
            streetToTurnOn.addCar(car: self)
            intersectionArray.append(intersection)
            fixPosOnStreet()
        }
    }
    
    func makeRightTurn(intersection: Intersection) {
        if completedTurnsArray[intersectionArray.count - 1] == false {
            currentStreet.removeCar(car: self)
            let direction = currentStreet.getDirection()
            if direction == 0 {
                currentStreet = intersection.getVerticalTwoWay().getUpStreet()
            } else if (direction == 1) {
                currentStreet = intersection.getVerticalTwoWay().getDownStreet()
            } else if direction == 2 {
                currentStreet = intersection.getHorizontalTwoWay().getLeftStreet()
            } else if direction == 3 {
                currentStreet = intersection.getHorizontalTwoWay().getRightStreet()
            }
            currentStreet.addCar(car: self)
            fixPosOnStreet()
            completedTurnsArray[intersectionArray.count - 1] = true
        }
    }
    
    func makeLeftTurn(intersection: Intersection) {
        if !isLastTurnCompleted() {
            let oppStreet = intersection.getOppositeStreet(street: currentStreet)
            let direction = currentStreet.getDirection()
            if direction == 0 {
                if let closeCar = oppStreet.isStreetFree(startingPos: intersection.getPosition()[0] + 10, endingPos: intersection.getPosition()[0] - 100) {
                    if closeCar.getLastTurn() == 2 && !closeCar.isLastTurnCompleted() {
                        leftTurner(direction: direction, intersection: intersection)
                    }
                } else {
                    leftTurner(direction: direction, intersection: intersection)
                }
            } else if (direction == 1) {
                if let closeCar = oppStreet.isStreetFree(startingPos: intersection.getPosition()[0] - 10, endingPos: intersection.getPosition()[0] + 100) {
                    if closeCar.getLastTurn() == 2 && !closeCar.isLastTurnCompleted() {
                        leftTurner(direction: direction, intersection: intersection)
                    }
                } else {
                    leftTurner(direction: direction, intersection: intersection)
                }
            } else if direction == 2 {
                if let closeCar = oppStreet.isStreetFree(startingPos: intersection.getPosition()[0] + 10, endingPos: intersection.getPosition()[0] - 100) {
                    if closeCar.getLastTurn() == 2 && !closeCar.isLastTurnCompleted() {
                        leftTurner(direction: direction, intersection: intersection)
                    }
                } else {
                    leftTurner(direction: direction, intersection: intersection)
                }
            } else if direction == 3 {
                if let closeCar = oppStreet.isStreetFree(startingPos: intersection.getPosition()[0] - 10, endingPos: intersection.getPosition()[0] + 100) {
                    if closeCar.getLastTurn() == 2 && !closeCar.isLastTurnCompleted() {
                        leftTurner(direction: direction, intersection: intersection)
                    }
                } else {
                    leftTurner(direction: direction, intersection: intersection)
                }
            }
        }
    }
    
    func updateTurnArray() {
        if (currentStreet.getDirection() == 0) {
            for _ in 0...20 {
                var number = Int.random(in: -1 ... 10)
                if number <= 0 {
                    number = 0
                } else if number > 2 {
                    number = 2
                }
                turnArray.append(number)
                completedTurnsArray.append(number == 0)
            }
        } else {
            for _ in 0...20 {
                var number = Int.random(in: -3 ... 2)
                if number <= 0 {
                    number = 0
                }
                turnArray.append(number)
                completedTurnsArray.append(number == 0)
            }
        }
    }
    
    func getTurn(index: Int) -> Int {
        return turnArray[index]
    }
    
    func getLastTurn() -> Int {
        if (intersectionArray.count == 0) {
            return turnArray[0]
        } else {
            return turnArray[intersectionArray.count - 1]
        }
    }
    
    func isLastTurnCompleted() -> Bool {
        if (intersectionArray.count == 0) {
            return completedTurnsArray[0]
        } else {
            return completedTurnsArray[intersectionArray.count - 1]
        }
    }
    
    func addToIntersectionArray(intersection: Intersection) -> Bool {
        // returns true if this is the first time the car has approached this intersection, false otherwise
        var contains = false
        for intersect in intersectionArray {
            if intersect === intersection {
                contains = true
            }
        }
        if (!contains) {
            intersectionArray.append(intersection)
        }
        return !contains
    }
    
    func leftTurner(direction: Int, intersection: Intersection) {
        currentStreet.removeCar(car: self)
        if (direction == 0) {
            currentStreet = intersection.getVerticalTwoWay().getDownStreet()
        } else if (direction == 1) {
            currentStreet = intersection.getVerticalTwoWay().getUpStreet()
        } else if (direction == 2) {
            currentStreet = intersection.getHorizontalTwoWay().getRightStreet()
        } else if (direction == 3) {
            currentStreet = intersection.getHorizontalTwoWay().getLeftStreet()
        }
        currentStreet.addCar(car: self)
        fixPosOnStreet()
        completedTurnsArray[intersectionArray.count - 1] = true
    }
}
