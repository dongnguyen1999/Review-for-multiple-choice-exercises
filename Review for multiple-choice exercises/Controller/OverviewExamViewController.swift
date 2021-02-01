//
//  OverviewExamViewController.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 27/01/2021.
//

import Foundation
import UIKit

class OverviewExamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExamModelDelegate {
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var minuteNumberLabel: UILabel!
    @IBOutlet weak var nbCompleteQuestionLabel: UILabel!
    @IBOutlet weak var questionUnitLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var importantButton: UIButton!
    @IBOutlet weak var unimportantButton: UIButton!
    
    @IBOutlet weak var answerTableView: UITableView!
    
    var questionList: [QuestionModel]!
    var examModel: ExamModel!
    var status = ExamStatus.DURING
    
    var selectedNumber: Int!
    
    var overviewViewModel: OverviewViewModel!
    
    let NB_QUESTION_IN_ROW = 5
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in [subjectNameLabel, minuteLabel, nbCompleteQuestionLabel, questionUnitLabel] {
            view?.font = view?.font.italic
        }
        subjectNameLabel.text = examModel.subjectName
        let nbComplete = computeCompleteQuestion(questions: questionList)
        minuteNumberLabel.text = "\(examModel.duration):00"
        nbCompleteQuestionLabel.text = "\(nbComplete)/\(examModel.nbQuestion)"
        overviewViewModel = OverviewViewModel(examDelegate: self)
        
        answerTableView.delegate = self
        answerTableView.dataSource = self
        answerTableView.backgroundColor = .clear
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        submitButton.roundWithBorder(borderRadius: 15)
        importantButton.roundWithBorder(borderRadius: 15)
        switch status {
        case ExamStatus.DURING:
            createTimer()
            importantButton.isHidden = true
            submitButton.isHidden = false
        case ExamStatus.PREVIEW:
            submitButton.isHidden = true
            importantButton.isHidden = false
            if examModel.isImportant == 1 {
                importantButton.isHidden = true
            }
        default:
            fatalError("Overview screen must be set status")
        }
    }
    
    func computeCompleteQuestion(questions: [QuestionModel]) -> (Int) {
        var nbComplete = 0
        for question in questions {
            if question.answerTask != nil {
                nbComplete += 1
            }
        }
        return nbComplete
    }
    
    
    func createTimer() {
        if timer == nil {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
        }
        updateTimer()
    }
    
    @objc func updateTimer() {
        let currentDateTime = Date()
        let closeDateTime = Date.fromTimestamp(timestamp: examModel.closeDate)
        let miliseconds = closeDateTime!.milliseconds - currentDateTime.milliseconds
        if miliseconds <= 0 {
            timer?.invalidate()
            timer = nil
            overviewViewModel.submit(examId: examModel.examId)
            status = ExamStatus.PREVIEW
            answerTableView.reloadData()
            return
        }
        let second = (miliseconds / 1000) % 60
        let minute = (miliseconds / 1000) / 60
        minuteNumberLabel.text = "\(minute):\(second)"
        minuteNumberLabel.font = minuteNumberLabel.font.italic
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count / NB_QUESTION_IN_ROW
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerRow") as! AnswerTableViewCell

        let rowIndex = indexPath.row
        let start = rowIndex * NB_QUESTION_IN_ROW
        let end = start + NB_QUESTION_IN_ROW
        cell.backgroundColor = .clear
        cell.index = rowIndex
        cell.questionsInRow = Array(questionList[start..<end])
        cell.roundWithBorder(borderRadius: 0, borderWidth: 1, borderColor: UIColor(hex: "#F89500"))
        cell.selectionStyle = .none
        if status == ExamStatus.PREVIEW {
            cell.enableColor = true
        }
        cell.onTappedAnswerCell = self.onTappedAnswerCell(questionNumber:)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heigh = answerTableView.frame.height / CGFloat(ceil(Double(questionList.count / NB_QUESTION_IN_ROW)))
        return heigh
    }
    
    func onTappedAnswerCell(questionNumber: Int) {
        selectedNumber = questionNumber
        performSegue(withIdentifier: "BackToExam", sender: self)
    }
    
    
    @IBAction func onSubmitExam(_ sender: UIButton) {
        //Stop timer
        timer?.invalidate()
        timer = nil
        minuteNumberLabel.text = "\(examModel.duration):00"
        overviewViewModel.submit(examId: examModel.examId)
        status = ExamStatus.PREVIEW
        answerTableView.reloadData()
        viewWillAppear(true)
    }
    
    @IBAction func onImportantExam(_ sender: UIButton) {
        overviewViewModel.markImportant(examId: examModel.examId, isImportant: true)
    }
    
    @IBAction func onUnimportantExam(_ sender: UIButton) {
        print("request set unimportant")
    }
    
    func onSuccess(listExam: [ExamModel]?) {
        if let exam = listExam?[0] {
            examModel = exam
        }
        viewWillAppear(true)
//        switch status {
//        case ExamStatus.DURING:
//            status = ExamStatus.PREVIEW
//        case ExamStatus.PREVIEW:
//            print("set important success")
//        default:
//            fatalError("Overview screen must be set status")
//        }
    }
    
    func onError(message: String) {
        print(message)
    }
    
    func onDeleteSuccess(message: String) {
        print(message)
    }
    
    @IBAction func onCloseExam(_ sender: UIBarButtonItem) {
        
        var message = "Nhấn chọn đồng ý để thoát khỏi bài kiểm tra"
        if status == ExamStatus.DURING {
            message = "Bạn vẫn còn trong thời gian làm bài thi. Việc thoát khỏi bài kiểm tra sẽ tự động nộp bài thi, bạng sẽ không được sửa đổi các đáp án của mình"
        }
        
        let alert = UIAlertController(title: "Bạn có chắc muốn thoát?", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: onCloseExam(action:)))
        alert.addAction(UIAlertAction(title: "Quay lại", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    func onCloseExam(action: UIAlertAction) {
        if status == ExamStatus.DURING {
            overviewViewModel.submit(examId: examModel.examId)
        }
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    

}

