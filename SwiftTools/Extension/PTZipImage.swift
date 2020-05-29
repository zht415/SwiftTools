//
//  PTZipImage.swift
//  SwiftTools
//
//  Created by Pata on 2020/5/21.
//  Copyright © 2020 Pata. All rights reserved.
//

import UIKit
import Foundation

public protocol ImageConvertible {
    func toImage(_ imageHandler:@escaping (_ image: UIImage) -> ())
}

extension String: ImageConvertible {
    public func toImage(_ imageHandle:@escaping (UIImage) -> ()) {
        if self.contains("http") {
            let data = try? Data.init(contentsOf: URL.init(string: self)!)
            let image = UIImage.init(data: data ?? Data()) ?? UIImage()
            imageHandle(image)
        } else {
            let image = UIImage.init(named: self) ?? UIImage()
            imageHandle(image)
        }
    }
}

extension URL: ImageConvertible {
    public func toImage(_ imageHandle: @escaping (UIImage) -> ()) {
        let data = try? Data.init(contentsOf: self)
        let image = UIImage.init(data: data ?? Data()) ?? UIImage()
        imageHandle(image)
    }
}

public protocol ImageMaxSizeConvertible {
    var maxSize: Int { get }
    func toImageData() -> Data
}

public class PTZipImage: ImageMaxSizeConvertible {
    
    var imageHandler: ImageConvertible
    public var maxSize: Int
    
    init(with image: ImageConvertible, maxSize: Int) {
        self.imageHandler = image
        self.maxSize = maxSize
    }
    
    public func toImageData() -> Data {
        var data = Data()
        imageHandler.toImage { (image) in
            data = UIImage.zip(image: image , to: self.maxSize)
        }
        return data
    }
}
