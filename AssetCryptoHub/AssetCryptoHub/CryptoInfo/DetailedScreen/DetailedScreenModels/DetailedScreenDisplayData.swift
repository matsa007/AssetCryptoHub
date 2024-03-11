//
//  DetailedScreenDisplayData.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 10.03.24.
//

import Foundation

struct DetailedScreenDisplayData {
    let tradingPairName: String
    let tradingPairChartData: ChartData?
    let tradingPairPrice: String
    let tradingPairPriceDailyChangeInPercents: String
    let tradingPairPriceIsRaised: Bool?
}
