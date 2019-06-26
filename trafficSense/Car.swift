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


class Car {
    
    private var shapeNode = SKShapeNode(circleOfRadius: 20)
    private let topSpeed = 5
    private var xPos:Int
    private var yPos:Int
    private var currentStreet:Street
    //private var closestCar: Car?
    
    //private let finalDestination
    
    init (x: Int, y: Int, street: Street) {
        xPos = x
        yPos = y
        shapeNode.fillColor = SKColor.orange
        currentStreet = street
        //closestCar = nil
        currentStreet.addCar(car: self)
        updateShapeNodePos()
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
    
    func setPos(newX: Int, newY: Int) {
        xPos = newX
        yPos = newY
        updateShapeNodePos()
    }
    
    func getNode() -> SKShapeNode
    {
        return shapeNode
    }
    
    func getTopSpeed() -> Int {
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
    
    func getStreet() -> Street {
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
}
