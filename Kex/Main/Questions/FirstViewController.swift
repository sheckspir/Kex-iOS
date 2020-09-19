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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is QuizViewController && sender is QuizGroup) {
            let group = sender as! QuizGroup
            (segue.destination as! QuizViewController).groupId = group.id
            (segue.destination as! QuizViewController).answered = group.answered
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = groups[indexPath.item]
        if (group.answered >= group.count) {
            let alert = UIAlertController(title: "Очистить ответы?", message: "Вы уже ответили на все вопросы, можно пройти опросник заново", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Очистить", style: .default, handler: {_ in
                let provider = MoyaProvider<KexApi>()
                
                _ = provider.rx.request(.deleteAnswers(groupData: GroupDeleteInfo(groupId: group.id)))
                .asCompletable()
                .andThen(provider.rx.request(.allGroups))
                    .map([QuizGroup].self)
                .do(onSuccess: {groups in
                    self.stopMainAnimating()
                    self.showGroups(groups: groups)
                    let innerGroup = groups[indexPath.item]
                    
                    self.performSegue(withIdentifier: "fromGroupToQuiz", sender: innerGroup)
                }, onError: {error in
                    self.stopMainAnimating()
                    self.showError(message: error.localizedDescription)
                }, onSubscribe: {
                    self.startMainAnimating()
                })
                .subscribe()
            }))
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: {_ in
                alert.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            
        } else {
            performSegue(withIdentifier: "fromGroupToQuiz", sender: group)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        let groupCell = (cell as! GroupViewCell)
        let group = groups[indexPath.item]
        groupCell.nameQuestionLabelView.text = group.name
        groupCell.nameQuestionLabelView.setNeedsDisplay()
        groupCell.textCountQuestionsLabelView.text = "\(group.answered)/\(group.count)"
        
        groupCell.contentView.setCardView()

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
    
    override func viewWillAppear(_ animated: Bool) {
        let provider = MoyaProvider<KexApi>(plugins: [])
                _ = provider.rx.request(.allGroups)
                    .map([QuizGroup].self)
                    .do(onSuccess: { result in
                        self.stopMainAnimating()
                        self.showGroups(groups: result)
                    }, onError: { error in
                        self.stopMainAnimating()
                        self.showError(message: error.localizedDescription)
                    }, onSubscribe: {
                        self.startMainAnimating()
                    })
                    .subscribe()
    }
    
    @IBAction func onAddQuestionClicked(_ sender: Any) {
        UserActions.writeToDeveloper()
    }
    
    
    private func showGroups(groups : [QuizGroup]) {
        self.groups = groups
        groupsCollectionView.reloadData()
    }
    
    private func startMainAnimating() {
        firstLoadingIndicator.startAnimating()
        groupsCollectionView.isUserInteractionEnabled = false
    }
    
    private func stopMainAnimating() {
        firstLoadingIndicator.stopAnimating()
        groupsCollectionView.isUserInteractionEnabled = true
    }
    
    private func showError(message : String) {
        
    }
    
    
}


extension UIView {

    func setCardView(){
        backgroundColor = .white
        layer.cornerRadius = 10.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.7
        
//        layer.cornerRadius = 5.0
//        layer.borderColor  =  UIColor.clear.cgColor
//        layer.borderWidth = 5.0
//        layer.shadowOpacity = 0.5
//        layer.shadowColor =  UIColor.lightGray.cgColor
//        layer.shadowRadius = 5.0
//        layer.shadowOffset = CGSize(width:5, height: 5)
//        layer.masksToBounds = true
    }
}
