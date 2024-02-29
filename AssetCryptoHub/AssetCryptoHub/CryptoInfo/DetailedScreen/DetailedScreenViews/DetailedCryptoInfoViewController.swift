//
//  DetailedCryptoInfoViewController.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 29.02.24.
//

import UIKit

final class DetailedCryptoInfoViewController: UIViewController {
    
    // MARK: - Parameters
    
    private let viewModel: DetailedCryptoInfoViewModelProtocol
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .blue
        dump(self.viewModel.detailedData)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.view.layoutIfNeeded()
    }
    
    // MARK: - Initialization
    
    init(viewModel: DetailedCryptoInfoViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
