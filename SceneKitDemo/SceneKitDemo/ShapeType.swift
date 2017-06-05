//
//  ShapeType.swift
//  SceneKitDemo
//
//  Created by Vikash Kumar on 16/05/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import Foundation


enum ShapeType: Int {
    case  Box = 0, Sphere, Pyramid, Torus, Capsule, Cylinder, Cone, Tube
    
    static func random() -> ShapeType {
        let maxValue = Tube.rawValue
        let rand = arc4random_uniform(UInt32(maxValue+1))
        return ShapeType(rawValue: Int(rand))!
    }

}
