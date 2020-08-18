//
//  DecodedImageViewController.swift
//  Steganography App
//
//  Created by Anish Kochhar on 18/08/2020.
//  Copyright © 2020 Anish Kochhar. All rights reserved.
//

import UIKit

class DecodedImageViewController: UIViewController {
    
    let decoder = LSBDecoder()
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if image == nil { fatalError("There was no image!") }

        DispatchQueue.global(qos: .background).async {
            let message = self.decoder.decode(image: self.image!)
            
            print(message)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
