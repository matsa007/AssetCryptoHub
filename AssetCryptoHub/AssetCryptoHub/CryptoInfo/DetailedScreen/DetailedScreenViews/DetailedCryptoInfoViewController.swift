//
//  DetailedCryptoInfoViewController.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 29.02.24.
//

import UIKit

final class DetailedCryptoInfoViewController: UIViewController {
    
    // MARK: - Parameters
    
    private let viewModel: DetailedCryptoInfoViewModelProtocol
    
    // MARK: - GUI
    
    private lazy var tradingPairChartView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var oneHourPeriodButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            ButtonNames.oneHour,
            for: .normal
        )
        return button
    }()
    
    private lazy var oneDayPeriodButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            ButtonNames.oneDay,
            for: .normal
        )
        return button
    }()
    
    private lazy var oneWeekPeriodButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            ButtonNames.oneWeek,
            for: .normal
        )
        return button
    }()
    
    private lazy var oneMonthPeriodButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            ButtonNames.oneMonth,
            for: .normal
        )
        return button
    }()
    
    private lazy var threeMonthsPeriodButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            ButtonNames.threeMonths,
            for: .normal
        )
        return button
    }()
    
    private lazy var oneYearPeriodButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            ButtonNames.oneYear,
            for: .normal
        )
        return button
    }()
    
    private lazy var twoYearsPeriodButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            ButtonNames.twoYears,
            for: .normal
        )
        return button
    }()
    
    private lazy var allTimePeriodButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            ButtonNames.allTime,
            for: .normal
        )
        return button
    }()
    
    private lazy var chartTimePereiodSelectorButtonRowsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.oneHourPeriodButton,
            self.oneDayPeriodButton,
            self.oneWeekPeriodButton,
            self.oneMonthPeriodButton,
            self.threeMonthsPeriodButton,
            self.oneYearPeriodButton,
            self.twoYearsPeriodButton,
            self.allTimePeriodButton
        ])
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.backgroundColor = .yellow
        return stackView
    }()
    
    private lazy var cryptoLogoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var tradingPairNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tradingPairPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tradingPairPriceChangedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    
    private lazy var tradePairInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.cryptoLogoImageView,
            self.tradingPairNameLabel,
            self.tradingPairPriceLabel,
            self.tradingPairPriceChangedLabel
        ])
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.backgroundColor = .brown
        return stackView
    }()
    
    private lazy var cryptoNewsTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private lazy var detailedCryptoInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.tradingPairChartView,
            self.chartTimePereiodSelectorButtonRowsStackView,
            self.tradePairInfoStackView,
            self.cryptoNewsTableView
        ])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.backgroundColor = .red
        return stackView
    }()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .blue
        dump(self.viewModel.detailedData)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.view.layoutIfNeeded()
    }
    
    // MARK: - Initialization
    
    init(viewModel: DetailedCryptoInfoViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
