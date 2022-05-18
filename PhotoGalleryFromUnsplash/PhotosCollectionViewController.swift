//
//  PhotosCollectionViewController.swift
//  PhotoGalleryFromUnsplash
//
//  Created by Alex Ch. on 16.05.2022.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    
//    // Button реализовал в сетапе
//
//    private lazy var addBarButtonItem: UIBarButtonItem = {
//        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
//    }()
    
    private var networkDataFetcher = NetworkDataFetcher()
    private var timer: Timer?
    private var searchPhotos = [UnsplashPhoto]()
    private var randomPhotos = [RandomPhotoResult]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .cyan
        setupCollectionView()
        setupNavigationBar()
        setupSearchBar()
        getPhotos()
        
    }
   
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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellID")
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseId)
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
            cell.searchUnsplashPhoto = unsplashPhoto
            return cell
        } else {
            let unsplashPhoto = randomPhotos[indexPath.item]
            cell.randomUnsplashPhoto = unsplashPhoto
            return cell
        }
    }
    
}
//MARK: - UISearchBarDelegate

extension PhotosCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
                self?.isSearch = true
                guard let fetchedPhotos = searchResults else {return}
                DispatchQueue.main.async {
                    self?.searchPhotos = fetchedPhotos.results
                    self?.collectionView.reloadData()
                }
            }
        })
    }
}
