//
//  MainViewController.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/08.
//

import UIKit

class MainViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let mainCollectionView: UICollectionView = {
        let mainCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        mainCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.reuseIdentifier)
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return mainCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchBar)
        view.addSubview(mainCollectionView)
        applyConstraints()

        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func applyConstraints() {
        let searchBarConstraints = [
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
        ]
        let mainCollectionViewConstraints = [
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            mainCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(searchBarConstraints)
        NSLayoutConstraint.activate(mainCollectionViewConstraints)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    
}
