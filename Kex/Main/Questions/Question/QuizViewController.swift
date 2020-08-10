//
//  QuizViewController.swift
//  Kex
//
//  Created by Alex on 06.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class QuizViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var groupId = 0
    
    private let questionReqular = "QuestionRegular"
    private let questionYouAndMe = "QuestionYouMe"
    
    private var questions : [Question] = []
    
    @IBOutlet weak var quizCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let provider = MoyaProvider<KexApi>()
                
        startAnimating()
        
                
        _ = provider.rx.request(.getQuizQuestions(groupId: self.groupId))
                    .map([Question].self)
                    .do(onSuccess: { result in
                        self.showQuiz(questions: result)
                        self.stopAnimating()
                    }, onError: { error in
                        self.stopAnimating()
                        self.showError(message: error.localizedDescription)
                    })
                    .subscribe()

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.questions.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let question = questions[indexPath.item]

        if (question.type == QuizType.STANDARD) {
            return showStandartQuestion(question: question, collectionView: collectionView, indexPath: indexPath)
        } else {
            return showYouMeQuestion(question: question, collectionView: collectionView, indexPath: indexPath)
        }
    }
    
    private func showStandartQuestion(question: Question, collectionView: UICollectionView, indexPath : IndexPath) -> UICollectionViewCell {
        let questionCell = collectionView.dequeueReusableCell(withReuseIdentifier: questionReqular, for: indexPath) as! QuestionRegularCell
        questionCell.layoutIfNeeded()
        questionCell.showQuestion(question: question)
        
        return questionCell
    }
    
    private func showYouMeQuestion(question: Question, collectionView: UICollectionView, indexPath : IndexPath) -> UICollectionViewCell {
        let questionCell = collectionView.dequeueReusableCell(withReuseIdentifier: questionYouAndMe, for: indexPath) as! QuestionYouMeCell
        questionCell.layoutIfNeeded()
        questionCell.showQuestion(question: question)
        
        return questionCell
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
        
        if let layout = quizCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            print("width \(view.bounds.width) height = \(view.bounds.height)")
            let itemWidth = view.bounds.width
//            let itemHeight = view.bounds.height
            let itemHeight = CGFloat(774)
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.estimatedItemSize = layout.itemSize
            layout.invalidateLayout()
        }
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        return CGSize(width: 300, height: 400)
//        print("collection view create size")
//        return CGSize(width: (view.frame.size.width), height: (view.frame.size.height))
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
////        return view.frame.size
//        return CGSize(width: 500, height: 500)
//    }
//
    private func showQuiz(questions: [Question]) {
        self.questions = questions
        quizCollectionView.reloadData()
    }
    
    private func startAnimating() {
        
    }
    
    private func stopAnimating() {
        
    }
    
    private func showError(message : String) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
