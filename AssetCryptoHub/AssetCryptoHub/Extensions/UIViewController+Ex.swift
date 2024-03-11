//
//  UIViewController+Ex.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 29.02.24.
//

import UIKit

extension UIViewController {
    func alertForError(_ error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: ErrorTitles.alertTitle,
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            
            alert.addAction(
                UIAlertAction(
                    title: ErrorTitles.alertButtonTitle,
                    style: .cancel,
                    handler: nil
                )
            )
            
            self.present(
                alert,
                animated: true,
                completion: nil
            )
        }
    }
    
    func createSpinnerView(isFooterView: Bool) -> UIView {
        let spinnerViewHeight = isFooterView
        ? SizeCoefficients.spinnerFooterHeight
        : self.view.frame.height
        
        let spinnerView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: self.view.frame.width,
                height: spinnerViewHeight
            )
        )
        let spinner = UIActivityIndicatorView()
        spinner.center = spinnerView.center
        spinner.color = .black
        spinnerView.addSubview(spinner)
        spinner.startAnimating()
        return spinnerView
    }
}
