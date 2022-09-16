//
//  MainViewController.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/08.
//

import Combine
import SwiftUI
import Alamofire
import MapKit

class MainViewController: UIViewController {
    @ObservedObject private var mainViewModel = MainViewModel()
    private var cancelBag = Set<AnyCancellable>()
    private var transition = AnimationTransition()
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
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
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "해변 이름으로 검색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
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
        searchTableView.isHidden = true
        addSubView()
        configureDelegate()
        bindMainViewModel()
        applyConstraints()
        configureMainTableView()
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "취소"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .label
    }
    
    private func addSubView() {
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(mainCollectionView)
        view.addSubview(searchTableView)
    }
    
    private func configureDelegate() {
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.delegate = self
        self.searchBar.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.delegate = self
        self.searchCompleter.delegate = self
        self.searchCompleter.resultTypes = .pointOfInterest
        self.searchCompleter.pointOfInterestFilter = MKPointOfInterestFilter.init(including: [.beach])
        self.searchBar.delegate = self
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
    
    private func configureMainTableView() {
        mainCollectionView.contentInset = .zero
        mainCollectionView.contentInsetAdjustmentBehavior = .never
        mainCollectionView.separatorStyle = .none
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
        searchCompleter.queryFragment = searchTerm
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResults.removeAll()
            searchBar.endEditing(true)
        }
        print(searchResults)
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchResults.removeAll()
        searchTableView.isHidden = true
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
    }
}

// MARK: TableViewDelegate
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
                Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) {timer in
                    UILabel.animate(withDuration: 1, delay: 0.0, options: [.curveEaseInOut], animations: {
                        if label.alpha == 1 {
                            label.alpha = 0.2
                        } else {
                            label.alpha = 1
                        }
                    }, completion: nil)
                }
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
    // 테이블 뷰 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableView.isEqual(searchTableView) else {
            guard mainViewModel.addedRegionalDataModels.count != 0 else { return 0 }
            return mainViewModel.addedRegionalDataModels.count
        }
        let itemCount = searchResults.count
        if itemCount == 0 {
            tableView.alpha = 0.4
        } else {
            tableView.alpha = 1
        }
        return itemCount
    }
    // 테이블 뷰 ReusableCell
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

            DispatchQueue.main.async {
                cell.setUI(models)
            }
            
            return cell
        }
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        let searchResult = searchResults[indexPath.row]
        cell.setUI(result: searchResult)

        return cell
    }
    // 테이블 뷰 셀 선택 시 도악
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
            viewController.highestWaveHeight = cell.highestWaveHeight
            viewController.lowestWaveHeight = cell.lowestWaveHeight
            
            viewController.transitioningDelegate = self
            viewController.modalPresentationStyle = .custom
            DispatchQueue.main.async {
                self.present(viewController, animated: true)
            }
            return
        }

        let regionalDataModel = mainViewModel.searchedRegionalDataModels[indexPath.row]
        Task{
            await self.mainViewModel.addAddedRegionalDataModel(regionalDataModel.regionalCode)
            await self.mainViewModel.fetchWeatherForecastModel(regionalDataModel)
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
            Task{
                guard self.mainViewModel.addedRegionalDataModels.count != 0 else { return }
                let regionalDataModel = self.mainViewModel.addedRegionalDataModels[indexPath.row]
                await self.mainViewModel.removeAddedRegionalDataModel(regionalDataModel.regionalCode)
                await self.mainViewModel.removeRegionFromTodayWeatherForecastModels(regionalDataModel.regionalCode)
            }
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

extension MainViewController: MKLocalSearchCompleterDelegate {
    // 자동완성 완료시 결과를 받는 method
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchTableView.reloadData()
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: Animation
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
