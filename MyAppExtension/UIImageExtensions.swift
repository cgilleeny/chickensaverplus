//
//  UIImageExtensions.swift
//  MyAppExtension
//
//  Created by Caroline Gilleeny on 1/21/21.
//  Copyright © 2021 Caroline Gilleeny. All rights reserved.
//
import UIKit
import Foundation

extension UIImage {
    
    func saveToURL(name: String) -> URL? {
      let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
      if let imageData = self.jpegData(compressionQuality: 1.0),
        urls.count > 0 {
        do {
          let imageURL = urls[0].appendingPathComponent("\(name).jpg")
          _ = try imageData.write(to: imageURL)
          return imageURL
        } catch {
          return nil
        }
      }
      return nil
    }

}
