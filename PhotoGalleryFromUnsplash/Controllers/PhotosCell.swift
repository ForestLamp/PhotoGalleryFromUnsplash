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
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private let checkmark: UIImageView = {
       let image = UIImage(named: "bird.pdf")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    let photoImageView: UIImageView = {
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
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "Проверьте интернет соединение"
        return label
    }()
    
    func setupCellForRandomPhoto(model: RandomPhotoResult){
        
        nameLabel.text = model.user.name
        let photoURL = model.urls["small"]
        guard let imageUrl = photoURL,
              let url = URL(string: imageUrl) else {return}
        self.photoImageView.sd_setImage(with: url){_,_,_,_ in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
    }
    
    func setupCellForSearchPhoto(model: UnsplashPhoto){
        
        nameLabel.text = model.user.name
        photoImageView.image = UIImage()
        let photoURL = model.urls["small"]
        guard let imageUrl = photoURL,
              let url = URL(string: imageUrl) else {return}
        self.photoImageView.sd_setImage(with: url){_,_,_,_ in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
    
/*
    var randomUnsplashPhoto: RandomPhotoResult! {
        didSet {
            DispatchQueue.global().async {
                let photoURL = self.randomUnsplashPhoto.urls["small"]
                guard let imageURL = photoURL,
                      let url = URL(string: imageURL) else {return}
                DispatchQueue.main.async {
               //     self.photoImageView.sd_setImage(with: url, completed: nil)
                    self.photoImageView.image = UIImage(data: imageData)
                    self.nameLabel.text = self.randomUnsplashPhoto.user.name
                }
            }

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
*/
    
    
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
        
        photoImageView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        photoImageView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -2),
            nameLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant:  -4)
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
