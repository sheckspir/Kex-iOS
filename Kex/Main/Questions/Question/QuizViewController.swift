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

class QuizViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QuestionYouMeListener, QuestionRegularListener {
    
    var groupId = -1
    var answered = 0
    var lastScrolleded = 0
    
    private let questionReqular = "QuestionRegular"
    private let questionYouAndMe = "QuestionYouMe"
    
    private let answerSaver = AnswerSaverController()
    
    
    private var questions : [Question] = []
    
    @IBOutlet weak var quizCollectionView: UICollectionView!
    @IBOutlet weak var mainProgressBar: UIActivityIndicatorView!
    
//    @IBOutlet weak var navigationBar: UINavigationBar!
//    @IBOutlet weak var customBackButton: UIBarButtonItem!
//    @objc func backAction () {
//        navigationController?.popViewController(animated: true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for the bar
//        navigationBar.tintColor = UIColor.black
//        navigationBar.backgroundColor = UIColor.blue
//        //for the button
//        navigationBar.backItem?.titleView?.tintColor = UIColor.white
//        navigationBar.backItem?.title = "Lalala"

        // Create the navigation bar
//        navigationBar.backIndicatorImage = (UIImage(named: "back.png"))
//        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//        backButton.setTitle("Back", for: UIControl.State.init())
//        backButton.setTitleColor(UIColor.blue, for: .normal)
//        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
//        navigationBar.items![0].leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationController?.setNavigationBarHidden(false, animated: false)
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
        if let layout = quizCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = quizCollectionView.superview!.bounds.width
            
            let itemHeight = quizCollectionView.superview!.bounds.height
            
            print("width = \(itemWidth)  height = \(itemHeight)")
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.estimatedItemSize = layout.itemSize
            layout.invalidateLayout()
        }
    
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
        questionCell.showQuestion(question: question, listener: self)
        
        return questionCell
    }
    
    private func showYouMeQuestion(question: Question, collectionView: UICollectionView, indexPath : IndexPath) -> UICollectionViewCell {
        let questionCell = collectionView.dequeueReusableCell(withReuseIdentifier: questionYouAndMe, for: indexPath) as! QuestionYouMeCell
        questionCell.layoutIfNeeded()
        questionCell.showQuestion(question: question, listener: self)
        
        return questionCell
    }
    
    func wantClicked(id: Int) {
        answerSaver.saveAnswer(groupId: groupId, questionId: id, answer: QuestionAnswer.LIKE)
        scrollToNextIfPossible()
    }
    
    func wantDoClicked(id: Int) {
        answerSaver.saveAnswer(groupId: groupId, questionId: id, answer: QuestionAnswer.LIKE_I_DO)
        scrollToNextIfPossible()
    }
    
    func wantBothClicked(id: Int) {
        answerSaver.saveAnswer(groupId: groupId, questionId: id, answer: QuestionAnswer.LIKE)
        scrollToNextIfPossible()
    }
    
    func wantGetClicked(id: Int) {
        answerSaver.saveAnswer(groupId: groupId, questionId: id, answer: QuestionAnswer.LIKE_I_GET)
        scrollToNextIfPossible()
    }
    
    func thinkClicked(id: Int) {
        answerSaver.saveAnswer(groupId: groupId, questionId: id, answer: QuestionAnswer.DISCUSS)
        scrollToNextIfPossible()
    }
    
    func noClicked(id: Int) {
        answerSaver.saveAnswer(groupId: groupId, questionId: id, answer: QuestionAnswer.DONT_LIKE)
        scrollToNextIfPossible()
    }
    
    
    
    private func scrollToNextIfPossible() {
        if (questions.count - 1 <= lastScrolleded) {
            startAnimating()
            answerSaver.saveAllNotSaved(onSuccess: {
                self.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            }, onError: {error in
                self.stopAnimating()
                self.showError(message: error.localizedDescription)
            })
        } else {
            scrollToPosition(position: lastScrolleded + 1, animated: true)
        }
    }
    
    private func scrollToPosition(position : Int, animated: Bool) {
        lastScrolleded = position
        quizCollectionView.scrollToItem(at: IndexPath(item: position, section: 0), at: [.centeredHorizontally], animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    private func showQuiz(questions: [Question]) {
        self.questions = questions
        quizCollectionView.reloadData()
        scrollToPosition(position: answered, animated: false)
    }
    
    private func startAnimating() {
        mainProgressBar.startAnimating()
        quizCollectionView.isUserInteractionEnabled = false
        
    }
    
    private func stopAnimating() {
        mainProgressBar.stopAnimating()
        quizCollectionView.isUserInteractionEnabled = true
    }
    
    private func showError(message : String) {
        mainProgressBar.stopAnimating()
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
