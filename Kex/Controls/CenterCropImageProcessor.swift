//
//  CenterCropImageProcessor.swift
//  Kex
//
//  Created by Alex on 09.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation
import Kingfisher

/// Processor for cropping the center of an image
public struct CenterCropImageProcessor: ImageProcessor {
    public let identifier: String
    public var centerPoint: CGFloat = 0.0
    public let size: CGSize
    public let anchor: CGPoint = CGPoint(x: 0.5, y: 0.5)

    public init(size: CGSize, centerPoint: CGFloat? = nil) {
        self.size = size
        if let center = centerPoint {
            self.centerPoint = center
        }
        identifier = "com.Kex.Controls.CenterCropImageProcessor(\(String(describing: centerPoint)))"
    }

    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        print("process!!!")
        switch item {
        case let .image(image):
            print("process image")

            let imageHeight = image.size.height
            let imageWidth = image.size.width

            let heightScale = imageHeight / size.height
            let widthScale = imageWidth / size.width

            if heightScale > 1 && widthScale > 1 {
                let scaleFactor = widthScale < heightScale ? heightScale : widthScale
                print("scalefactor = \(scaleFactor)")
                return image.kf.scaled(to: scaleFactor)
                    .kf.crop(to: size, anchorOn: anchor)
            } else {
                print("width = \(widthScale) height = \(heightScale)")
                return image.kf.scaled(to: options.scaleFactor)
                    .kf.crop(to: size, anchorOn: anchor)
            }
        case .data: do {
            print("process data")
            return (DefaultImageProcessor.default |> self).process(item: item, options: options)
        }
        default:
            print("another process")
        }
    }

//    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
//        switch item {
//        case .image(let image):
//
//            var imageHeight = image.size.height
//            var imageWidth = image.size.width
//
//            if imageHeight > imageWidth {
//                imageHeight = imageWidth
//            }
//            else {
//                imageWidth = imageHeight
//            }
//
//            let size = CGSize(width: imageWidth, height: imageHeight)
//
//            let refWidth : CGFloat = CGFloat(image.cgImage!.width)
//            let refHeight : CGFloat = CGFloat(image.cgImage!.height)
//
//            let x = (refWidth - size.width) / 2
//            let y = (refHeight - size.height) / 2
//
//            let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
//            if let imageRef = image.cgImage!.cropping(to: cropRect) {
//                return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
//            }
//
//            return nil
//
//        case .data(_):
//            return (DefaultImageProcessor.default |> self).process(item: item, options: options)
//        }
//    }
//
}

public struct MyCroppingImageProcessor: ImageProcessor {
    /// Identifier of the processor.
    /// - Note: See documentation of `ImageProcessor` protocol for more.
    public let identifier: String

    /// Target size of output image should be.
    public let size: CGSize

    public let anchor: CGPoint

    public init(size: CGSize, anchor: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        self.size = size
        self.anchor = anchor
        identifier = "com.Kex.Controls.MyCroppingImageProcessor(\(size)_\(anchor))"
    }

    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        print("process \(item)")
        switch item {
        case let .image(image):
            let imageHeight = image.size.height
            let imageWidth = image.size.width

            print("imageWidth = \(imageWidth) size.width = \(size.width)")
            print("imageHeight = \(imageHeight) size.height = \(size.height)")
            print("original scale factor = \(options.scaleFactor)")

            let heightScale = imageHeight / size.height
            let widthScale = imageWidth / size.width
//
            if heightScale > 1 && widthScale > 1 {
                let scaleFactor = widthScale > heightScale ? heightScale : widthScale
                print("scalefactor = \(scaleFactor)")
                return image.kf.scaled(to: scaleFactor)
                    .kf.crop(to: size, anchorOn: anchor)
            } else {
                print("width = \(widthScale) height = \(heightScale)")
                return image.kf.scaled(to: options.scaleFactor)
                    .kf.crop(to: size, anchorOn: anchor)
//                return image.kf.scaled(to: options.scaleFactor)
//                    .kf.crop(to: size, anchorOn: anchor)
//            }
//            return image.kf.scaled(to: options.scaleFactor)
//                        .kf.crop(to: size, anchorOn: anchor)
            }
        case .data: return (DefaultImageProcessor.default |> self).process(item: item, options: options)
        }
    }
}
