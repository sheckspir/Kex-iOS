//
//  QuestionInfoViewController.swift
//  Kex
//
//  Created by Alex on 20.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Moya
import RxSwift
import UIKit
import Kingfisher

class QuestionInfoViewController: UIViewController {
    var groupId: Int?
    var question: Question?
    var partner: Partner?

    private var offer: Offer?

    @IBOutlet var mainView: UIView!

    @IBOutlet var questionImageView: UIImageView!
    @IBOutlet var questionTitleLabel: UILabel!
    @IBOutlet var questionTextLabel: UILabel!
    @IBOutlet var hintLabel: UILabel!

    @IBOutlet var tryButton: UIButton!

    @IBOutlet var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if groupId == nil || partner == nil || question == nil {
            navigationController?.popViewController(animated: true)
            return
        }
        
        let oldFrame = questionImageView.frame
        questionImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: oldFrame.height)

        let provider = MoyaProvider<KexApi>()

        _ = provider.rx.request(.getOfferToPartner(groupId: groupId!, questionId: question!.id, partnerId: partner!.id))
            .map(Offer.self)
            .do(onSuccess: { offer in
                self.showOffer(offer: offer)
                self.stopLoading()
            }, onError: { error in
                self.stopLoading()
                self.showError(message: error.localizedDescription)
            },
            onSubscribe: {
                self.showQuestion()
                self.showLoading()
            },
            onDispose: {
                self.stopLoading()
            })
        .subscribe()
    }
    
    private func showQuestion() {
        questionTitleLabel.text = question?.title
        questionTextLabel.text = question?.question
        hintLabel.text = question?.hint
        if (question?.image != nil) {
            print("2image size \(questionImageView.frame.size)")
            let imageProcessor = MyCroppingImageProcessor(size: questionImageView.frame.size)
            let url = URL(string: question!.image!)
            questionImageView.kf.setImage(with: url, options: [.processor(imageProcessor)])
        } else {
            questionImageView.image = nil
        }
    }


    private func showOffer(offer: Offer) {
        self.offer = offer
        mainView.isHidden = false
    }

    @IBAction func onTryClicked(_ sender: Any) {
        let string = offer!.text
        print("offer = \(string)")
        let activityViewController = UIActivityViewController(activityItems: [string], applicationActivities: nil)

        present(activityViewController, animated: true)
    }

    private func showLoading() {
        mainView.isHidden = true
        loadingIndicator.startAnimating()
    }

    private func stopLoading() {
        loadingIndicator.stopAnimating()
    }

    private func showError(message: String) {
        navigationController?.popViewController(animated: true)
    }
}
