//
//  PhotosCell.swift
//  PhotoGalleryFromUnsplash
//
//  Created by Alex Ch. on 17.05.2022.
//

import UIKit
import SDWebImage

class PhotosCell: UICollectionViewCell {
    
    static let reuseId = "PhotosCell"
    
    private let checkmark: UIImageView = {
       let image = UIImage(named: "bird.png")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Проверьте интернет соединение"
        return label
    }()
    
    var randomUnsplashPhoto: RandomPhotoResult! {
        didSet {
            let photoURL = randomUnsplashPhoto.urls["small"]
            guard let imageURL = photoURL, let url = URL(string: imageURL) else {return}
            photoImageView.sd_setImage(with: url, completed: nil)
            nameLabel.text = randomUnsplashPhoto.user.name
        }
    }
    
    var searchUnsplashPhoto: UnsplashPhoto! {
        didSet {
            let photoURL = searchUnsplashPhoto.urls["small"]
            guard let imageURL = photoURL, let url = URL(string: imageURL) else {return}
            photoImageView.sd_setImage(with: url, completed: nil)
            nameLabel.text = searchUnsplashPhoto.user.name
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    private func updateSelectedState(){
        photoImageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUIElements()
        updateSelectedState()
    }
    
    private func setupUIElements(){
        addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        photoImageView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
//            nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 2),
            nameLabel.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -2),
            nameLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant:  -2)
        ])
        
        photoImageView.addSubview(checkmark)
        NSLayoutConstraint.activate([
            checkmark.topAnchor.constraint(equalTo: photoImageView.topAnchor, constant: 2),
            checkmark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -2)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
