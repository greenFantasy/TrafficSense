//
//  GameVC.swift
//  trafficSense
//
//  Created by Rajat Mittal on 6/19/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

class GameVC: UIViewController {
    
    @IBOutlet var gameView: SKView!
    
    @IBOutlet weak var gameViewSK: SKView!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        super.view.backgroundColor = UIColor.white
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                if let view = self.gameViewSK {
                    
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    
                    view.showsNodeCount = true
                }
                
            }
        }
        
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

