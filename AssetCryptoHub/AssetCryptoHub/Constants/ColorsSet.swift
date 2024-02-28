//
//  ColorsSet.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 25.02.24.
//

import UIKit
import SwiftUI

enum ColorsSet {
    static let tabBarBackgroundColor = UIColor(red: 232/255, green: 232/255, blue: 231/255, alpha: 1)
    static let screenBackgroundColor = UIColor(red: 242/255, green: 242/255, blue: 246/255, alpha: 1)
    static let chartColorRed = Color(red: 236/255, green: 2/255, blue: 1/255)
    static let chartColorRedGradient = [chartColorRed, .clear]
    static let chartColorGreen = Color(red: 43/255, green: 200/255, blue: 76/255)
    static let chartColorGreenGradient = [chartColorGreen, .clear]
    static let priceChangedColorRed = UIColor(chartColorRed)
    static let priceChangedColorGreen = UIColor(chartColorGreen)
}
