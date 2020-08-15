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
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = image {
            let newImage = encodeImage(image: image)
            
            self.imageView.image = newImage
        }
    }
    
    func encodeImage(image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage,
            let data = cgImage.dataProvider?.data,
            let bytes = CFDataGetBytePtr(data) else { fatalError("Could not get image data") }
        
        let imgDataProvider = CGDataProvider(data: data)
        
        let width = cgImage.width
        let height = cgImage.height
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let bitsPerPixel = cgImage.bitsPerPixel
        let colorSpace = cgImage.colorSpace
        let info = cgImage.bitmapInfo
//        var decode: CGFloat? = nil
        let shouldInteroplate = false
        let intent = cgImage.renderingIntent
        
        guard let colourSpace = colorSpace else { fatalError("Colour Space of input image was nil") }
        guard let throughCGImage = CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, space: colourSpace, bitmapInfo: info, provider: imgDataProvider!, decode: nil, shouldInterpolate: shouldInteroplate, intent: intent)
            else { fatalError("Could not reform a CGImage") }
        
        let newImage = UIImage(cgImage: throughCGImage)
        
        return newImage
    }
}
