//
//  DataLoader.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 26.02.24.
//

import Foundation
import Combine

final class CryptoInfoDataLoader: CryptoInfoDataLoadable {
    
    // MARK: - Parameters
    
    private var displayData = [MainScreenDisplayData]()
    
    private let displayDataIsReadyForViewPublisher = PassthroughSubject<[MainScreenDisplayData], Never>()
    var anyDisplayDataIsReadyForViewPublisher: AnyPublisher<[MainScreenDisplayData], Never> {
        self.displayDataIsReadyForViewPublisher.eraseToAnyPublisher()
    }
    
    private let detailedKlinesDataIsReadyForViewPublisher = PassthroughSubject<[KlinesModel], Never>()
    var anyDetailedKlinesDataIsReadyForViewPublisher: AnyPublisher<[KlinesModel], Never> {
        self.detailedKlinesDataIsReadyForViewPublisher.eraseToAnyPublisher()
    }
}
    
    // MARK: - Fetch Data
    
extension CryptoInfoDataLoader {
    func requestExchangeInfoData() {
        let services = Services()
        
        Task {
            do {
                let responseData: ExhangeInfoModel = try await NetworkManager.shared.requestData(
                    toEndPoint: ApiUrls.binanceExchangeInfo,
                    httpMethod: .get
                )
                await self.requestTraidingPairsDailyInfoData(
                    services.checkForTradingStatusAndUpdate(responseData)
                )
            }
            
            catch let error {
                switch error {
                case NetworkError.invalidURL:
                    print(error.localizedDescription)
                case NetworkError.invalidResponse:
                    print(error.localizedDescription)
                case NetworkError.statusCode(Int.min...Int.max):
                    print(error.localizedDescription)
                default:
                    break
                }
            }
        }
    }
    
    func requestTraidingPairsDailyInfoData(_ traidingPairsList: [ExhangeInfo]) async {
        await withTaskGroup(of: TradingPairsDailyInfo.self) { taskGroup in
            traidingPairsList.forEach { tradePair in
                taskGroup.addTask {
                    var dailyInfo = TradingPairsDailyInfo(
                        symbol: "",
                        baseAsset: "",
                        quoteAsset: "",
                        lastPrice: "",
                        priceChange: "",
                        priceChangePercent: ""
                    )
                    
                    do {
                        let helper = CryptoInfoHelper()
                        let responseData: TickersDailyInfoModel = try await NetworkManager.shared.requestData(
                            toEndPoint: helper.createUrlForBinanceTradePairDailyInfo(for: tradePair.symbol),
                            httpMethod: .get
                        )
                        dailyInfo = TradingPairsDailyInfo(
                            symbol: tradePair.symbol,
                            baseAsset: tradePair.baseAsset,
                            quoteAsset: tradePair.quoteAsset,
                            lastPrice: responseData.lastPrice,
                            priceChange: responseData.priceChange,
                            priceChangePercent: responseData.priceChangePercent
                        )
                    }
                    
                    catch let error {
                        switch error {
                        case NetworkError.invalidURL:
                            print(error.localizedDescription)
                        case NetworkError.invalidResponse:
                            print(error.localizedDescription)
                        case NetworkError.statusCode(Int.min...Int.max):
                            print(error.localizedDescription)
                        default:
                            break
                        }
                    }
                    return dailyInfo
                }
            }
            
            var tradingPairsDailyInfo = [TradingPairsDailyInfo]()
            
            for await dailyInfo in taskGroup {
                tradingPairsDailyInfo.append(TradingPairsDailyInfo(
                    symbol: dailyInfo.symbol,
                    baseAsset: dailyInfo.baseAsset,
                    quoteAsset: dailyInfo.quoteAsset,
                    lastPrice: dailyInfo.lastPrice,
                    priceChange: dailyInfo.priceChange,
                    priceChangePercent: dailyInfo.priceChangePercent
                ))
            }
            
            await self.requestKlinesData(
                tradingPairsDailyInfo: tradingPairsDailyInfo,
                interval: ChartIntervals.oneHour,
                limit: ChartRanges.oneDayForOneHourLimit
            )
        }
    }
    
    func requestKlinesData(tradingPairsDailyInfo: [TradingPairsDailyInfo], interval: String, limit: Int) async {
        let services = Services()
        await withTaskGroup(of: MainScreenDisplayData.self) { taskGroup in
            tradingPairsDailyInfo.forEach { tradePairInfo in
                taskGroup.addTask {
                    var displayData = MainScreenDisplayData(
                        tradingPairName: "",
                        tradingPairChartData: MainScreenChartData(
                            minPrice: 0.0,
                            maxPrice: 0.0,
                            isRaised: false,
                            tradingPairChartViewModel: [TradingPairChartData]()
                        ),
                        tradingPairPrice: "",
                        tradingPairPriceDailyChangeInPercents: "",
                        tradingPairPriceIsRaised: false)
                    
                    do {
                        let helper = CryptoInfoHelper()
                        let responseData: [KlinesModel] = try await NetworkManager.shared.requestData(
                            toEndPoint: helper.createBinanceKlinesApiURL(for: tradePairInfo.symbol, interval: interval, limit: limit),
                            httpMethod: .get
                        )
                        let chartData = services.createChartData(for: responseData, with: tradePairInfo.priceChangePercent)
                        displayData = MainScreenDisplayData(
                            tradingPairName: helper.createTradePairViewName(
                                for: tradePairInfo.baseAsset,
                                and: tradePairInfo.quoteAsset
                            ),
                            tradingPairChartData: chartData,
                            tradingPairPrice: services.updatePrice(tradePairInfo.lastPrice),
                            tradingPairPriceDailyChangeInPercents: helper.addPercentSign(for: tradePairInfo.priceChangePercent),
                            tradingPairPriceIsRaised: chartData.isRaised)
                    }
                    
                    catch let error {
                        switch error {
                        case NetworkError.invalidURL:
                            print(error.localizedDescription)
                        case NetworkError.invalidResponse:
                            print(error.localizedDescription)
                        case NetworkError.statusCode(Int.min...Int.max):
                            print(error.localizedDescription)
                        default:
                            break
                        }
                    }
                    return displayData
                }
            }
            
            for await displayData in taskGroup {
                self.displayData.append(displayData)
            }
            self.displayDataIsReadyForViewPublisher.send(self.displayData)
        }
    }
    
    func requestDetailedKlinesData(interval: String, limit: Int, tradePairName: String) {
        Task {
            do {
                let helper = CryptoInfoHelper()
                let responseData: [KlinesModel] = try await NetworkManager.shared.requestData(
                    toEndPoint: helper.createBinanceKlinesApiURL(
                        for: tradePairName,
                        interval: interval,
                        limit: limit
                    ),
                    httpMethod: .get
                )
                self.detailedKlinesDataIsReadyForViewPublisher.send(responseData)
            }
            
            catch let error {
                switch error {
                case NetworkError.invalidURL:
                    print(error.localizedDescription)
                case NetworkError.invalidResponse:
                    print(error.localizedDescription)
                case NetworkError.statusCode(Int.min...Int.max):
                    print(error.localizedDescription)
                default:
                    break
                }
            }
        }
    }
}
