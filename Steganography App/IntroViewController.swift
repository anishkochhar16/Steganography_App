//
//  ViewController.swift
//  Steganography App
//
//  Created by Anish Kochhar on 13/08/2020.
//  Copyright © 2020 Anish Kochhar. All rights reserved.
//

import UIKit
import EAIntroView

class IntroViewController: UIViewController, EAIntroDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        introPages()
    }
    
    func introPages(){
        let page = EAIntroPage()
        page.title = "WELCOME"
        page.titleFont = UIFont.systemFont(ofSize: 24)
        page.titlePositionY = view.frame.maxX
        page.desc = "Welcome to Steganography App, providing you functionaility to hide data within your own images and extract data from others sent to you."
        page.descFont = UIFont.systemFont(ofSize: 13)
        page.descPositionY = view.frame.minX + 200
        
        let page2 = EAIntroPage()
        page2.title = "Encode or Decode"
        page2.titlePositionY = view.frame.maxX
        page2.desc = "Choose which method you would like to try first, and then give it a try."
        page2.descFont = UIFont.systemFont(ofSize: 12)
        page2.descPositionY = view.frame.minX + 200
        
        let intro = EAIntroView(frame: view.frame, andPages: [page, page2])
        
        intro?.delegate = self
        intro?.pageControlY = 60
        intro?.tapToNext = true
        
        intro?.backgroundColor = UIColor(red: 0.0, green: 0.49, blue: 0.96, alpha: 1.0) //iOS7 dark blue
        intro?.show(in: view, animateDuration: 0.3)
        
    }
    
}

