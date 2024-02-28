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
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(self.view.frame.width * (34 / 35))
            $0.height.equalToSuperview()
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
    
    func bindInput() {}
    
    func bindOutput() {
        self.viewModel.anyMainScreenDisplayDataIsReadyForViewPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.exchangeListTableView.reloadData()
            }
            .store(in: &self.cancellables)
    }
}

// MARK: - Actions

private extension MainCryptoInfoViewController {
    @objc func searchButtonTapped() {
        print("searchButtonTapped")
    }
}

// MARK: - UITableViewDataSource

extension MainCryptoInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.mainScreenDisplayData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.view.frame.height / 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellIdentificators.mainCryptoInfo,
            for: indexPath
        ) as? ExchangeListTableViewCell else { return UITableViewCell() }
        let tradePairDailyData = self.viewModel.mainScreenDisplayData[indexPath.row]
        cell.setCellDisplayData(mainCryptoInfoDisplayDataModel: tradePairDailyData)
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension MainCryptoInfoViewController: UISearchBarDelegate {}

// MARK: - UITableViewDelegate

extension MainCryptoInfoViewController: UITableViewDelegate {}
