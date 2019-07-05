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
        street = Street(heightWidth: -100000, direction: 0)
        state = -2 // if state == -2, then the light will not be added to the scene
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
    
}
