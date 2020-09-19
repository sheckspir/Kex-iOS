//
//  PartnerSearchViewController.swift
//  Kex
//
//  Created by Alex on 17.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Moya
import RxSwift
import UIKit

class PartnerSearchViewController: UIViewController {
    @IBOutlet var searchIndicator: UIActivityIndicatorView!
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet weak var findPartnerButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is PartnerSearchInfoViewController && sender is Partner) {
            (segue.destination as? PartnerSearchInfoViewController)?.partner = sender as? Partner
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onSearchClicked(_ sender: Any) {
        let login = loginTextField.text
        if login?.count ?? 0 <= 1 {
            showError(message: "Не верное имя пользователя")
        } else {
            let logger = NetworkLoggerPlugin()
            logger.configuration.logOptions = .verbose
            
            let provider = MoyaProvider<KexApi>(plugins: [logger]
            )
            
            

            _ = provider.rx.request(.findPartner(login: login!))
                .map(Partner.self)
                .do(onSuccess: { partner in
                    self.hideLoading()
                    self.performSegue(withIdentifier: "toPartnerInfo", sender: partner)
                }, onError: { error in
                    print("error \(error)")
                    self.hideLoading()
                    self.showNotFinded()
                }, onSubscribe: {
                    self.showLoading()
                }, onDispose: {
                    self.hideLoading()
                })
            .subscribe()
        }
    }

    private func showLoading() {
        errorLabel.isHidden = true
        searchIndicator.startAnimating()
        findPartnerButton.isEnabled = false
    }

    private func hideLoading() {
        searchIndicator.stopAnimating()
        findPartnerButton.isEnabled = true
    }

    private func showNotFinded() {
        showError(message: "Пользователь не найден")
    }

    private func showError(message: String) {
        errorLabel.isHidden = false
        errorLabel.text = message
    }
}
