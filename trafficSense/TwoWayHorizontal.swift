//
//  TwoWayHorizontal.swift
//  trafficSense
//
//  Created by Rajat Mittal on 7/4/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class TwoWayHorizontal {
    // contains two streets, one going left and another going right
    private var leftStreet:LeftStreet
    private var rightStreet:RightStreet
    private var midline:Int
    private var streetNode:SKSpriteNode
    
    init (midline: Int) {
        streetNode = SKSpriteNode(imageNamed: "streetImageHorizontal")
        streetNode.size = CGSize(width: 1600.0, height: 120.0)
        streetNode.zPosition = 0
        streetNode.position = CGPoint(x: 0, y: midline)
        self.midline = midline
        leftStreet = LeftStreet(streetPos: midline + 30)
        rightStreet = RightStreet(streetPos: midline - 30)
    }
    
    func getLeftStreet() -> LeftStreet {
        return leftStreet
    }
    
    func getRightStreet() -> RightStreet {
        return rightStreet
    }
    
    func getMidline() -> Int {
        return midline
    }
    
    func getNode() -> SKSpriteNode {
        return streetNode
    }
}
