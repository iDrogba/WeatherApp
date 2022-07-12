//
//  MainViewController.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/08.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    static let reuseIdentifier = "searchTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(_ regionalDataModel: RegionalDataModel) {
        self.textLabel?.text = regionalDataModel.first + " " + regionalDataModel.second + " " + regionalDataModel.third
    }
}

class MainViewController: UIViewController {
    private var currentIndex: CGFloat = 0
    private let searchTableView: UITableView = {
        let searchTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.showsVerticalScrollIndicator = false
        searchTableView.alpha = 0.4
        let searchTableViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(searchTableViewTapped(_:)))
        searchTableViewTapGesture.cancelsTouchesInView = false
        searchTableView.addGestureRecognizer(searchTableViewTapGesture)

        return searchTableView
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "날씨"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "지역으로 검색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.showsCancelButton = false

        return searchBar
    }()
    
    private let mainCollectionView: UICollectionView = {
        let mainCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        mainCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.reuseIdentifier)
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainCollectionView.showsVerticalScrollIndicator = false
        
        return mainCollectionView
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(mainCollectionView)
        view.addSubview(searchTableView)
        applyConstraints()
        searchTableView.isHidden = true
        
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        searchBar.delegate = self
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "취소"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .label
//        mainCollectionView.isPagingEnabled = true
//        let layout = mainCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.scrollDirection = .horizontal
    }
    
    private func applyConstraints() {
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        ]
        let searchBarConstraints = [
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
        ]
        let mainCollectionViewConstraints = [
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            mainCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10)
        ]
        let searchTableViewConstraints = [
            searchTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(searchBarConstraints)
        NSLayoutConstraint.activate(mainCollectionViewConstraints)
        NSLayoutConstraint.activate(searchTableViewConstraints)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.setUI()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width - 40
        let cellHeight = collectionView.bounds.height * 0.2
        let itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        return itemSize
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//
//        let layout = mainCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
//
//        var offset = targetContentOffset.pointee
//        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
//        var roundedIndex = round(index)
//
//        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
//            roundedIndex = floor(index)
//        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
//            roundedIndex = ceil(index)
//        } else {
//            roundedIndex = round(index)
//        }
//
//        if currentIndex > roundedIndex {
//            currentIndex -= 1
//            roundedIndex = currentIndex
//        } else if currentIndex < roundedIndex {
//            currentIndex += 1
//            roundedIndex = currentIndex
//        }
//
//        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
//        targetContentOffset.pointee = offset
//    }
}

extension MainViewController: UISearchBarDelegate {
    private func dissmissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dissmissKeyboard()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchTableView.isHidden = false
        searchBar.showsCancelButton = true
        guard let searchTerm = searchBar.text else { return }
        RegionalDataManager.shared.setSearchedRegionalDataModel(searchTerm)
        searchTableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchTableView.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.endEditing(true)
        }
        RegionalDataManager.shared.setSearchedRegionalDataModel(searchText)
        searchTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemCount = RegionalDataManager.shared.searchedRegionalDataArray.count
        if itemCount == 0 {
            tableView.alpha = 0.4
        } else {
            tableView.alpha = 1
        }
        
        return itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        let regionalDataModel = RegionalDataManager.shared.searchedRegionalDataArray[indexPath.item]
        cell.setUI(regionalDataModel)
        return cell
    }
    
    @objc func searchTableViewTapped(_ gesture: UITapGestureRecognizer)  {
        //if recognizer.state == UIGestureRecognizer.State.ended {
//            let tapLocation = recognizer.locationInView(self.tableView)
//            if let tapIndexPath = self.tableView.indexPathForRowAtPoint(tapLocation) {
//                if let tappedCell = self.tableView.cellForRowAtIndexPath(tapIndexPath) as? MyTableViewCell {
//                    //do what you want to cell here
//
//                }
//            }
   // }
            searchTableView.endEditing(true)
    }
}
