//
//  CryptoInfoHelper.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 29.02.24.
//

import Foundation

struct CryptoInfoHelper {
    func createUrlForBinanceTradePairDailyInfo(for tradePairSymbol: String) -> String {
        ApiUrls.binanceTickerDailyChangeInfo + "?symbol=\(tradePairSymbol)"
    }
    
    func createBinanceKlinesApiURL(for symbol: String, interval: String, limit: Int) -> String {
        ApiUrls.binanceKlines + "?symbol=\(symbol)&interval=\(interval)&limit=\(String(limit))"
    }
    
    func createTradePairViewName(for baseAsset: String, and quoteAsset: String) -> String {
        baseAsset + " / \(quoteAsset)"
    }
    
    func addPercentSign(for priceChangedInPercents: String) -> String {
        priceChangedInPercents + " %"
    }
    
    func createTradePairNameForDetailedKlinesRequest(for tradePairName: String) -> String {
        var symbol = ""
        
        tradePairName.forEach {
            if $0 != " " && $0 != "/" {
                symbol += String($0)
            }
        }
        return symbol
    }
}
