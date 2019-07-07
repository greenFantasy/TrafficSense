//
//  TrafficLight.swift
//  trafficSense
//
//  Created by Rajat Mittal on 6/20/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class TrafficLight {
    
    private var xPos:Int
    private var yPos:Int
    private var shapeNode = SKShapeNode(circleOfRadius: 30)
    private var state:Int = -1
    private var street:StreetProtocol
    private var radius = 30
    private var intersection:Intersection?
    
    init (x:Int, y:Int, location: StreetProtocol) {
        xPos = x
        yPos = y
        street = location
        street.addLight(trafficLight: self)
        updateShapeNode()
    }
    
    init(fakeLight: Int) {
        xPos = -100000
        yPos = -100000
        street = LeftStreet(streetPos: -10000000)
        state = -2 // if state == -2, then the light will not be added to the scene
    }
    
    func getRadius() -> Int {
        return radius
    }
    
    func getXPos() -> Int {
        return xPos
    }
    
    func getYPos() -> Int {
        return yPos
    }
    
    func isRed() -> Bool {
        return state == -1
    }
    
    func updateShapeNode() {
        shapeNode.position = getCGPoint()
        shapeNode.fillColor = getColor()
    }
    
    func updateLight() {
        shapeNode.fillColor = getColor()
    }
    
    func getNode() -> SKShapeNode
    {
        return shapeNode
    }
    
    func getCGPoint() -> CGPoint {
        return CGPoint(x: xPos, y:yPos)
    }
    
    func getState() -> Int {
        return state
    }
    
    func changeState () {
        // changes between green (1) and red (-1), eventually yellow will be 0
        if (state > -1) {
            state -= 2
        } else if (state == -1) {
            state = 1
        }
        updateLight()
    }
    
    func getColor() -> SKColor {
        if (state == 0) {
            return SKColor.yellow
        }
        else if (state == 1) {
            return SKColor.green
        }
        else {
            return SKColor.red
        }
    }
    
    func getIntersection() -> Intersection {
        if let inter = intersection {
            return inter
        } else {
            return Intersection(horizontal: TwoWayHorizontal(midline: -10000), vertical: TwoWayVertical(midline: -100000))
        }
    }
    
    func setIntersection(intersection: Intersection) {
        self.intersection = intersection
    }
}
