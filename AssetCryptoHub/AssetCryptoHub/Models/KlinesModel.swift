//
//  KlinesModel.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 25.02.24.
//

import Foundation

struct KlinesModel: Codable {
    let openTime: Double
    let open: Double
    let high: String
    let low: String
    let close: String
    let volume: String
    let closeTime: Double
    let quoteVolume: String
    let trades: Int
    let buyAssetVolume: String
    let buyQuoteVolume: String
    let ignored: String
    
    init(from decoder: Decoder) throws {
        var values = try decoder.unkeyedContainer()
        self.openTime = try values.decode(Double.self)
        self.open = Double(try values.decode(String.self)) ?? 0.0
        self.high = try values.decode(String.self)
        self.low = try values.decode(String.self)
        self.close = try values.decode(String.self)
        self.volume = try values.decode(String.self)
        self.closeTime = try values.decode(Double.self)
        self.quoteVolume = try values.decode(String.self)
        self.trades = try values.decode(Int.self)
        self.buyAssetVolume = try values.decode(String.self)
        self.buyQuoteVolume = try values.decode(String.self)
        self.ignored = try values.decode(String.self)
    }
}
