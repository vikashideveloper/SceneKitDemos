//
//  GameViewController.swift
//  SceneKitDemo2
//
//  Created by Vikash Kumar on 17/05/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var scene: SCNScene!
    var scnView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scnView = self.view as! SCNView
        scnView.backgroundColor = UIColor.white
        scene = SCNScene()
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        scene.rootNode.addChildNode(cameraNode)
        
        let sphereGeomatry = SCNSphere(radius: 1.0)
        
        let sphereNode = SCNNode(geometry: sphereGeomatry)
        scene.rootNode.addChildNode(sphereNode)
        sphereNode.name = "sphereNode"
        scnView.scene = scene
        //scnView.autoenablesDefaultLighting = true
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.color = UIColor.red
        lightNode.light!.type = .spot
        lightNode.light?.castsShadow = true
        lightNode.position = SCNVector3(x: 0, y: 0, z: 50)
        lightNode.name = "lightNode"
        
        let lookAt = SCNLookAtConstraint(target: sphereNode)
        lightNode.constraints = [lookAt]
        scene.rootNode.addChildNode(lightNode)
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let sphereNode = scene.rootNode.childNode(withName: "sphereNode", recursively: true) {
            sphereNode.setValue(5.0, forKey: "twistFactor")

            let twist = CABasicAnimation(keyPath: "twistFactor")
            twist.fromValue = 5
            twist.toValue   = 0
            twist.duration  = 2.0
            
            sphereNode.addAnimation(twist, forKey: "Twist the torus")
        }
//        if let lightNode = scene.rootNode.childNode(withName: "lightNode", recursively: true) {
//            let move = CABasicAnimation(keyPath: "position.z")
//            move.byValue  = -50
//            move.duration = 10.0
//            move.repeatCount = Float.infinity
//            lightNode.addAnimation(move, forKey: "slide right")
//
//            let move2 = CABasicAnimation(keyPath: "position.y")
//            move2.byValue  = 200
//            move2.duration = 10.0
//            move2.repeatCount = Float.infinity
//
//            lightNode.addAnimation(move2, forKey: "slide right")
//
//        }
        
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
