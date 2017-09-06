//
//  AnnotatedPhotoCell.swift
//  Rendezvous2
//
//  Created by John Jin Woong Kim on 2/12/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//

import UIKit

class AnnotatedPhotoCell: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.backgroundColor = .green
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
                setupViews()
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
            layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
            addSubview(imageView)
        
            
            addConstraintsWithFormat("H:|[v0]|", views: imageView)
            addConstraintsWithFormat("V:|[v0]|", views: imageView)

    }
}

