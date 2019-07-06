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
    
    private var shapeNode = SKShapeNode(circleOfRadius: 40)
    private let topSpeed:Double = 5.0
    private var xPos:Int
    private var yPos:Int
    private var currentStreet:StreetProtocol
    private var closestCar: Car?
    private var intersectionArray:[Intersection] = [] // contains all intersections a car has turned at, a car cannot turn at the same intersection twice
    private var intersected = false
    
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
        xPos += xVel
        yPos += yVel
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
        
        intersected = !intersected
        
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
}
