//
//  UIImage+Extension.swift
//  SwiftTools
//
//  Created by Pata on 2020/5/21.
//  Copyright © 2020 Pata. All rights reserved.
//

import UIKit

import Foundation

extension UIImage {
    /// 压缩图片大小
    ///
    /// - Parameters:
    ///   - image: 原图
    ///   - kb: 图片大小
    /// - Returns: 压缩图片data
    static func zip(image: UIImage, to kb: Int) -> Data {
        //1.先压质量
        UIGraphicsBeginImageContext(CGSize.init(width: image.size.width, height: image.size.height))
        image.draw(in: CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        var compression: CGFloat = 1.0
        var data: Data = result.jpegData(compressionQuality: compression)!
        while data.count >= kb * 1024 , compression > 0.2 {
            compression -= 0.2
            data = result.jpegData(compressionQuality: compression)!
        }
        let maxLength =  1024 * kb
        if data.count < maxLength {
            return data
        } else {//2.压缩尺寸大小
            var resultImage = UIImage.init(data: data)
            var lastDataLength = 0
            while data.count > maxLength , data.count != lastDataLength {
                lastDataLength = data.count
                let ratio = CGFloat(maxLength) / CGFloat(data.count)
                let resultSize:CGSize = CGSize.init(width: CGFloat((resultImage?.size.width)!) * sqrt(ratio), height: CGFloat((resultImage?.size.height)!) * sqrt(ratio))
                UIGraphicsBeginImageContext(resultSize)
                resultImage?.draw(in: CGRect.init(x: 0, y: 0, width: resultSize.width, height: resultSize.height))
                resultImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                data = (resultImage!.jpegData(compressionQuality: compression))!
            }
            return data
        }
    }
}
