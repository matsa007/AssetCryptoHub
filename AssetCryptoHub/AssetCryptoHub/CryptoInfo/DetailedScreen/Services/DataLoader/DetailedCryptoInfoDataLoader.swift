//
//  DetailedCryptoInfoDataLoader.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 9.03.24.
//

import Foundation
import Combine

final class DetailedCryptoInfoDataLoader: DetailedCryptoInfoDataLoadable {
    
    private let detailedKlinesDataIsReadyForViewPublisher = PassthroughSubject<[KlinesModel], Never>()
    var anyDetailedKlinesDataIsReadyForViewPublisher: AnyPublisher<[KlinesModel], Never> {
        self.detailedKlinesDataIsReadyForViewPublisher.eraseToAnyPublisher()
    }
    
    private let networkErrorMessagePublisher = PassthroughSubject<Error, Never>()
    var anyNetworkErrorMessagePublisher: AnyPublisher<Error, Never> {
        self.networkErrorMessagePublisher.eraseToAnyPublisher()
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
    
}
