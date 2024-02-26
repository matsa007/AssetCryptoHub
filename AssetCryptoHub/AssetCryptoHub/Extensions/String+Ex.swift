//
//  String+Ex.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 26.02.24.
//

extension String {
    func createBinanceTradePairDailyInfoApiURL(tradePairSymbol: String) -> String {
        self + "?symbol=\(tradePairSymbol)"
    }
    
    func createBinanceKlinesApiURL(symbol: String, interval: String, limit: Int) -> String {
        self + "?symbol=\(symbol)&interval=\(interval)&limit=\(String(limit))"
    }
    
    func createTradePairViewName(quoteAsset: String) -> String {
        self + " / \(quoteAsset)"
    }
    
    func addPercentSign() -> String {
        self + " %"
    }
}
