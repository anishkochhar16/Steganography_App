//
//  UTF-8_Decoder.swift
//  Steganography App
//
//  Created by Anish Kochhar on 17/08/2020.
//  Copyright © 2020 Anish Kochhar. All rights reserved.
//

import Foundation

// Converts Strings into streams of UTF8 and vice versa.
class UTF8_Decoder {
    
    func decodeUInt8(bytes: Array<UInt8>) -> String {
        // The String to be returned
        var decodedString = ""
        // Initialize decoder
        var decoder = Unicode.UTF8()
        // Make the array conform to IteratorProtocol
        var iterator = bytes.makeIterator()
        var finished: Bool = false
        repeat {
            let decodingResult = decoder.decode(&iterator)
            switch decodingResult {
            // A Unicode.Scalar is a single character's Unicode Scalar (e.g. +9992)
            case .scalarValue(let char):
                decodedString.append(Character(Unicode.Scalar(char)))
            case .emptyInput:
              finished = true
            /* ignore errors and unexpected values */
            case .error:
              finished = true
            }
        } while (!finished)
        return decodedString
    }

    func stringToUTF8Stream(string: String) -> String {
        let binaryData = Data(string.utf8)
        let string01 = binaryData.reduce("") { (acc, byte) -> String in
            var str = String(byte, radix: 2)
            // Pad with zeroes
            for _ in 0..<(8-str.count) {
                str = "0" + str
            }
            // Could add spaces here to make for readable, but for the steganography need a stream of bits
            return acc + str
        }
        return string01
    }

    func UTF8StreamToUInt8(data: String) -> [UInt8] {
        var arr = [UInt8]()
        let characters = Array(data)
        var bytes = [String]()
        // Split the stream into bytes
        stride(from: 0, to: characters.count, by: 8).forEach {
            bytes.append(String(characters[$0..<$0+8]))
        }
        // Turn byte from binary to UInt8
        for byte in bytes {
            arr.append(UInt8(byte, radix: 2)!)
        }
        return arr
    }

}

