//
//  PinterestCell.swift
//  SuperHero
//
//  Created by Andrei on 15.02.23.
//

import UIKit

class MyCell: UICollectionViewCell {
    
    var heroesCell: String = ""
    
    var image: UIImage! {
        didSet {
            imageView.image = image
        }
    }
    
    var heartImageTapped: Bool! = false{
        didSet {
            if heartImageTapped == false {
                heartImage.image = UIImage(systemName: "heart")
            }else{
                heartImage.image = UIImage(systemName: "heart.fill")
            }
        }
    }
    
    let imageView: UIImageView = {
        let image = UIImage(named: "image")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let heartImage: UIImageView = {
        let image = UIImage(systemName: "heart")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(heartImage)
        setupViews()
        
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            heartImage.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            heartImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -7),
            heartImage.heightAnchor.constraint(equalToConstant: 30),
            heartImage.widthAnchor.constraint(equalToConstant: 30),
        ])
    }

}

