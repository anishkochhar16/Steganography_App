//
//  LSBDecoder.swift
//  Steganography App
//
//  Created by Anish Kochhar on 18/08/2020.
//  Copyright © 2020 Anish Kochhar. All rights reserved.
//

import UIKit

class LSBDecoder {
    
    func getLastTwoBits(_ int: UInt8) -> String {
        var binaryPixelValue = String(int, radix: 2)
        for _ in 0 ..< (8-binaryPixelValue.count) {
            binaryPixelValue = "0" + binaryPixelValue
        }
        let lastTwoBits = binaryPixelValue[6...7]
        return String(lastTwoBits)
    }
    
    func getMessageLength(imageData: UnsafePointer<UInt8>, _ bytesPerPixel: Int) -> Int {
        var binaryLength = ""
        
        for k in 0 ..< 4 {
            let offsetForPixel = k * bytesPerPixel
            let red = imageData[offsetForPixel]
            let green = imageData[offsetForPixel + 1]
            let blue = imageData[offsetForPixel + 2]
            
            print(red, green, blue)
            
            binaryLength += getLastTwoBits(red)
            binaryLength += getLastTwoBits(green)
            binaryLength += getLastTwoBits(blue)
        }
        print(binaryLength)
        return Int(binaryLength, radix: 2)!
    }
    
    func decode(image: UIImage) -> String{
        // Convert UIImage to CGImage,convert that to CFData, and create the UnsafePointer for reading the data
        guard let cgImage = image.cgImage,
           let data = cgImage.dataProvider?.data,
           let bytes = CFDataGetBytePtr(data) else { fatalError("Could not get image data") }
        
        // Perform the steganography on the array of pixel data
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        let bytesPerRow = cgImage.bytesPerRow
        let width = cgImage.width
        
        let messageLength = getMessageLength(imageData: bytes, bytesPerPixel)
        print(messageLength)
        var message = ""
        
        var x = 4
        var y = 0
        var channel = 0
        for _ in 0 ..< messageLength {
            let offset = (y * bytesPerRow) + (x * bytesPerPixel) + channel
            let pixel = bytes[offset]
            
            message += String(pixel % 2)
//          CHECK THIS WORKS
            
            channel += 1
            if channel == 3 {
                channel = 0
                if x == width-1 {
                    x = 0
                    y += 1
                } else {
                    x += 1
                }
            }
        }
        return ""
    }
}
