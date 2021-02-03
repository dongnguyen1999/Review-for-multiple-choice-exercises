//
//  ReviewExamViewController.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 03/02/2021.
//

import UIKit

class ReviewExamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, QuestionModelDelegate, ExamModelDelegate {
    
    var examId: Int!
    var questionList = [QuestionModel]()
    var questionViewModel: QuestionViewModel!
    var examViewModel: ExamViewModel!
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var doneTimeLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var reviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTableView.dataSource = self
        reviewTableView.delegate = self
        reviewTableView.rowHeight = UITableView.automaticDimension
        reviewTableView.estimatedRowHeight = 600
        
        questionViewModel = QuestionViewModel(questionDelegate: self)
        examViewModel = ExamViewModel(examDelegate: self)
        questionViewModel.onGetListQuestion(examId: examId)
        examViewModel.getExamDetail(examId: examId)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell") as! ReviewExamTableViewCell
        let index = indexPath.row
        let question = questionList[index]
        cell.setQuestion(index: index, question: question)
        return cell
    }
    
    
    // Question delegate
    func onSuccess(listQuestion: [QuestionModel]?) {
        if let questions = listQuestion {
            questionList = questions
            reviewTableView.reloadData()
        }
    }
    
    func onSuccess(message: String) {
        print(message)
    }
    
    func onError(message: String) {
        print(message)
    }
    
    // Exam delegate
    func onSuccess(listExam: [ExamModel]?) {
        if let exam = listExam?[0] {
            subjectNameLabel.text = exam.subjectName
            let createDateTime = Date.fromTimestamp(timestamp: exam.createDate)
            let closeDateTime = Date.fromTimestamp(timestamp: exam.closeDate)
            let miliseconds = closeDateTime!.milliseconds - createDateTime!.milliseconds
            let second = (miliseconds / 1000) % 60
            let minute = (miliseconds / 1000) / 60
            createDateLabel.text = createDateTime?.toFormart(formatString: "dd/MM/yyyy")
            doneTimeLabel.text = "\(minute):\(second)"
            if let score = exam.score {
                scoreLabel.text = "\(Int(score))/\(exam.nbQuestion)"
            } else {
                scoreLabel.text = "?/\(exam.nbQuestion)"
            }
        }
    }
    
    func onDeleteSuccess(message: String) {
        print(message)
    }
    
    
}
