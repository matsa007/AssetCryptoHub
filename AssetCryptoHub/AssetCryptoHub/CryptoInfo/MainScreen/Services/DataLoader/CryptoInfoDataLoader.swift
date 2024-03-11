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
    
    private let networkErrorMessagePublisher = PassthroughSubject<Error, Never>()
    var anyNetworkErrorMessagePublisher: AnyPublisher<Error, Never> {
        self.networkErrorMessagePublisher.eraseToAnyPublisher()
    }
}
    
    // MARK: - Fetch Data
    
extension CryptoInfoDataLoader {
    func requestExchangeInfoData() {
        let services = MainCryptoInfoServices()
        
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
                    self.networkErrorMessagePublisher.send(error)
                case NetworkError.invalidResponse:
                    self.networkErrorMessagePublisher.send(error)
                case NetworkError.statusCode(Int.min...Int.max):
                    self.networkErrorMessagePublisher.send(error)
                default:
                    break
                }
            }
        }
    }
    
    func requestTraidingPairsDailyInfoData(_ traidingPairsList: [ExhangeInfo]) async {
        let helper = CryptoInfoHelper()
        let services = MainCryptoInfoServices()

        await withTaskGroup(of: DataForKlinesRequest.self) { taskGroup in
            traidingPairsList.forEach { tradePair in
                taskGroup.addTask {
                    var dailyInfo = DataForKlinesRequest(
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
                        dailyInfo = DataForKlinesRequest(
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
                            self.networkErrorMessagePublisher.send(error)
                        case NetworkError.invalidResponse:
                            self.networkErrorMessagePublisher.send(error)
                        case NetworkError.statusCode(Int.min...Int.max):
                            self.networkErrorMessagePublisher.send(error)
                        default:
                            break
                        }
                    }
                    return dailyInfo
                }
            }
            
            var tradingPairsDailyInfo = [DataForKlinesRequest]()
            
            for await dailyInfo in taskGroup {
                tradingPairsDailyInfo.append(DataForKlinesRequest(
                    symbol: dailyInfo.symbol,
                    baseAsset: dailyInfo.baseAsset,
                    quoteAsset: dailyInfo.quoteAsset,
                    lastPrice: dailyInfo.lastPrice,
                    priceChange: dailyInfo.priceChange,
                    priceChangePercent: dailyInfo.priceChangePercent
                ))
                
                let isRaised = dailyInfo.priceChangePercent.first == "-"
                ? false
                : true
                
                self.displayData.append(
                    MainScreenDisplayData(
                        tradingPairName: helper.createTradePairViewName(
                            for: dailyInfo.baseAsset,
                            and: dailyInfo.quoteAsset
                        ),
                        tradingPairChartData: nil,
                        tradingPairPrice: services.updatePrice(dailyInfo.lastPrice),
                        tradingPairPriceDailyChangeInPercents: helper.addPercentSign(for: dailyInfo.priceChangePercent),
                        tradingPairPriceIsRaised: isRaised
                    )
                )
            }
            
            self.displayDataIsReadyForViewPublisher.send(self.displayData)
            
            await self.requestKlinesData(
                dataForKlinesRequest: tradingPairsDailyInfo,
                interval: .oneHour,
                limit: .oneDayForOneHourLimit
            )
        }
    }
    
    func requestKlinesData(dataForKlinesRequest: [DataForKlinesRequest], interval: ChartIntervals, limit: ChartRanges) async {
        let services = MainCryptoInfoServices()
        
        await withTaskGroup(of: MainScreenDisplayData.self) { taskGroup in
            dataForKlinesRequest.forEach { tradePairInfo in
                taskGroup.addTask {
                    var displayData = MainScreenDisplayData(
                        tradingPairName: "",
                        tradingPairChartData: ChartData(
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
                            toEndPoint: helper.createBinanceKlinesApiURL(
                                for: tradePairInfo.symbol,
                                interval: interval.rawValue,
                                limit: limit.rawValue
                            ),
                            httpMethod: .get
                        )
                        let chartData = services.createChartData(
                            for: responseData,
                            with: tradePairInfo.priceChangePercent
                        )
                        
                        displayData = MainScreenDisplayData(
                            tradingPairName: helper.createTradePairViewName(
                                for: tradePairInfo.baseAsset,
                                and: tradePairInfo.quoteAsset
                            ),
                            tradingPairChartData: chartData,
                            tradingPairPrice: services.updatePrice(tradePairInfo.lastPrice),
                            tradingPairPriceDailyChangeInPercents: helper.addPercentSign(for: tradePairInfo.priceChangePercent),
                            tradingPairPriceIsRaised: chartData.isRaised
                        )
                    }
                    
                    catch let error {
                        switch error {
                        case NetworkError.invalidURL:
                            self.networkErrorMessagePublisher.send(error)
                        case NetworkError.invalidResponse:
                            self.networkErrorMessagePublisher.send(error)
                        case NetworkError.statusCode(Int.min...Int.max):
                            self.networkErrorMessagePublisher.send(error)
                        default:
                            break
                        }
                    }
                    return displayData
                }
            }
            
            self.displayData.removeAll()
            
            for await data in taskGroup {
                self.displayData.append(data)
            }
            self.displayDataIsReadyForViewPublisher.send(self.displayData)
        }
    }
}
