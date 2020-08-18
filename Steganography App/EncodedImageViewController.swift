//
//  EncodedImageViewController.swift
//  Steganography App
//
//  Created by Anish Kochhar on 15/08/2020.
//  Copyright © 2020 Anish Kochhar. All rights reserved.
//

import UIKit

class EncodedImageViewController: UIViewController {

    var image: UIImage?
    var messageString: String = ""
    var messageBinary: String = ""
    let decoder = UTF8_Decoder()
    let lsbEncoder = LSBEncoder()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if image == nil { fatalError("There was no image!") }
        
        messageBinary = decoder.stringToUTF8Stream(string: messageString)
        
        changeButtons()
        
        if !isPossible(message: messageBinary, image: image!) { print("Message too long, force them to return") }
        
        DispatchQueue.global(qos: .background).async {
            let newImage = self.lsbEncoder.encodeImage(image: self.image!, message: self.messageBinary)
            
            DispatchQueue.main.async {
                self.imageView.image = newImage
            }
        }
    }
    

    func isPossible(message: String, image: UIImage) -> Bool {
        guard let cgImage = image.cgImage else { fatalError("Could not convert UIImage to CGImage") }
        let height = cgImage.height
        let width = cgImage.width
        // i.e. R, G and B
        let channels = 3
        let maxCapacity = height * width * channels  // 1 bit per channel per pixel
        let messageLength = message.count
        if maxCapacity < messageLength {
            print("The message is too long")
            // Do something
            return false
        }
        return true
    }
    
    @IBAction func save(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        print("saved")
    }
    
    @IBAction func share(_ sender: Any) {
        let ac = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    
    func changeButtons() {
        doneButton.backgroundColor = .clear
        doneButton.layer.cornerRadius = 5
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blur.frame = doneButton.bounds
        blur.isUserInteractionEnabled = false
        blur.layer.cornerRadius = 5
        blur.clipsToBounds = true
        doneButton.addSubview(blur)
        doneButton.layer.shadowOpacity = 0.4
        doneButton.layer.shadowOffset = CGSize(width: 3, height: 1)
        doneButton.layer.shadowRadius = 5

    }
    
}
