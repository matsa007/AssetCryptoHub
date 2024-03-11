//
//  TradingPairMiniChartView.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 28.02.24.
//

import Foundation
import SwiftUI
import Charts

struct TradingPairMiniChartView: View {
    
    // MARK: - Parameters
    
    let tradingPairChartDatalist: ChartData
    
    // MARK: - Chart creating
    
    var body: some View {
        Chart(tradingPairChartDatalist.tradingPairChartViewModel) { listModel in
            LineMark(
                x: .value(AxisNames.xAxis, listModel.closeTime),
                y: .value(AxisNames.yAxis, listModel.close)
            )
            .foregroundStyle(self.setMainColor(self.tradingPairChartDatalist.isRaised))
            
            PointMark(x: .value(AxisNames.xAxis, listModel.closeTime),
                      y: .value(AxisNames.yAxis, listModel.close)
            )
            .foregroundStyle(self.setMainColor(self.tradingPairChartDatalist.isRaised))
            .symbolSize(5)
            
            AreaMark(
                x: .value(AxisNames.xAxis, listModel.closeTime),
                yStart: .value(AxisNames.yAxis, listModel.close),
                yEnd: .value(AxisNames.yAxisEnd, tradingPairChartDatalist.minPrice)
            )
            .foregroundStyle(Gradient(colors: self.setGradientColor(self.tradingPairChartDatalist.isRaised)))
            .blur(radius: 1)
        }
        .padding()
        .chartYScale(domain: tradingPairChartDatalist.minPrice...tradingPairChartDatalist.maxPrice)
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
        .background(.clear)
    }
}

// MARK: - Chart elements color setters

private extension TradingPairMiniChartView {
    func setMainColor(_ isRased: Bool) -> Color {
        return isRased
        ? ColorsSet.chartColorGreen
        : ColorsSet.chartColorRed
    }
    
    func setGradientColor(_ isRased: Bool) -> [Color] {
        return isRased
        ? ColorsSet.chartColorGreenGradient
        : ColorsSet.chartColorRedGradient
    }
}
