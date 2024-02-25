//
//  TickersDailyInfoModel.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 25.02.24.
//

import Foundation

struct TickersDailyInfoModel: Codable {
    let priceChange: String
    let priceChangePercent: String
    let lastPrice: String
}
