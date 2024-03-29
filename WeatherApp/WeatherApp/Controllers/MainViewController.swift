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
    
    private let searchTableView: UITableView = {
        let searchTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.showsVerticalScrollIndicator = false
        searchTableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        searchTableView.isHidden = true

        return searchTableView
    }()
    private let titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "해변 날씨"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "해변 이름으로 검색. ex)송도해수욕장", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
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
        
        DispatchQueue.main.async {
            self.view.backgroundColor = .systemBackground
            self.addSubView()
            self.applyConstraints()
            self.setupBlurEffect()
            self.configureMainTableView()
            self.configureDelegate()
            self.bindMainViewModel()
        }
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "취소"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .label
    }
    
    func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = searchTableView.frame
        searchTableView.backgroundView = visualEffectView
    }
    
    private func addSubView() {
        view.addSubview(mainCollectionView)
        view.addSubview(searchTableView)
        view.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(searchBar)
    }
    
    private func configureDelegate() {
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.delegate = self
        self.searchBar.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.delegate = self
        mainViewModel.searchCompleter.delegate = self
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

        self.mainViewModel.$searchResults
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
        let titleViewConstraints = [
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
            titleView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20),
        ]
        let searchBarConstraints = [
            searchBar.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -10),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
        ]
        let mainCollectionViewConstraints = [
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
        ]
        let searchTableViewConstraints = [
            searchTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(titleViewConstraints)
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
        mainViewModel.searchCompleter.queryFragment = searchTerm
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.endEditing(true)
        }
        mainViewModel.searchCompleter.queryFragment = searchText
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
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
        guard tableView.isEqual(mainCollectionView) else {return UIView()}
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 15, weight: .regular)
        print("mainViewModel.addedRegionalDataModels.count : " + mainViewModel.addedRegionalDataModels.count.description)
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
        let itemCount = mainViewModel.searchResults.count

        return itemCount
    }
    // 테이블 뷰 ReusableCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView.isEqual(searchTableView) else {
            // 진짜 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainCollectionViewCell.reuseIdentifier) as? MainCollectionViewCell else { return UITableViewCell() }
            // 로딩중에 보여주는 셀
            guard let placeHolderCell = tableView.dequeueReusableCell(withIdentifier: PlaceHolderCollectionViewCell.reuseIdentifier) as? PlaceHolderCollectionViewCell else { return UITableViewCell() }
            let cellRegion = self.mainViewModel.addedRegionalDataModels[indexPath.row]
            guard let models = self.mainViewModel.todayWeatherForecastModels[cellRegion] else {
                placeHolderCell.setUI(cellRegion)
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
        cell.selectionStyle = .none
        let searchResult = mainViewModel.searchResults[indexPath.row]
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
            let cellRegion = self.mainViewModel.addedRegionalDataModels[indexPath.row]
            guard UpdatedWeatherForecastModelManager.shared.weatherForecastModels[cellRegion] != nil else { return }
            viewController.regionModel = cellRegion
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

        Task{
            guard let regionModel = await self.mainViewModel.fetchDetailRegionData(indexPath) else { return }
            await self.mainViewModel.addAddedRegionalDataModel(regionModel)
            await self.mainViewModel.fetchWeatherForecastModel(regionModel)
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
                let regionModel = self.mainViewModel.addedRegionalDataModels[indexPath.row]
                await self.mainViewModel.removeAddedRegionalDataModel(regionModel)
                await self.mainViewModel.removeRegionFromTodayWeatherForecastModels(regionModel)
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
        mainViewModel.setSearchResults(completer.results)
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
