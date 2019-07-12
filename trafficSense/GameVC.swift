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
    
    @IBOutlet var viewScreen: UIView!
    @IBOutlet weak var gameOverLabel: UILabel!
    
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
                    editGameOverScreen(scene: sceneNode)
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    
                    view.showsNodeCount = true
                }
                
            }
        }
        
        
    }
    
    func editGameOverScreen(scene: GameScene){
        let gameOverLabel = UILabel(frame: CGRect(x: scene.size.width/4, y: scene.size.height/4, width: 1000, height: 50))
        print(scene.size.width/2)
        print(scene.size.height/2)
        let endView = UIView(frame: view.frame)
        endView.addSubview(gameOverLabel)
        gameOverLabel.isHidden = false
        gameOverLabel.text = "Game Over!"
        gameOverLabel.font = UIFont(name: "Times New Roman", size: 70)
        
        gameOverLabel.textColor = UIColor.red
        scene.setView(endView: endView)
        viewScreen.addSubview(endView)
        endView.isHidden = true
        endView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        
        
        
        
    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

