//
//  PartnersViewController.swift
//  Kex
//
//  Created by Alex on 15.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import MaterialComponents.MaterialSnackbar
import Moya
import RxSwift
import UIKit

class PartnersViewController: UIViewController, UITableViewDataSource, PartnerClickListener, PartnerConfirmListener {
    private let titleCell = "TitleCell"
    private let userCell = "UserCell"
    private let userActionCell = "UserActionCell"

    private var partners: [PartnerConnectionType: [Partner]] = [:]

    @IBOutlet var emptyPartnersLabel: UILabel!
    @IBOutlet var partnersTableView: UITableView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!

    let provider = MoyaProvider<KexApi>()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PartnerMatchViewController && sender is Partner {
            (segue.destination as? PartnerMatchViewController)?.partner = sender as? Partner
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        partners.forEach({ one in
            if one.value.count > 0 {
                count += 1
                count += one.value.count
            }
        })
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = getItemForPosition(position: indexPath.item)
        var cell: UITableViewCell?
        if item is PartnerConnectionType {
            cell = tableView.dequeueReusableCell(withIdentifier: titleCell)
            (cell as? TitleTableViewCell)?.showType(type: item as! PartnerConnectionType)
        } else if item is (PartnerConnectionType, Partner?) {
            let partner = (item as! (PartnerConnectionType, Partner?)).1!
            let type = (item as! (PartnerConnectionType, Partner?)).0
            if type == PartnerConnectionType.NEW_REQUEST_FROM {
                cell = tableView.dequeueReusableCell(withIdentifier: userActionCell)
                (cell as! PartnelConfirmableCell).showPartner(partner: partner, listener: self)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: userCell)
                (cell as! PartnerCell).showPartner(partner: partner, listener: self)
            }
        }
        return cell!
    }

    override func viewWillAppear(_ animated: Bool) {
        _ = provider.rx.request(.getPartners)
            .mapJSON()
            .do(onSuccess: { data in
                var result = self.jsonToPartnersInfo(dictionary: data as! NSDictionary)
                self.stopAnimation()
                self.showPartners(partners: result)
            }, onError: { error in
                self.stopAnimation()
                self.showError(message: error.localizedDescription)
            }, onSubscribe: {
                self.showAnimation()
            }, onDispose: {
                self.stopAnimation()
            })
            .subscribe()
    }

    @IBAction func onFindNewClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSearchPartner", sender: nil)
    }

    func onPartnerClicked(partner: Partner) {
        performSegue(withIdentifier: "toPartnerMatch", sender: partner)
    }

    func onPartnerConfirm(partner: Partner) {
        _ = provider.rx.request(.confirmPartner(partnerInfo: PartnerInfo(partnerId: partner.id)))
            .asCompletable()
            .andThen(provider.rx.request(.getPartners))
            .mapJSON()
            .do(onSuccess: { data in
                let result = self.jsonToPartnersInfo(dictionary: data as! NSDictionary)
                self.stopModalAnimation()
                self.showPartners(partners: result)
            }, onError: { error in
                self.stopModalAnimation()
                self.showModalError(message: error.localizedDescription)
            }, onSubscribe: {
                self.showModalAnimation()
            }, onDispose: {
                self.stopModalAnimation()
            })
            .subscribe()
    }

    func onPartnerReject(partner: Partner) {
        _ = provider.rx.request(.rejectPartner(partnerInfo: PartnerInfo(partnerId: partner.id)))
            .asCompletable()
            .andThen(provider.rx.request(.getPartners))
            .mapJSON()
            .do(onSuccess: { data in
                let result = self.jsonToPartnersInfo(dictionary: data as! NSDictionary)
                self.stopModalAnimation()
                self.showPartners(partners: result)
            }, onError: { error in
                self.stopModalAnimation()
                self.showModalError(message: error.localizedDescription)
            }, onSubscribe: {
                self.showModalAnimation()
            }, onDispose: {
                self.stopModalAnimation()
            })
            .subscribe()
    }

    private func showPartners(partners: [PartnerConnectionType: [Partner]]) {
        self.partners = partners
        partnersTableView.reloadData()

        var firstPartner: Partner?
        var countPartners = 0
        partners.forEach({ pair in
            if pair.value.count > 0 {
                countPartners += pair.value.count
                if firstPartner == nil {
                    firstPartner = pair.value[0]
                }
            }
        })
        if countPartners <= 0 {
            emptyPartnersLabel.isHidden = false
            emptyPartnersLabel.text = "Вы ещё не добавили партнёров"
            partnersTableView.isHidden = true
        } else {
            emptyPartnersLabel.isHidden = true
            partnersTableView.isHidden = false
        }
        if countPartners == 1 && firstPartner != nil {
            onPartnerClicked(partner: firstPartner!)
        }
    }

    private func showAnimation() {
        partnersTableView.isHidden = true
        loadingIndicator.startAnimating()
        emptyPartnersLabel.isHidden = true
    }

    private func stopAnimation() {
        loadingIndicator.stopAnimating()
    }

    private func showError(message: String) {
        emptyPartnersLabel.isHidden = false
        emptyPartnersLabel.text = message
    }

    private func showModalAnimation() {
        loadingIndicator.startAnimating()
        partnersTableView.isUserInteractionEnabled = false
    }

    private func stopModalAnimation() {
        loadingIndicator.stopAnimating()
        partnersTableView.isUserInteractionEnabled = true
    }

    private func showModalError(message: String) {
        let snackMessage = MDCSnackbarMessage()
        snackMessage.text = message
        MDCSnackbarManager.default.show(snackMessage)
    }

    private func getItemForPosition(position: Int) -> Any? {
        var tempPosition = 0
        var result: Any?
        for type in PartnerConnectionType.allCases {
            let previousPosition = tempPosition

            let partnersForType = partners[type]
            if partnersForType != nil && partnersForType!.count > 0 {
                tempPosition += 1
                tempPosition += partnersForType!.count
            }
            if position < tempPosition {
                let realPosition = position - previousPosition - 1
                if realPosition >= 0 {
                    result = (type, partnersForType?[realPosition])
                } else {
                    result = type
                }
                return result
            }
        }
        return nil
    }

    private func jsonToPartnersInfo(dictionary: NSDictionary) -> [PartnerConnectionType: [Partner]] {
        var result: [PartnerConnectionType: [Partner]] = [:]
        for key in dictionary.allKeys {
            let type = PartnerConnectionType(rawValue: key as! String)
            let values = dictionary.value(forKey: key as! String) as? NSArray
            if values != nil {
                
                let pl = try! JSONDecoder().decode([Partner].self, from: JSONSerialization.data(withJSONObject: values!, options: []))
                result[type!] = pl
            }
        }
        return result
    }
}
