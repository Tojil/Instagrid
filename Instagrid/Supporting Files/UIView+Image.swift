//
//  UIView+Image.swift
//  Instagrid
//
//  Created by Sergio Canto  on 05/03/2020.
//  Copyright © 2020 Sergio Canto . All rights reserved.
//


import UIKit

extension UIView {
    var image : UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let image = renderer.image { (_) in
            self.drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
        return image
    }
}
