//
//  PartnerSearchInfoViewController.swift
//  Kex
//
//  Created by Alex on 19.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class PartnerSearchInfoViewController: UIViewController {
    
    var partner: Partner? = nil

    @IBOutlet weak var partnerImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var nameLogin: UILabel!
    @IBOutlet weak var addPartnerButton: UIButton!
    @IBOutlet weak var addIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (partner == nil) {
            navigationController?.popViewController(animated: true)
            return
        }
        if (partner?.sex == Sex.M) {
//            todo показать картинки
        } else {
//            todo показать картинки
        }
        loginLabel.text = partner!.login
        nameLogin.text = partner!.name
    }
    

    @IBAction func onAddPartnerClicked(_ sender: Any) {
        let provider = MoyaProvider<KexApi>()
        
        showLoading()
        
        provider.rx.request(.addPartner(partnerInfo: PartnerInfo(partnerId: partner!.id)))
            .asCompletable()
        .subscribe(onCompleted: {
            self.hideLoading()
            self.navigationController?.popToRootViewController(animated: true)
        }, onError: { error in
            self.hideLoading()
            self.showError(message: error.localizedDescription)
        })
    }
    
    private func showLoading() {
        addPartnerButton.isEnabled = false
        addIndicator.startAnimating()
        errorLabel.isHidden = true
    }
    
    private func hideLoading() {
        addPartnerButton.isEnabled = true
        addIndicator.stopAnimating()
    }
    
    private func showError(message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }

}
