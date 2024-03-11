//
//  ChartIntervals.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 26.02.24.
//

import Foundation

enum ChartIntervals: String {
    case oneHour = "1h"
    case oneMinute = "1m"
}

enum ChartRanges: Int {
    case oneDayForOneHourLimit = 24
    case oneWeekForOneHourLimit = 168
}
