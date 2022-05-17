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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .cyan
        setupCollectionView()
        setupNavigationBar()
        setupSearchBar()
        
        
        
        
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
}


//MARK: - UISearchBarDelegate

extension PhotosCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { (searchResults) in
                searchResults?.results.map({ (photo) in
                    print(photo.urls["small"])
                })
            }
        })
    }
}
