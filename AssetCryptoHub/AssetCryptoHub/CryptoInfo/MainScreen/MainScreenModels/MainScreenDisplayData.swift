//
//  MainScreenDisplayData.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 26.02.24.
//

import Foundation

struct MainScreenDisplayData {
    let tradingPairName: String
    let tradingPairChartData: ChartData?
    let tradingPairPrice: String
    let tradingPairPriceDailyChangeInPercents: String
    let tradingPairPriceIsRaised: Bool
}
