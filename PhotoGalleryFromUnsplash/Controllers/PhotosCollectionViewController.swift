//
//  PhotosCollectionViewController.swift
//  PhotoGalleryFromUnsplash
//
//  Created by Alex Ch. on 16.05.2022.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    
    //MARK: - Private properties
    
    private var networkDataFetcher = NetworkDataFetcher()
    private var timer: Timer?
    private var searchPhotos = [UnsplashPhoto]()
    private var randomPhotos = [RandomPhotoResult]()
    private let itemsPerRow: CGFloat = 1
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    private var selectedImages = [UIImage]()
    
//MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavigationBar()
        setupSearchBar()
        getPhotos()
    }
    
    //MARK: - Private methods
    
    private func getPhotos(){
            networkDataFetcher.fetchRandomImages { [weak self] (randomResults) in
                guard let fetchedPhotos = randomResults else {return}
                DispatchQueue.main.async {
                    self?.randomPhotos = fetchedPhotos
                    self?.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - NavigationItem action
    
    @objc private func addBarButtonTapped(){
        print(#function)
    }
    
    //MARK: - Setup UI elements
    
    private func setupNavigationBar(){
        let titleLabel = UILabel()
        titleLabel.text = "PHOTOS"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }
    
    private func setupCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellID")
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseId)
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
    
    private func setupSearchBar(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Search picture"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    //MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    
    private var isSearch: Bool = false
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearch{
            return searchPhotos.count
        } else {
            return randomPhotos.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId, for: indexPath) as! PhotosCell
        if isSearch {
            let unsplashPhoto = searchPhotos[indexPath.item]
            cell.setupCellForSearchPhoto(model: unsplashPhoto)
            return cell
        } else {
            let unsplashPhoto = randomPhotos[indexPath.item]
            cell.setupCellForRandomPhoto(model: unsplashPhoto)
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageView.image else {return}
        selectedImages.append(image)
 */
        if let detailsVC = DetailsViewController() as? DetailsViewController {
            detailsVC.setData(model: randomPhotos[indexPath.row])
            self.present(detailsVC, animated: true, completion:nil)
        }

        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageView.image else {return}
        if let index = selectedImages.firstIndex(of: image){
            selectedImages.remove(at: index)
        }
    }
    
}
//MARK: - UISearchBarDelegate

extension PhotosCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
                self?.isSearch = true
                guard let fetchedPhotos = searchResults else {return}
                self?.searchPhotos = fetchedPhotos.results
                self?.collectionView.reloadData()
            }
        })
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    //TODO: Оптимизировать код
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isSearch {
            let photo = searchPhotos[indexPath.item]
            let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
            return CGSize(width: widthPerItem, height: height)
        } else {
            let photo = randomPhotos[indexPath.item]
            let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
            return CGSize(width: widthPerItem, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
