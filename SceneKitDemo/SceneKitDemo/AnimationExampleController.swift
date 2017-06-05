//
//  AnimationExampleController.swift
//  SceneKitDemo
//
//  Created by Vikash Kumar on 17/05/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import SceneKit

class AnimationExampleController: UIViewController {

    var scnView: SCNView!
    var scnScene: SCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupView() {
        scnView = self.view as! SCNView
        scnScene = SCNScene()
        scnView.scene = scnScene
    }

}
