//
//  FirstViewController.swift
//  Kex
//
//  Created by Александр Карамышев on 11/07/2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class FirstViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    
    var groups : [QuizGroup] = []
    var cellID = "GroupCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        let groupCell = (cell as! GroupViewCell)
        let group = groups[indexPath.item]
//        groupCell.nameQuestionLabelView.text = group.name
//        groupCell.nameQuestionLabelView.setNeedsDisplay()
//        print("Name view: \(groupCell.nameQuestionLabelView.description)")
//        groupCell.textCountQuestionsLabelView.text = "\(group.answered)/\(group.count)"

        print(group.name)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logger = NetworkLoggerPlugin()
        logger.configuration.logOptions = .verbose
        let provider = MoyaProvider<KexApi>(plugins: [logger])
        
        _ = provider.rx.request(.allGroups)
            .map([QuizGroup].self)
            .do(onSuccess: { result in
                self.showGroups(groups: result)
            }, onError: { error in
//                self.errorLabel.isHidden = false
//                self.errorLabel.setNeedsDisplay()
//                self.errorLabel.text = "Ошибка " + error.localizedDescription
                print("error")
            }, onSubscribe: {
//                self.errorLabel.isHidden = true
                print("onSubscribe")
            })
            .subscribe()
        
        
    }
    
    private func showGroups(groups : [QuizGroup]) {
        self.groups = groups
        groupsCollectionView.reloadData()
    }
    
    
}
