//
//  CenterCropImageProcessor.swift
//  Kex
//
//  Created by Alex on 09.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation
import Kingfisher

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

            let heightScale = imageHeight / size.height
            let widthScale = imageWidth / size.width

            if heightScale > 1 || widthScale > 1 {
                let scaleFactor = widthScale > heightScale ? heightScale : widthScale
                return image.kf.scaled(to: scaleFactor)
                    .kf.crop(to: size, anchorOn: anchor)
            } else {
                return image.kf.scaled(to: options.scaleFactor)
                    .kf.crop(to: size, anchorOn: anchor)
            }
        case .data: return (DefaultImageProcessor.default |> self).process(item: item, options: options)
        }
    }
}
