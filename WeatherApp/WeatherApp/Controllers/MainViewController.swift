//
//  MainViewController.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/08.
//

import Combine
import SwiftUI

class MainViewController: UIViewController {
    @ObservedObject var mainCollectionViewModel = MainViewModel()
    var cancelBag = Set<AnyCancellable>()

    private let searchTableView: UITableView = {
        let searchTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.showsVerticalScrollIndicator = false
        searchTableView.alpha = 0.4

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
        
       // mainCollectionViewModel.fetchWeatherForecastModels()
        bindMainViewModel()
    }
    
    private func bindMainViewModel() {
        self.mainCollectionViewModel.$weatherForecastModels
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.mainCollectionView.reloadData()
                print("mainCollectionView.reloadData()")
            })
            .store(in: &self.cancelBag)
        self.mainCollectionViewModel.$pastWeatherForecastModels
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
//                self?.mainCollectionView.reloadData()
//                print("mainCollectionView.reloadData()")
            })
            .store(in: &self.cancelBag)
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

// MARK: Collectioinview
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainCollectionViewModel.weatherForecastModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        guard let model = Array(mainCollectionViewModel.weatherForecastModels.values)[indexPath.item].first else { return UICollectionViewCell() }

        guard let pastTMNModel = mainCollectionViewModel.pastWeatherForecastModels[model.regionalCode]?.filter({ $0.forecastTime == "0600" }).first else { return UICollectionViewCell()}
        
        guard let pastTMXModel = mainCollectionViewModel.pastWeatherForecastModels[model.regionalCode]?.filter({ $0.forecastTime == "1500" }).first else { return UICollectionViewCell()}
        
        cell.setUI(model, pastTMNModel, pastTMXModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width - 40
        let cellHeight = collectionView.bounds.height * 0.2
        let itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = RegionWeatherViewController()
        
        if let model = Array(mainCollectionViewModel.weatherForecastModels.values)[indexPath.item].first {
            viewController.regionalCode = model.regionalCode
        }
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
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
        searchBar.showsCancelButton = false
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let regionalDataModel = RegionalDataManager.shared.searchedRegionalDataArray[indexPath.item]
        RegionalDataManager.shared.addAddedRegionalCodeAtUserDefaults(regionalDataModel.regionalCode)
        RegionalDataManager.shared.setAddedRegionalDataArray()
    }
}
