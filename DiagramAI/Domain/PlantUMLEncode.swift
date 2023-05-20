//
//  PlantUMLEncode.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 07/05/23.
//

import Foundation
import Compression

struct PlantUMLEncode {

    func encode6bit(_ b: UInt8) -> Character {
        let characters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_"
        return characters[Int(b & 0x3F)]
    }

    func encode3bytes(_ b1: UInt8, _ b2: UInt8, _ b3: UInt8) -> String {
        let c1 = encode6bit(b1 >> 2)
        let c2 = encode6bit(((b1 & 0x3) << 4) | (b2 >> 4))
        let c3 = encode6bit(((b2 & 0xF) << 2) | (b3 >> 6))
        let c4 = encode6bit(b3 & 0x3F)
        return String([c1, c2, c3, c4])
    }

    func compressAndEncode(_ string: String) -> String {
        let inputData = Data(string.utf8)
        let bufferSize = 1024
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        let compressedData = inputData.withUnsafeBytes { (inputPointer: UnsafeRawBufferPointer) -> Data in
            let boundPointer = inputPointer.bindMemory(to: UInt8.self)
            let inputBuffer = UnsafeBufferPointer(start: boundPointer.baseAddress, count: inputData.count)
            let outputBuffer = UnsafeMutableBufferPointer(start: &buffer, count: bufferSize)
            let compressedSize = compression_encode_buffer(outputBuffer.baseAddress!, outputBuffer.count, inputBuffer.baseAddress!, inputBuffer.count, nil, COMPRESSION_ZLIB)
            return Data(bytes: outputBuffer.baseAddress!, count: compressedSize)
        }

        var encodedString = ""
        var i = 0
        while i < compressedData.count {
            let b1 = compressedData[i]
            let b2 = i + 1 < compressedData.count ? compressedData[i + 1] : UInt8(0)
            let b3 = i + 2 < compressedData.count ? compressedData[i + 2] : UInt8(0)
            encodedString += encode3bytes(b1, b2, b3)
            i += 3
        }

        return encodedString
    }

}

extension String {
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

