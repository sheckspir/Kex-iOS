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
import Kingfisher

class FirstViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var firstLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    
    var groups : [QuizGroup] = []
    var cellID = "GroupCell"
    var countInRow = 3
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        let groupCell = (cell as! GroupViewCell)
        let group = groups[indexPath.item]
        groupCell.nameQuestionLabelView.text = group.name
        groupCell.nameQuestionLabelView.setNeedsDisplay()
        groupCell.textCountQuestionsLabelView.text = "\(group.answered)/\(group.count)"

        let url = URL(string: group.imageUrl)
        
        
        
        
        groupCell.groupImageView.kf.setImage(with: url,
                                             options: [
                                                .scaleFactor(groupCell.groupImageView.contentScaleFactor*2)])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = (collectionViewLayout as! UICollectionViewFlowLayout)
        
        
        
        let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * CGFloat(countInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(countInRow))
        
        return CGSize(width: size, height: size)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logger = NetworkLoggerPlugin()
        logger.configuration.logOptions = .verbose
        let provider = MoyaProvider<KexApi>(plugins: [logger])
        
        firstLoadingIndicator.startAnimating()
        
        _ = provider.rx.request(.allGroups)
            .map([QuizGroup].self)
            .do(onSuccess: { result in
                self.firstLoadingIndicator.stopAnimating()
                self.showGroups(groups: result)
            }, onError: { error in
                self.firstLoadingIndicator.stopAnimating()
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
