//
//  ExchangeInfoModel.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 25.02.24.
//

import Foundation

struct ExhangeInfoModel: Codable {
    let symbols: [Symbol]
}

struct Symbol: Codable {
    let symbol: String
    let status: String
    let baseAsset: String
    let quoteAsset: String
}

enum TradingPairStatus: String {
    case TRADING
}
