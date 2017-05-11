//
//  ImageConverter.swift
//  WishMaker
//
//  Created by student on 10.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension UIImage {
  enum JPEGQuality: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
  }
  
  /// Returns the data for the specified image in PNG format
  /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
  /// - returns: A data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
  var png: Data? { return UIImagePNGRepresentation(self) }
  
  /// Returns the data for the specified image in JPEG format.
  /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
  /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
  func jpeg(_ quality: JPEGQuality) -> Data? {
    return UIImageJPEGRepresentation(self, quality.rawValue)
  }
}

public class ImageConverter {
  
  public static func StringToUIImage(_ photo: String) -> UIImage?
  {
    var result : UIImage? = nil
    if let data = Data(base64Encoded: photo, options: .ignoreUnknownCharacters){
      result = UIImage(data: data)
    }
    return result
  }
  
  public static func UIImageToString(_ photo: UIImage) -> String?
  {
    var result : String?
    if let data = UIImageJPEGRepresentation(photo, UIImage.JPEGQuality.medium.rawValue){
      result = data.base64EncodedString()
    }
    return result
  }
  
  public static func parseDate(_ data:String ) -> String {
    let arr = data.components(separatedBy: "T")
    let date = arr[0]
    let t = (arr[1].components(separatedBy: ".")[0]).components(separatedBy: ":")
    let time = "\(t[0]) : \(t[1])"
    let result = "\(time) \n\(date)"
    return result
  }
}
