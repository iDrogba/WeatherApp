//
//  MainViewController.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/08.
//

import Combine
import SwiftUI
import Alamofire

class MainViewController: UIViewController {
    @ObservedObject private var mainViewModel = MainViewModel()
    private var cancelBag = Set<AnyCancellable>()
    private var transition = AnimationTransition()
    
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
    
    private let mainCollectionView: UITableView = {
        let mainCollectionView = UITableView(frame: .zero, style: .plain)
        mainCollectionView.register(MainCollectionViewCell.self, forCellReuseIdentifier: MainCollectionViewCell.reuseIdentifier)
        mainCollectionView.register(PlaceHolderCollectionViewCell.self, forCellReuseIdentifier: PlaceHolderCollectionViewCell.reuseIdentifier)
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainCollectionView.showsVerticalScrollIndicator = false
        mainCollectionView.backgroundColor = .systemBackground
        mainCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

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

        mainCollectionView.contentInset = .zero
        mainCollectionView.contentInsetAdjustmentBehavior = .never
        mainCollectionView.separatorStyle = .none
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "취소"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .label
        bindMainViewModel()
    }
    
    private func bindMainViewModel() {
        self.mainViewModel.$todayWeatherForecastModels
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard self?.mainViewModel.addedRegionalDataModels.count == self?.mainViewModel.todayWeatherForecastModels.count else { return }
                self?.mainCollectionView.reloadData()
                print("mainCollectionView.reloadData()")
            })
            .store(in: &self.cancelBag)

        self.mainViewModel.$searchedRegionalDataModels
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.searchTableView.reloadData()
                print("searchTableView.reloadData()")
            })
            .store(in: &self.cancelBag)
        
        self.mainViewModel.$addedRegionalDataModels
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.mainCollectionView.reloadData()
                print("mainCollectionView.reloadData()")
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
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            mainCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0)
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
        
        mainViewModel.searchRegionalDataModel(searchTerm)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchTableView.isHidden = true
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.endEditing(true)
        }
        mainViewModel.searchRegionalDataModel(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard tableView.isEqual(mainCollectionView) else {return nil}
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 15, weight: .regular)
        guard  mainViewModel.addedRegionalDataModels.count == 0 else {
            if  mainViewModel.addedRegionalDataModels.count != mainViewModel.todayWeatherForecastModels.count {
                label.text = "날씨 데이터를 불러옵니다."
                return label
            }
            return UIView()
        }
        label.text = "검색을 통해 지역을 추가해주세요."

        return label
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard mainViewModel.addedRegionalDataModels.count != mainViewModel.todayWeatherForecastModels.count || mainViewModel.addedRegionalDataModels.count == 0 else { return 0 }
        return tableView.frame.height * 0.2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableView.isEqual(searchTableView) else {
            guard mainViewModel.addedRegionalDataModels.count != 0 else {
                
                return 0 }
            return mainViewModel.addedRegionalDataModels.count
        }
        let itemCount = mainViewModel.searchedRegionalDataModels.count
        if itemCount == 0 {
            tableView.alpha = 0.4
        } else {
            tableView.alpha = 1
        }
        return itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView.isEqual(searchTableView) else {
            // 진짜 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainCollectionViewCell.reuseIdentifier) as? MainCollectionViewCell else { return UITableViewCell() }
            // 로딩중에 보여주는 셀
            guard let placeHolderCell = tableView.dequeueReusableCell(withIdentifier: PlaceHolderCollectionViewCell.reuseIdentifier) as? PlaceHolderCollectionViewCell else { return UITableViewCell() }
                        
            let cellRegionalCode = self.mainViewModel.addedRegionalDataModels[indexPath.row].regionalCode
            
            guard let models = self.mainViewModel.todayWeatherForecastModels[cellRegionalCode] else {
                placeHolderCell.setUI(cellRegionalCode)
                return placeHolderCell
            }
//            ?.filter({ model in
//                floor((model.time - Date()) / 86400) < 1})

            DispatchQueue.main.async {
                cell.setUI(models)
            }
            
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        let regionalDataModel = mainViewModel.searchedRegionalDataModels[indexPath.row]
        cell.setUI(regionalDataModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.isEqual(searchTableView) else {
            guard self.mainViewModel.addedRegionalDataModels.count != 0 else { return }

            guard let cell = tableView.cellForRow(at: indexPath) as? MainCollectionViewCell else { return }
            let cellOriginPoint =  cell.superview?.convert(cell.center, to: nil)
            let cellOriginFrame =  cell.superview?.convert(cell.frame, to: nil)
            
            self.transition.setPoint(point: cellOriginPoint)
            self.transition.setFrame(frame: cellOriginFrame)
            
            let viewController = RegionWeatherViewController()
            let cellRegionalCode = self.mainViewModel.addedRegionalDataModels[indexPath.row].regionalCode
            guard UpdatedWeatherForecastModelManager.shared.weatherForecastModels[cellRegionalCode] != nil else { return }
            viewController.regionalCode = cellRegionalCode
            viewController.surfConditionOutput = cell.surfCondition
            
            viewController.transitioningDelegate = self
            viewController.modalPresentationStyle = .custom
            DispatchQueue.main.async {
                self.present(viewController, animated: true)
            }
            return
        }
        let regionalDataModel = mainViewModel.searchedRegionalDataModels[indexPath.row]
        Task{
            await self.mainViewModel.addAddedRegionalDataModels(regionalDataModel.regionalCode){}
            await self.mainViewModel.fetchWeatherForecastModels()
        }
        searchBar.endEditing(true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.isEqual(mainCollectionView) {
            return tableView.bounds.height * 0.2
        }
        return tableView.bounds.height * 0.065
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard tableView.isEqual(mainCollectionView) else { return UISwipeActionsConfiguration() }
        guard tableView.cellForRow(at: indexPath)?.isKind(of: PlaceHolderCollectionViewCell.self) == false else {return UISwipeActionsConfiguration() }
        guard self.mainViewModel.addedRegionalDataModels.count != 0 else {return UISwipeActionsConfiguration()}
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            guard self.mainViewModel.addedRegionalDataModels.count != 0 else { return }
            let regionalDataModel = self.mainViewModel.addedRegionalDataModels[indexPath.row]
            self.mainViewModel.removeAddedRegionalDataModels(regionalDataModel.regionalCode, indexPath.row)
            self.mainViewModel.removeWeatherForecastModels(regionalDataModel.regionalCode)
            completion(true)
        }

        let image = UIImage(systemName: "trash.circle")
        deleteAction.image = image
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard tableView.isEqual(mainCollectionView) else { return }
        cell.alpha = 0

        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    // present될때 실행애니메이션
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transition
    }
    // dismiss될때 실행애니메이션
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DisMissAnim()
    }
}
