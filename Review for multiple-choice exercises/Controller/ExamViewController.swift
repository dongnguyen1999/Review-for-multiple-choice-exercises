//
//  ExamViewController.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 22/01/2021.
//

import Foundation
import UIKit

class ExamViewController: UIViewController, QuestionModelDelegate {
    
    @IBOutlet weak var questionNumberView: UIView!
    @IBOutlet weak var questionNumberBorder1: UIView!
    @IBOutlet weak var questionNumberBorder2: UIView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionNumberLabel: UILabel!
    
    @IBOutlet weak var questionContentLabel: UILabel!
    
    @IBOutlet weak var constraintQuestionNumber: NSLayoutConstraint!
    @IBOutlet weak var constrainQuestionView: NSLayoutConstraint!
    @IBOutlet weak var constrainBottomBackground: NSLayoutConstraint!
    
    @IBOutlet weak var aAnswerView: UIView!
    @IBOutlet weak var bAnswerView: UIView!
    @IBOutlet weak var dAnswerView: UIView!
    @IBOutlet weak var cAnswerView: UIView!
    @IBOutlet weak var pagingView: PagingView!
    
    @IBOutlet weak var aAnswerLabel: UILabel!
    @IBOutlet weak var bAnswerLabel: UILabel!
    @IBOutlet weak var cAnswerLabel: UILabel!
    @IBOutlet weak var dAnswerLabel: UILabel!
    
    @IBOutlet weak var correctAmountImage: UIImageView!
    @IBOutlet weak var correctAmount: UILabel!
    @IBOutlet weak var incorrectAmount: UILabel!
    @IBOutlet weak var incorrectAmountImage: UIImageView!
    
    @IBOutlet weak var questionCompleteLabel: UILabel!
    @IBOutlet weak var maxQuestionLabel: UILabel!
    @IBOutlet weak var answerView: UIStackView!
    
    var examModel: ExamModel!
    var subjectModel: SubjectModel!
    var questionList: [QuestionModel]!
    var nbCompleteQuestion = 0
    
    var questionViewModel: QuestionViewModel!
    var status = ExamStatus.DURING
    
    var timer: Timer?
    var remainTimeLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagingView.tintColor = UIColor.orange
        
//        "examId": "83",
//        "userId": "3",
//        "subjectId": "4",
//        "createDate": "2021-01-26 15:40:31",
//        "closeDate": "2021-01-26 16:25:31",
//        "duration": "45",
//        "score": null,
//        "nbQuestion": "20"
        
//        examModel = ExamModel()
//        examModel.examId = 83
//        examModel.userId = 3
//        examModel.subjectId = 4
//        examModel.createDate = "2021-01-26 15:40:31"
//        examModel.closeDate =  "2021-01-26 16:25:31"
//        examModel.duration = 45
//        examModel.nbQuestion = 20
        
        if examModel == nil {
            examModel = Prefs.getCachedExamModel()
        } else {
            examModel.subjectName = subjectModel.subjectName
            Prefs.cacheExamModel(model: examModel)
        }
        
        pagingView.setNumberOfPage(totalPage: examModel.nbQuestion)
        maxQuestionLabel.text = "\(examModel.nbQuestion)"
        pagingView.onChangePageCallback = self.showQuestion(index:)
        
        questionViewModel = QuestionViewModel(questionDelegate: self)
        questionViewModel.onGetListQuestion(examId: examModel.examId)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        
        switch status {
            case ExamStatus.DURING:
                print("In during exam mode")
                for view in [correctAmount, correctAmountImage, incorrectAmount, incorrectAmountImage] {
                    view?.isHidden = true
                }
                setupAnswerViews()
                setupTimerView()
                createTimer()
                
            case ExamStatus.PREVIEW:
                for view in [correctAmount, correctAmountImage, incorrectAmount, incorrectAmountImage] {
                    view?.isHidden = false
                }
                answerView.isUserInteractionEnabled = false
                remainTimeLabel.isHidden = true
                print("In preview mode")
            default:
                fatalError("Exam view controller must be set status")
        }
        
    }
    
    
    
    func setupOverviewView() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "Tổng quan"
        let leftButton = UIBarButtonItem(customView: label)
        label.setOnTapListener(context: self, action: #selector(onClickOverview(sender:)))
        self.navigationItem.leftBarButtonItem  = leftButton
    }
    
    func setupTimerView() {
        remainTimeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 21))
        remainTimeLabel.textAlignment = .center
        remainTimeLabel.textColor = .black
        remainTimeLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        remainTimeLabel.text = "Thời gian cỏn lại"
        let rightButton = UIBarButtonItem(customView: remainTimeLabel)
        self.navigationItem.rightBarButtonItem  = rightButton
    }
    
    @objc func onClickOverview(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "PushOverview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? OverviewExamViewController {
            dest.examModel = examModel
            dest.questionList = questionList
            dest.status = status
            dest.selectedNumber = pagingView.activePage + 1
            dest.examViewController = self
        }
    }
    
    func showQuestion(index: Int) {
        if let question = questionList[index] as QuestionModel? {
            questionNumberLabel.text = "\(index+1)"
            questionContentLabel.text = question.questionName
            questionCompleteLabel.text = "\(nbCompleteQuestion)"
            aAnswerLabel.text = question.answer1
            bAnswerLabel.text = question.answer2
            cAnswerLabel.text = question.answer3
            dAnswerLabel.text = question.answer4
            
            let views = [aAnswerView, bAnswerView, cAnswerView, dAnswerView]
            for view in views {
                view!.roundWithBorder(borderRadius: 5, borderWidth: 1, borderColor: UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2))
            }
            if let answer = question.answerTask {
                switch status {
                    case ExamStatus.DURING:
                        views[answer-1]!.roundWithBorder(borderRadius: 5, borderWidth: 1, borderColor: UIColor(hex: "#F89500"))
                    case ExamStatus.PREVIEW:
                        if answer == question.answer {
                            views[answer-1]!.roundWithBorder(borderRadius: 5, borderWidth: 1, borderColor: UIColor(hex: "#6FCF97"))
                        }
                        else {
                            views[answer-1]!.roundWithBorder(borderRadius: 5, borderWidth: 1, borderColor: UIColor(hex: "#F89500"))
                            views[question.answer-1]!.roundWithBorder(borderRadius: 5, borderWidth: 1, borderColor: UIColor(hex: "#FF6D6D"))
                        }
                    default:
                        fatalError("Exam view controller must be set status")
                }
            } else if status == ExamStatus.PREVIEW {
                views[question.answer-1]!.roundWithBorder(borderRadius: 5, borderWidth: 1, borderColor: UIColor(hex: "#FF6D6D"))
            }
            
        }
    }
    
    func setupAnswerViews() {
        let answers = [aAnswerView, bAnswerView, cAnswerView, dAnswerView]
        
        for i in 0..<answers.count {
            let answer = answers[i]
            answer?.restorationIdentifier = "\(i)"
            answer?.setOnTapListener(context: self, action: #selector(self.onAnswerTapped(sender:)))
        }
    }
    
    @objc func onAnswerTapped(sender: UIGestureRecognizer) {
        let tappedAnswer = sender.view!
        let index = Int(tappedAnswer.restorationIdentifier!)
        let selectedQuestion = pagingView.activePage
        let question = questionList[selectedQuestion]
        if question.answerTask == nil {
            question.answerTask = index! + 1
            nbCompleteQuestion += 1
        } else if question.answerTask == index! + 1 {
            question.answerTask = nil
            nbCompleteQuestion -= 1
        } else {
            question.answerTask = index! + 1
        }
        questionViewModel.answerQuestion(examId: examModel.examId, questionId: question.questionId, answer: question.answerTask)
        showQuestion(index: pagingView.activePage)
    }

    

    override func viewWillAppear(_ animated: Bool) {
        constraintQuestionNumber.constant =  -1*(questionNumberBorder2.frame.width / 2)
//        constrainQuestionView.constant =  -1*(questionView.frame.height / 3)
        constrainBottomBackground.constant = (questionView.frame.height/2)
        questionNumberView.roundWithBorder()
        questionNumberBorder1.roundWithBorder()
        questionNumberBorder2.roundWithBorder()
        
        questionView.boxShadow(offsetX: 0, offsetY: 3, opacity: 0.2, radius: 15)
        
        for view in [aAnswerView, bAnswerView, cAnswerView, dAnswerView] {
            view!.roundWithBorder(borderRadius: 5, borderWidth: 1, borderColor: UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2))
        }
        
        if questionList != nil {
            showQuestion(index: pagingView.activePage)
        }
        
        setupOverviewView()
        
        
        switch status {
            case ExamStatus.DURING:
                print("In during exam mode")
                for view in [correctAmount, correctAmountImage, incorrectAmount, incorrectAmountImage] {
                    view?.isHidden = true
                }
                
            case ExamStatus.PREVIEW:
                print("In during exam mode")
                for view in [correctAmount, correctAmountImage, incorrectAmount, incorrectAmountImage] {
                    view?.isHidden = false
                }
                let (complete, correct, incorrect) = computeCompleteQuestion(questions: questionList)
                nbCompleteQuestion = complete
                correctAmount.text = "\(correct)"
                incorrectAmount.text = "\(incorrect)"
                
                timer?.invalidate()
                timer = nil
                answerView.isUserInteractionEnabled = false
                remainTimeLabel.isHidden = true
                print("In preview mode")
            default:
                fatalError("Exam view controller must be set status")
        }
        
    }
    
    
    func onSuccess(listQuestion: [QuestionModel]?) {
        if let questions = listQuestion {
            questionList = questions
            let (complete, correct, incorrect) = computeCompleteQuestion(questions: questionList)
            nbCompleteQuestion = complete
            correctAmount.text = "\(correct)"
            incorrectAmount.text = "\(incorrect)"
            showQuestion(index: pagingView.activePage)
        }
    }
    
    func computeCompleteQuestion(questions: [QuestionModel]) -> (Int, Int, Int) {
        var correct = 0
        var incorrect = 0
        var nbComplete = 0
        for question in questions {
            if question.answerTask != nil {
                nbComplete += 1
                if question.answerTask == question.answer {
                    correct += 1
                } else {
                    incorrect += 1
                }
            }
        }
        return (nbComplete, correct, incorrect)
    }
    
    func onSuccess(message: String) {
        print(message)
    }
    
    func onError(message: String) {
        print(message)
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
            performSegue(withIdentifier: "PushOverview", sender: self)
            return
        }
        let second = (miliseconds / 1000) % 60
        let minute = (miliseconds / 1000) / 60
        remainTimeLabel.text = "\(minute):\(second)s"
    }
    
    @IBAction func unwindToExam(segue: UIStoryboardSegue) {
        if let source = segue.source as? OverviewExamViewController, let selectedNumber = source.selectedNumber {
            let index = selectedNumber - 1
            pagingView.activePage = index
            status = source.status
            viewWillAppear(true)
        }
   }
    
    

}
