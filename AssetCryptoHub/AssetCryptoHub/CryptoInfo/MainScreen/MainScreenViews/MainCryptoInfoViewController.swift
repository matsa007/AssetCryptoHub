//
//  MainCryptoInfoViewController.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 25.02.24.
//

import UIKit
import SnapKit
import Combine

final class MainCryptoInfoViewController: UIViewController {
    
    // MARK: - Parameters
    
    private let viewModel: MainCryptoInfoViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - GUI
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        return searchBar
    }()
    
    private lazy var exchangeListTableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ColorsSet.screenBackgroundColor
        return tableView
    }()
    
    private lazy var spinnerView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.binding()
        self.setupLayout()
        self.viewModel.readyForDisplay()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.view.layoutIfNeeded()
    }
    
    // MARK: - Initialization
    
    init(viewModel: MainCryptoInfoViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
}

// MARK: - Layout

private extension MainCryptoInfoViewController {
    func setupLayout() {
        self.setView()
        self.setSubViews()
        self.setConstraints()
    }
    
    func setView() {
        self.view.backgroundColor = ColorsSet.screenBackgroundColor
    }
    
    func setSubViews() {
        self.view.addSubview(self.exchangeListTableView)
        self.setNavBar()
        self.setSearchItem()
        self.setExchangeListTableView()
    }
    
    func setConstraints() {
        self.exchangeListTableView.snp.makeConstraints {
            $0.centerX.height.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.width.equalTo(self.view.frame.width * SizeCoefficients.exchangeListTableViewWidth)
        }
    }
}

// MARK: - Setters

private extension MainCryptoInfoViewController {
    func setNavBar() {
        self.navigationItem.title = Titles.cryptoInfoTitle
    }
    
    func setSearchItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(self.searchButtonTapped)
        )
    }
    
    func setExchangeListTableView() {
        self.exchangeListTableView.register(
            ExchangeListTableViewCell.self,
            forCellReuseIdentifier: CellIdentificators.mainCryptoInfo
        )
    }
}

// MARK: - View Model binding

private extension MainCryptoInfoViewController {
    func binding() {
        self.bindInput()
        self.bindOutput()
    }
    
    func bindInput() {
        let _: () = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self.searchBar.searchTextField)
            .receive(on: DispatchQueue.main)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .sink { [weak self] searchedText in
                guard let self else { return }
                self.handleSearchBarTextChanged(searchedText)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.anySearchButtonTappedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.handleSearchButtonTapped()
            }
            .store(in: &self.cancellables)
        
        self.viewModel.anySearchBarCancelButtonTappedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.handleSearchBarCancelButtonTapped()
            }
            .store(in: &self.cancellables)
        
        self.viewModel.anySelectedCellDataIsReadyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedData in
                guard let self else { return }
                self.handleTableViewRowSelectedData(for: selectedData)
            }
            .store(in: &self.cancellables)
    }
    
    func bindOutput() {
        self.viewModel.anySpinnerStartViewPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.handleStartSpinnerAnimation()
            }
            .store(in: &self.cancellables)
        
        self.viewModel.anySpinnerStopViewPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.handleStopSpinnerAnimation()
            }
            .store(in: &self.cancellables)
        
        
        self.viewModel.anyMainScreenDisplayDataIsReadyForViewPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.exchangeListTableView.reloadData()
            }
            .store(in: &self.cancellables)
        
        self.viewModel.anyFilteredMainScreenDisplayDataIsUpdatedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.exchangeListTableView.reloadData()
            }
            .store(in: &self.cancellables)
        
        self.viewModel.anyNetworkErrorAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self else { return }
                self.handleShowErrorWithAlert(for: error)
            }
            .store(in: &self.cancellables)
    }
}

// MARK: - Actions and handlers

private extension MainCryptoInfoViewController {
    @objc func searchButtonTapped() {
        self.viewModel.searchButtonTapped()
    }
    
    func handleStartSpinnerAnimation() {
        self.spinnerView = self.createSpinnerView(isFooterView: false)
        self.view.addSubview(self.spinnerView)
    }
    
    func handleStopSpinnerAnimation() {
        self.spinnerView.removeFromSuperview()
    }
    
    func handleSearchBarTextChanged(_ searchedText: String) {
        self.viewModel.clearFilteredDisplayData()
        self.exchangeListTableView.reloadData()
        guard !searchedText.isEmpty else { return }
        self.viewModel.filteredDisplayDataUpdating(searchedText: searchedText)
    }
    
    func handleSearchButtonTapped() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.titleView = self.searchBar
    }
    
    func handleSearchBarCancelButtonTapped() {
        self.viewModel.clearFilteredDisplayData()
        self.navigationItem.titleView = nil
        self.setSearchItem()
        self.exchangeListTableView.reloadData()
    }
    
    func handleTableViewRowSelectedData(for selectedMainScreenDisplayData: MainScreenDisplayData) {
        let vc = DetailedCryptoInfoViewController(
            viewModel: DetailedCryptoInfoViewModel(
                detailedScreenDisplayData: DetailedScreenDisplayData(
                    tradingPairName: selectedMainScreenDisplayData.tradingPairName,
                    tradingPairChartData: nil,
                    tradingPairPrice: selectedMainScreenDisplayData.tradingPairPrice,
                    tradingPairPriceDailyChangeInPercents: selectedMainScreenDisplayData.tradingPairPriceDailyChangeInPercents,
                    tradingPairPriceIsRaised: nil
                )
            )
        )
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleShowErrorWithAlert(for error: Error) {
        self.alertForError(error)
    }
}

// MARK: - UITableViewDataSource

extension MainCryptoInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.filteredMainScreenDisplayData.isEmpty
        ? self.viewModel.mainScreenDisplayData.count
        : self.viewModel.filteredMainScreenDisplayData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.view.frame.height
            .scaled(by: SizeCoefficients.exchangeListTableViewCellHeight)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellIdentificators.mainCryptoInfo,
            for: indexPath
        ) as? ExchangeListTableViewCell else { return UITableViewCell() }
        
        let tradePairDailyData = self.viewModel.filteredMainScreenDisplayData.isEmpty
        ? self.viewModel.mainScreenDisplayData[indexPath.row]
        : self.viewModel.filteredMainScreenDisplayData[indexPath.row]
        
        cell.setCellDisplayData(mainCryptoInfoDisplayDataModel: tradePairDailyData)
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension MainCryptoInfoViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.searchBarCancelButtonTapped()
    }
}
// MARK: - UITableViewDelegate

extension MainCryptoInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.tableViewRowSelected(index: indexPath.row)
    }
}
