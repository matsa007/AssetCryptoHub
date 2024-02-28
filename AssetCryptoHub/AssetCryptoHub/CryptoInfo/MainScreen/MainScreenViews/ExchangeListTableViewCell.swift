//
//  ExchangeListTableViewCell.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 25.02.24.
//

import UIKit
import SwiftUI

final class ExchangeListTableViewCell: UITableViewCell {
    
    // MARK: - GUI
    
    private lazy var tradePairNameView: UIView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var tradePairNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(
            name: FontNames.bold,
            size: FontSizes.regular
        )
        return label
    }()
    
    private lazy var tradePairChartView: UIView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var tradePairCurrentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(
            name: FontNames.bold,
            size: FontSizes.regular
        )
        return label
    }()
    
    private lazy var tradePairDailyChangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(
            name: FontNames.bold,
            size: FontSizes.regular
        )
        return label
    }()
    
    private lazy var cellStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            self.tradePairNameView,
            self.tradePairChartView,
            self.tradePairCurrentPriceLabel,
            self.tradePairDailyChangeLabel
        ])
        
        view.axis = .horizontal
        view.distribution = .equalCentering
        view.alignment = .center
        view.spacing = self.contentView.frame.width / 13
        
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubViews()
        self.setCellViews()
        self.setConstraints()
    }
    
    // MARK: - Add subviews
    
    private func addSubViews() {
        self.contentView.addSubview(self.cellStackView)
        self.tradePairNameView.addSubview(self.tradePairNameLabel)
    }
    
    // MARK: - UI setup
    
    private func setCellViews() {
        self.setCell()
    }
    
    private func setCell() {
        self.contentView.backgroundColor = ColorsSet.screenBackgroundColor
    }
    
    // MARK: - Constraints
    
    private func setConstraints() {
        self.cellStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.tradePairNameView.snp.makeConstraints { make in
            make.width.equalTo(self.contentView.frame.width / 4)
        }
        
        self.tradePairNameLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Set cell display data

    func setCellDisplayData(mainCryptoInfoDisplayDataModel: MainScreenDisplayData) {
        self.tradePairNameLabel.text = mainCryptoInfoDisplayDataModel.tradingPairName
        self.tradePairCurrentPriceLabel.text = mainCryptoInfoDisplayDataModel.tradingPairPrice
        self.tradePairDailyChangeLabel.text = mainCryptoInfoDisplayDataModel.tradingPairPriceDailyChangeInPercents
        self.setPriceChangedTextColor(mainCryptoInfoDisplayDataModel.tradingPairChartData.isRaised)
        
        self.tradePairChartView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }

        self.setupChartView(chartData: mainCryptoInfoDisplayDataModel.tradingPairChartData)
    }
}

// MARK: - Mini chart UIView creating

private extension ExchangeListTableViewCell {
    func setupChartView(chartData: MainScreenChartData) {
        DispatchQueue.main.async {
            let controller = UIHostingController(rootView: TradingPairMiniChartView(tradingPairChartDatalist: MainScreenChartData(
                minPrice: chartData.minPrice,
                maxPrice: chartData.maxPrice,
                isRaised: chartData.isRaised,
                tradingPairChartViewModel: chartData.tradingPairChartViewModel
            )))

            guard let chartView = controller.view else { return }
            chartView.backgroundColor = .clear
            self.tradePairChartView.addSubview(chartView)

            chartView.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
                make.width.equalTo(self.cellStackView.frame.width / 3.8)
                make.height.equalTo(self.cellStackView.frame.width / 7.5)
            }
        }
    }
}

// MARK: - Cell text elements color setter

private extension ExchangeListTableViewCell {
    func setPriceChangedTextColor(_ isRased: Bool) {
        switch isRased {
        case true:
            self.tradePairCurrentPriceLabel.textColor = ColorsSet.priceChangedColorGreen
            self.tradePairDailyChangeLabel.textColor = ColorsSet.priceChangedColorGreen
        case false:
            self.tradePairCurrentPriceLabel.textColor = ColorsSet.priceChangedColorRed
            self.tradePairDailyChangeLabel.textColor = ColorsSet.priceChangedColorRed
        }
    }
}
