//
//  PartnerMatchViewController.swift
//  Kex
//
//  Created by Alex on 19.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class PartnerMatchViewController: UIViewController, UITableViewDataSource, QuestionClickListener {
    
    
    private let questionCellId = "QuestionInfoCell"
    private let groupCellId = "GroupTitleCell"
    private var connectionData : [ConnectionData] = []
    
    var partner : Partner? = nil
    
    @IBOutlet weak var titleNavigationBar: UINavigationBar!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var matchTableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is QuestionInfoViewController && sender is (QuizGroup, Question)) {
            let destination = segue.destination as! QuestionInfoViewController
            let tempSended = sender as! (QuizGroup, Question)
            destination.groupId = tempSended.0.id
            destination.question = tempSended.1
            destination.partner = partner!
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        connectionData.forEach({one in
            if (one.questions.count > 0) {
                count+=1
                count+=one.questions.count
            }
        })
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = getItem(position: indexPath.item)
        if (item is QuizGroup) {
            let cell = tableView.dequeueReusableCell(withIdentifier: groupCellId)
            (cell as! TitleGroupCell).showGroup(group: item as! QuizGroup)
            return cell!
        } else if (item is (QuizGroup, Question)) {
            let cell = tableView.dequeueReusableCell(withIdentifier: questionCellId)
            let group = (item as! (QuizGroup, Question)).0
            let question = (item as! (QuizGroup, Question)).1
            (cell as! QuestionInfoCell).showQuestionInfo(question: question, group: group, listener: self)
            return cell!
        }
        return UITableViewCell()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = "Выбрать партнёра"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        if (partner == nil) {
            navigationController?.popViewController(animated: true)
            return
        }
        
        titleNavigationBar.backgroundColor = UIColor.white
        titleNavigationBar?.topItem?.title = "Совападения с \(partner!.name)"
        
        let provider = MoyaProvider<KexApi>(plugins: [])
        
        _ = provider.rx.request(.getMatch(partnerId: partner!.id))
            .map([ConnectionData].self)
        .do(onSuccess: {data in
            self.hideLoading()
            self.showMatch(connection: data)
        }, onError: {error in
            self.hideLoading()
            self.showError(message: error.localizedDescription)
        }, onSubscribe: {
            self.showLoading()
        }, onDispose: {
            self.hideLoading()
        })
        .subscribe()

        // Do any additional setup after loading the view.
    }
    
    func onQuestionClicked(group: QuizGroup, question: Question) {
        performSegue(withIdentifier: "toQuestionInfo", sender: (group, question))
    }
    
    private func showMatch(connection : [ConnectionData]) {
        self.connectionData = connection
        matchTableView.isHidden = false
        matchTableView.reloadData()
        
        let count = tableView(matchTableView, numberOfRowsInSection: 1)
        if (count <= 0) {
            showError(message: "У вас пока нет совпадений, пройдите больше опросников")
        }
        
    }
    
    private func showLoading(){
        loadingIndicator.startAnimating()
        matchTableView.isHidden = true
        errorLabel.isHidden = true
    }
    
    private func hideLoading() {
        loadingIndicator.stopAnimating()
    }
    
    private func showError(message : String) {
        errorLabel.isHidden = false
        errorLabel.text = message
        matchTableView.isHidden = true
    }


    private func getItem(position: Int) -> Any? {
        var tempPosition = 0
        for one in connectionData {
            let lastTempPosition = tempPosition
            if (one.questions.count > 0) {
                tempPosition+=1
                tempPosition+=one.questions.count
                
                if(tempPosition > position) {
                    let realPosition = position - lastTempPosition - 1
                    if (realPosition >= 0) {
                        return (one.quizGroup, one.questions[realPosition])
                    } else {
                        return one.quizGroup
                    }
                }
            }
        }
        return nil
    }

}
