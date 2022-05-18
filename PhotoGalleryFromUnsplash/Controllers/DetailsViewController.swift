//
//  DetailsViewController.swift
//  PhotoGalleryFromUnsplash
//
//  Created by Alex Ch. on 16.05.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var image = ""
    private var name = ""
    private var createdDate = ""
    private var location = ""
    private var downloadCount: Int = 0
    
    private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var nameLabel = UILabel()
    private var createdDateLbl = UILabel()
    private var locationLbl = UILabel()
    private var downloadCountLbl = UILabel()
    lazy var labels: [UILabel] = [nameLabel, createdDateLbl, locationLbl, downloadCountLbl]
    
    
    // MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    //MARK: - Setup UI elements
    
    func setupUI(){
        
        photoImageView.image = UIImage()
        let url = URL(string: image)
        self.photoImageView.sd_setImage(with: url)
        nameLabel.text = "Автор: \(name)"
        createdDateLbl.text = "Создано: \(createdDate)"
        locationLbl.text = "Местоположение: \(location)"
        downloadCountLbl.text = "Количество скачиваний: \(downloadCount)"
        setupLbls(labels: labels)
        setupConstraints()
    }
    
    private func setupLbls(labels: [UILabel]) {
        for label in labels {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        }
    }
    
    func setData(model: RandomPhotoResult) {
        
        if let image = model.urls["small"]{
            self.image = image
        }
        name = model.user.name ?? ""
        createdDate = model.created_at
        location = model.user.location ?? ""
        downloadCount = model.downloads
        
    }
    
    private func setupConstraints(){
        
        view.addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            photoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3)
        ])
        
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        view.addSubview(createdDateLbl)
        NSLayoutConstraint.activate([
            createdDateLbl.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            createdDateLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createdDateLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        view.addSubview(locationLbl)
        NSLayoutConstraint.activate([
            locationLbl.topAnchor.constraint(equalTo: createdDateLbl.bottomAnchor, constant: 20),
            locationLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        view.addSubview(downloadCountLbl)
        NSLayoutConstraint.activate([
            downloadCountLbl.topAnchor.constraint(equalTo: locationLbl.bottomAnchor, constant: 20),
            downloadCountLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            downloadCountLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
