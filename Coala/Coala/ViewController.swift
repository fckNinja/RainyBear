//
//  ViewController.swift
//  Coala
//
//  Created by nidangkun on 2017/9/8.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

import UIKit

import SpriteKit

import AVFoundation

class ViewController: UIViewController {
    
    var bgMusic : AVAudioPlayer!
    
    let defaultUser = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        self.playBGM()
        let skView = self.view as! SKView
        if skView.scene == nil {
            skView.showsNodeCount = true
            skView.showsFPS = true
            
            let startScene = StartScene.init(size: skView.bounds.size)
            
            skView.presentScene(startScene)
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playBGM(){
        if defaultUser.object(forKey: Sound) == nil{
            defaultUser.setValue(true, forKey: Sound)
        }
        
        
        let filePath = Bundle.main.url(forResource: "bgm", withExtension: "m4a")
        
        do{
            try bgMusic = AVAudioPlayer.init(contentsOf: filePath!)
        }catch{
            
        }
        
        bgMusic.numberOfLoops = -1
        bgMusic.prepareToPlay()
        
        
        let defaultValue = defaultUser.object(forKey: Sound) as! Bool
        
        if defaultValue == true{
            
            bgMusic.play()
            
        }
    }


}

