//
//  ViewController.swift
//  Coala
//
//  Created by nidangkun on 2017/9/8.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

import UIKit

import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        
        skView.showsNodeCount = true
        skView.showsFPS = true
        
        let startScene = StartScene.init(size: skView.bounds.size)
        
        skView.presentScene(startScene)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

