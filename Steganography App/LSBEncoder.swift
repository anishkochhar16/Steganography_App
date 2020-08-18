//
//  LSBEncoder.swift
//  Steganography App
//
//  Created by Anish Kochhar on 17/08/2020.
//  Copyright © 2020 Anish Kochhar. All rights reserved.
//

import UIKit

class LSBEncoder {
    
    func changeLastTwoBits(pixelValue value: UInt8, bitsToHide: String) -> UInt8 {
        assert(bitsToHide.count == 2)
        var bin = String(value, radix: 2)
        for _ in 0 ..< (8-bin.count) {
            bin = "0" + bin
        }
        var newBin = bin[0..<6]
        newBin += bitsToHide
        
        let returnValue = UInt8(String(newBin), radix: 2)!
        return returnValue
    }
    
    func hideMessageLength(lengthInt: Int, imageData: inout [UInt8], _ bytesPerPixel: Int) {
        var length = String(lengthInt, radix: 2)
        for _ in 0 ..< (24-length.count) {
            length = "0" + length
        }
        var array = [String]()
        for i in stride(from: 1, to: length.count, by: 2) {
            let g = length[i-1...i]
            array.append(String(g))
        }
        for k in 0 ..< 4 {
            let offsetForPixel = k * bytesPerPixel
            let offsetForArray = k * 3
            let red = imageData[offsetForPixel]
            let redHidden = array[offsetForArray]
            let green = imageData[offsetForPixel + 1]
            let greenHidden = array[offsetForArray + 1]
            let blue = imageData[offsetForPixel + 2]
            let blueHidden = array[offsetForArray + 2]
            
            imageData[offsetForPixel] = changeLastTwoBits(pixelValue: red, bitsToHide: redHidden)
            imageData[offsetForPixel + 1] = changeLastTwoBits(pixelValue: green, bitsToHide: greenHidden)
            imageData[offsetForPixel + 2] = changeLastTwoBits(pixelValue: blue, bitsToHide: blueHidden)
            
            print(imageData[offsetForPixel], imageData[offsetForPixel + 1], imageData[offsetForPixel + 2])
            print(redHidden, greenHidden, blueHidden)
        }
    }
    
    func steganography(message: String, imageData: inout [UInt8], _ width: Int, _ height: Int, _ bytesPerPixel: Int, _ bytesPerRow: Int) {
        // In order to store the length of the following message, use a 24 bit number, stored using 2-bit LSB on the first 4 pixels (4 pixels * 3 channels * 2 bits = 24 bit number)
        let lengthInt = message.count
        hideMessageLength(lengthInt: lengthInt, imageData: &imageData, bytesPerPixel)
        print(imageData[0], imageData[1], imageData[2], imageData[4], imageData[5], imageData[6])
        var x = 4
        var y = 0
        var channel = 0
        for (_, bit) in message.enumerated() {
            let offset = (y * bytesPerRow) + (x * bytesPerPixel) + channel
            var pixel = imageData[offset]
            
            if pixel%2 != Int(String(bit))! {
                if pixel < 254 {
                    pixel += 1
                } else {
                    pixel -= 1
                }
            }
            
            imageData[offset] = pixel
//                print("(x:\(x), y:\(y)): \(pixel). Index: \(index), Bit: \(bit), Channel: \(channel)")
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
    }

    func convert(length: Int, pointer: UnsafePointer<UInt8>) -> [UInt8] {
        let buffer = UnsafeBufferPointer(start: pointer, count: length)
        return Array(buffer)
    }
    
    func encodeImage(image: UIImage, message: String) -> UIImage {
        // Convert UIImage to CGImage,convert that to CFData, and create the UnsafePointer for reading the data
        guard let cgImage = image.cgImage,
            let data = cgImage.dataProvider?.data,
            let bytes = CFDataGetBytePtr(data) else { fatalError("Could not get image data") }
        
        // Since the UnsafePointer is immutable, create an array of pixel values so I can write in the image.
        var arrayOfBytes = convert(length: CFDataGetLength(data), pointer: bytes)
        
        // Perform the steganography on the array of pixel data
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        let bytesPerRow = cgImage.bytesPerRow
        let width = cgImage.width
        let height = cgImage.height
        steganography(message: message, imageData: &arrayOfBytes, width, height, bytesPerPixel, bytesPerRow)
        
        // Convert back to a CGImage with a CGDataProvider
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rgbData = CFDataCreate(nil, arrayOfBytes, arrayOfBytes.count)!
//        print(arrayOfBytes.count)
        let provider = CGDataProvider(data: rgbData)!

        let bitsPerComponent = cgImage.bitsPerComponent
        let bitsPerPixel = cgImage.bitsPerPixel
        let shouldInteroplate = false
        let intent = cgImage.renderingIntent
        

        guard let throughCGImage = CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo, provider: provider, decode: nil, shouldInterpolate: shouldInteroplate, intent: intent)
            else { fatalError("Could not reform a CGImage") }
        
        let newImage = UIImage(cgImage: throughCGImage)
        
        // Clear the array from memory
        arrayOfBytes.removeAll()
        
        return newImage
    }
}
