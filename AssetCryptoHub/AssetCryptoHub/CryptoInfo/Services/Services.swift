//
//  Services.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 26.02.24.
//

import Foundation

struct Services {
    func checkForTradingStatusAndUpdate(_ tradePairExchangeInfoData: ExhangeInfoModel) -> [ExhangeInfo] {
        var updatedTradePairsInfoList = [ExhangeInfo]()

        tradePairExchangeInfoData.symbols.forEach { tradePairInfo in
            switch tradePairInfo.status {
            case TradingPairStatus.TRADING.rawValue:
                updatedTradePairsInfoList.append(
                    ExhangeInfo(
                        symbol: tradePairInfo.symbol,
                        baseAsset: tradePairInfo.baseAsset,
                        quoteAsset: tradePairInfo.quoteAsset
                    )
                )
            default:
                break
            }
        }
        return updatedTradePairsInfoList
    }
    
    func createChartData(for fetchedData: [KlinesModel], with priceChanged: String) -> MainScreenChartData {
        var chartData = MainScreenChartData(
            minPrice: Double.greatestFiniteMagnitude,
            maxPrice: 0.0,
            isRaised: Bool(),
            tradingPairChartViewModel: [TradingPairChartData]()
        )
                
        if Double(priceChanged) ?? 0.0 < 0 {
            chartData.isRaised = false
        } else {
            chartData.isRaised = true
        }
        
        fetchedData.forEach { intervalData in
            if Double(intervalData.close) ?? 0.0 > chartData.maxPrice {
                chartData.maxPrice = Double(intervalData.close) ?? 0.0
            }
            
            if Double(intervalData.close) ?? 0.0 < chartData.minPrice {
                chartData.minPrice = Double(intervalData.close) ?? 0.0
            }
            
            chartData.tradingPairChartViewModel.append(TradingPairChartData(
                openTime: self.dateFormatterFromDouble(timeInDouble: intervalData.openTime),
                open: intervalData.open,
                high: Double(intervalData.high) ?? 0.0,
                low: Double(intervalData.low) ?? 0.0,
                close: Double(intervalData.close) ?? 0.0,
                volume: intervalData.volume,
                closeTime: self.dateFormatterFromDouble(timeInDouble: intervalData.closeTime)
            ))
        }
        return chartData
    }
    
    private func dateFormatterFromDouble(timeInDouble: Double, timeInString: String? = nil) -> String {
        if let time = timeInString {
            let serverDate = Date(timeIntervalSince1970: Double(Double(time) ?? 0.0 / 1000))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let formattedDate = dateFormatter.string(from: serverDate)
            return formattedDate
        } else {
            let serverDate = Date(timeIntervalSince1970: Double(timeInDouble/1000))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let formattedDate = dateFormatter.string(from: serverDate)
            return formattedDate
        }
    }
    
    func updatePrice(_ price: String) -> String {
        var updatedPrice = price
        
        while updatedPrice.hasSuffix("0") {
            updatedPrice = String(updatedPrice.dropLast())
        }
        
        if updatedPrice.hasSuffix(".") {
            updatedPrice += "0"
        }
        return updatedPrice
    }
    
    func createDetailedDisplayData(for data: MainScreenDisplayData, and detailedChartData: MainScreenChartData) -> MainScreenDisplayData {
        MainScreenDisplayData(
            tradingPairName: data.tradingPairName,
            tradingPairChartData: detailedChartData,
            tradingPairPrice: data.tradingPairPrice,
            tradingPairPriceDailyChangeInPercents: data.tradingPairPriceDailyChangeInPercents,
            tradingPairPriceIsRaised: detailedChartData.isRaised)
    }
}
