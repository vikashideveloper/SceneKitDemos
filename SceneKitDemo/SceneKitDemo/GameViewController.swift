//
//  GameViewController.swift
//  SceneKitDemo
//
//  Created by Vikash Kumar on 16/05/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    @IBOutlet var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    var spawnTime: TimeInterval = 0
    
    var game = GameHelper.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewAndScene()
        setupCamera()
        //spawnShape()
        setupHud()
    }
    
    func setupViewAndScene() {
        scnView.allowsCameraControl = false
        scnView.showsStatistics = true
        scnView.autoenablesDefaultLighting = true
        scnView.delegate = self
        scnScene = SCNScene()
        scnView.scene = scnScene
        scnView.isPlaying = true
        scnScene.background.contents = "art.scnassets/Textures/Background_Diffuse.png"
    }
    
    func setupCamera() {
    
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 10)
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func spawnShape() {
        var geometry: SCNGeometry
        
        switch ShapeType.random() {
        case .Box :
            geometry =  SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)

        case .Pyramid :
            geometry = SCNPyramid(width: 1, height: 1, length: 1)
        case .Capsule :
            geometry = SCNCapsule(capRadius: 0.5, height: 5)
        case .Cylinder :
            geometry = SCNCylinder(radius: 0.5, height: 1)
        case .Sphere :
            geometry = SCNSphere(radius: 1)
        case .Cone :
            geometry = SCNCone(topRadius: 0, bottomRadius: 1, height: 1.5)
        case .Torus :
            geometry = SCNTorus(ringRadius: 1, pipeRadius: 0.3)
        case .Tube :
            geometry = SCNTube(innerRadius: 0.5, outerRadius: 1.0, height: 2)
        }
        
        let color = UIColor.random()
        geometry.materials.first?.diffuse.contents = color
    
        let traitEmitter = createTrail(color, geometry: geometry)
        
        let geoNode = SCNNode(geometry: geometry)
        
        geoNode.name = color == UIColor.black ? "Bad" : "Good"

        geoNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        geoNode.addParticleSystem(traitEmitter)
        
        let randomX = Float.random(min: -3, max: 3)
        let randomY = Float.random(min: 10, max: 18)
        
        let force = SCNVector3(x: randomX, y: randomY, z: 0)
        let position = SCNVector3(x: 0, y: 0, z: 0)

        geoNode.physicsBody?.applyForce(force, at: position, asImpulse: true)
        scnScene.rootNode.addChildNode(geoNode)
    }
    
    func cleanTheScene() {
        for node in scnScene.rootNode.childNodes {
            if node.position.y < -2 {
                node.removeFromParentNode()
            }
        }
    }
    
    func createTrail(_ color: UIColor, geometry: SCNGeometry)-> SCNParticleSystem {
        let trail = SCNParticleSystem(named: "Trail.scnp", inDirectory: nil)!
        
        trail.particleColor = color
        trail.emitterShape = geometry
        
        return trail
    }
    
    
    func setupHud() {
        game.hudNode.position = SCNVector3(x: 0, y: 10, z: 0)
        scnScene.rootNode.addChildNode(game.hudNode)
    }
    //
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

    //IBActions
    @IBAction func changeShapeAction(_ sender: Any) {
        
    }
    
    
    func touchHandler(for node: SCNNode) {
        if node.name == "Good" {
            game.score += 1
            node.removeFromParentNode()
            
        } else if node.name == "Bad" {
            game.lives -= 1
            node.removeFromParentNode()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            let touch = touches.first!
        let location = touch.location(in: scnView)
        let hitResult = scnView.hitTest(location, options: nil)
        
        if hitResult.count > 0 {
            let result = hitResult.first!
            let node = result.node
            touchHandler(for: node)
            
            createExplotion(geomety: node.geometry!, postion: node.presentation.position, rotation: node.presentation.rotation)
        }
    }
    
    
    func createExplotion(geomety: SCNGeometry, postion: SCNVector3, rotation : SCNVector4) {
        let explotion = SCNParticleSystem(named: "Exploded.scnp", inDirectory: nil)!
        
        explotion.emitterShape = geomety
        explotion.birthLocation = .surface
        
        let rotationMatrix = SCNMatrix4MakeRotation(rotation.w, rotation.x, rotation.y, rotation.z)
        let translationMatrix = SCNMatrix4MakeTranslation(postion.x, postion.y, postion.z)
        
        let transformMatrix = SCNMatrix4Mult(rotationMatrix, translationMatrix)
        
        scnScene.addParticleSystem(explotion, transform: transformMatrix)
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > spawnTime {
            spawnShape()
            spawnTime = time + TimeInterval(Float.random(min: 0.2, max: 1.5))
        }
        game.updateHUD()
        cleanTheScene()
    }
}
