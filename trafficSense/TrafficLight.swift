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
    private var lightSwitched = false
    private var xPos:Int
    private var yPos:Int
    private var shapeNode = SKShapeNode(circleOfRadius: 30)
    private var state:Int = -1
    private var street:StreetProtocol
    private var radius = 30
    private var intersection:Intersection?
    private var timer:Timer?  // Creates optional of type Timer
    private var timeLeft = 3  //Variable used in timer for setting amount of time left
    
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
        shapeNode.zPosition = 50
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
        if state == -1 {
            state = 1
            updateLight()
        }
        else if state == 1 {
            state = 0
            updateLight()
            timeLeft = 2
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
            
            /*  The timer above is now initialized using a few key properties: the timeInterval is the interval in which the timer will update, target is where the timer will be applied, selector specifies a function to run when the timer updates based on the time interval, userInfo can supply information to the selector function, and repeats allows the timer to run continuously until invalidated.
            */
        }
//        if (state > -1) {
//            state -= 2
//        } else if (state == -1) {
//            state = 1
//        }
    }
    
    /*  The function below is visible in objective-c since the selector is an obj-c concept. The timeLeft variable is deprecated by 1 referencing one second passing. The label is updated, and once the timeLeft variable reaches 0, the timer is invalidated and the label is updated to reflect the game being over.
     */
    @objc func onTimerFires() {
        timeLeft -= 1
        
        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            state = -1
            updateLight()
        }
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
