//
//  GameViewController.swift
//  ScenekitDemo3
//
//  Created by Vikash Kumar on 18/05/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        scene.background.contents = UIImage(named: "forest_background")
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 30, z: -10)
        cameraNode.eulerAngles = SCNVector3(x: Float(-M_PI/2), y: 0, z: 0)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        
        let lookAt = SCNLookAtConstraint(target: ship)
        
        cameraNode.constraints = [lookAt]
        // animate the 3d object
        let rotate = SCNAction.run {_ in
            let rotateMatrix = SCNMatrix4MakeRotation(GLKMathDegreesToRadians(180), 0, 1, 0)

            SCNTransaction.begin()
            SCNTransaction.animationDuration = 3.0
            
            let transform = rotateMatrix
            ship.transform = transform
            SCNTransaction.commit()

            
        }
        
        let rotateTop = SCNAction.run {_ in
            SCNMatrix4MakeRotation(GLKMathDegreesToRadians(45), 1, 0, 0)
            var rotateMatrix = ship.transform
            rotateMatrix.m11 = GLKMathDegreesToRadians(45)
//            
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 3.0
//            
//            let transform = rotateMatrix
//            ship.transform = transform
//            SCNTransaction.commit()
            
            
        }

        
        let move = SCNAction.move(to: SCNVector3(x: 0, y: 0, z: -90), duration: 5)
        ship.runAction(SCNAction.sequence([rotate, SCNAction.wait(duration: 3.0), rotateTop,SCNAction.wait(duration: 3.0), move]))
        
        //ship.runAction(SCNAction.sequence([rotateTop, move]))
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.green
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
