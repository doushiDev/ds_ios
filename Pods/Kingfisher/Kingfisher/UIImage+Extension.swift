//
//  UIImage+Decode.swift
//  Kingfisher
//
//  Created by Wei Wang on 15/4/7.
//
//  Copyright (c) 2015 Wei Wang <onevcat@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit
import ImageIO
import MobileCoreServices

private let pngHeader: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
private let jpgHeaderSOI: [UInt8] = [0xFF, 0xD8]
private let jpgHeaderIF: [UInt8] = [0xFF]
private let gifHeader: [UInt8] = [0x47, 0x49, 0x46]

// MARK: - Image format
enum ImageFormat {
    case unknown, png, jpeg, gif
}

extension Data {
    var kf_imageFormat: ImageFormat {
        var buffer = [UInt8](repeating: 0, count: 8)
        (self as NSData).getBytes(&buffer, length: 8)
        if buffer == pngHeader {
            return .png
        } else if buffer[0] == jpgHeaderSOI[0] &&
            buffer[1] == jpgHeaderSOI[1] &&
            buffer[2] == jpgHeaderIF[0]
        {
            return .jpeg
        } else if buffer[0] == gifHeader[0] &&
            buffer[1] == gifHeader[1] &&
            buffer[2] == gifHeader[2]
        {
            return .gif
        }
        
        return .unknown
    }
}

// MARK: - Decode
extension UIImage {
    func kf_decodedImage() -> UIImage? {
        return self.kf_decodedImage(scale: self.scale)
    }
    
    func kf_decodedImage(scale: CGFloat) -> UIImage? {
        // prevent animated image (GIF) lose it's images
        if images != nil {
            return self
        }

        let imageRef = self.cgImage
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue).rawValue
        let contextHolder: UnsafeMutableRawPointer = nil
        let context = CGContext(data: contextHolder, width: imageRef!.width, height: imageRef!.height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo)
        if let context = context {
            let rect = CGRect(x: 0, y: 0, width: imageRef!.width, height: imageRef!.height)
            context.draw(imageRef!, in: rect)
            let decompressedImageRef = context.makeImage()
            return UIImage(cgImage: decompressedImageRef!, scale: scale, orientation: self.imageOrientation)
        } else {
            return nil
        }
    }
}

// MARK: - Normalization
extension UIImage {
    public func kf_normalizedImage() -> UIImage {
        // prevent animated image (GIF) lose it's images
        if images != nil {
            return self
        }
        
        if imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage!
    }
}

// MARK: - Create images from data
extension UIImage {
    static func kf_imageWithData(_ data: Data, scale: CGFloat) -> UIImage? {
        var image: UIImage?
        switch data.kf_imageFormat {
        case .jpeg: image = UIImage(data: data, scale: scale)
        case .png: image = UIImage(data: data, scale: scale)
        case .gif: image = UIImage.kf_animatedImageWithGIFData(gifData: data, scale: scale, duration: 0.0)
        case .unknown: image = nil
        }
        return image
    }
}

// MARK: - GIF
func UIImageGIFRepresentation(_ image: UIImage) -> Data? {
    return UIImageGIFRepresentation(image, duration: 0.0, repeatCount: 0)
}

func UIImageGIFRepresentation(_ image: UIImage, duration: TimeInterval, repeatCount: Int) -> Data? {
    guard let images = image.images else {
        return nil
    }

    let frameCount = images.count
    let gifDuration = duration <= 0.0 ? image.duration / Double(frameCount) : duration / Double(frameCount)
    
    let frameProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: gifDuration]]
    let imageProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: repeatCount]]
    
    let data = NSMutableData()
    
    guard let destination = CGImageDestinationCreateWithData(data, kUTTypeGIF, frameCount, nil) else {
        return nil
    }
    CGImageDestinationSetProperties(destination, imageProperties as CFDictionary?)
    
    for image in images {
        CGImageDestinationAddImage(destination, image.cgImage!, frameProperties as CFDictionary?)
    }
    
    return CGImageDestinationFinalize(destination) ? (NSData(data: data as Data) as Data) : nil
}

extension UIImage {
    static func kf_animatedImageWithGIFData(gifData data: Data) -> UIImage? {
        return kf_animatedImageWithGIFData(gifData: data, scale: UIScreen.main.scale, duration: 0.0)
    }
    
    static func kf_animatedImageWithGIFData(gifData data: Data, scale: CGFloat, duration: TimeInterval) -> UIImage? {
        
        let options: NSDictionary = [kCGImageSourceShouldCache as String: NSNumber(value: true as Bool), kCGImageSourceTypeIdentifierHint as String: kUTTypeGIF]
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, options) else {
            return nil
        }
        
        let frameCount = CGImageSourceGetCount(imageSource)
        var images = [UIImage]()
        
        var gifDuration = 0.0
        
        for i in 0 ..< frameCount {
            guard let imageRef = CGImageSourceCreateImageAtIndex(imageSource, i, options) else {
                return nil
            }
            
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil),
                         let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
                   let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else
            {
                return nil
            }
            
            gifDuration += frameDuration.doubleValue
            images.append(UIImage(cgImage: imageRef, scale: scale, orientation: .up))
        }
        
        if frameCount == 1 {
            return images.first
        } else {
            return UIImage.animatedImage(with: images, duration: duration <= 0.0 ? gifDuration : duration)
        }
    }
}
