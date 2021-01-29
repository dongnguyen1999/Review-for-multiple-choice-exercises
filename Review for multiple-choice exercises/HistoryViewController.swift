//
//  HistoryViewController.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 20/01/2021.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExamModelDelegate {
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var importantTableView: UITableView!
    
    
    @IBOutlet weak var pagingView: PagingView!
    @IBOutlet weak var allExamButton: UIButton!
    @IBOutlet weak var importantExamButton: UIButton!
    @IBOutlet weak var backButton: UIImageView!
    
//    var presentData: [ExamModel]!
    var presentData = [ExamModel]()
    var importantPresentData = [ExamModel]()
    var dataSet: [ExamModel]!
    var importantDataSet: [ExamModel]!
    
    var userModel: UserModel!
    var historyViewModel: HistoryViewModel!
    var facultyNames = [Int: String]()
    
    var historyType = HistoryViewType.ALL_HISTORY

    var rateColorList = [UIColor(hex: "#f44336"), UIColor(hex: "#9c27af"), UIColor(hex: "#3f51b5"), UIColor(hex: "#00bcd4"), UIColor(hex: "#4cae50")]
    
    static let PRESENT_LIMIT = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userModel = Prefs.getCachedUserModel()
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.alwaysBounceVertical = false
        historyTableView.backgroundColor = UIColor.clear
        
        importantTableView.delegate = self
        importantTableView.dataSource = self
        importantTableView.alwaysBounceVertical = false
        importantTableView.backgroundColor = UIColor.clear
        
        allExamButton.roundWithBorder(borderRadius: 10)
        importantExamButton.roundWithBorder(borderRadius: 10)
        
        historyViewModel = HistoryViewModel(examDelegate: self)
        historyViewModel.onGetListExam(userId: userModel.userId)
        
        pagingView.tintColor = .orange
        pagingView.onChangePageCallback = self.changePage(pageNumber:)

     
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if dataSet != nil {
            switch historyType {
            case HistoryViewType.ALL_HISTORY:
                pagingView.setNumberOfPage(totalPage: Int(ceil( Float(dataSet.count) / Float(HistoryViewController.PRESENT_LIMIT))))
                if pagingView.totalPage != 0 {
                    showDataPage(pageNumber: 0)
                }
            case HistoryViewType.IMPORTANT_HISTORY:
                pagingView.setNumberOfPage(totalPage: Int(ceil( Float(importantDataSet.count) / Float(HistoryViewController.PRESENT_LIMIT))))
                if pagingView.totalPage != 0 {
                    showDataPage(pageNumber: 0)
                }
            default:
                fatalError("Unknown history type")
            }
        }
        
        switch historyType {
        case HistoryViewType.ALL_HISTORY:
            allExamButton.backgroundColor = UIColor(hex: "#FF671B")
            allExamButton.setTitleColor(UIColor.white, for: .normal)
            importantExamButton.backgroundColor = .clear
            importantExamButton.setTitleColor(UIColor(hex: "#B6B9BE"), for: .normal)
            historyTableView.isHidden = false
            importantTableView.isHidden = true
        case HistoryViewType.IMPORTANT_HISTORY:
            importantExamButton.backgroundColor = UIColor(hex: "#FF671B")
            importantExamButton.setTitleColor(UIColor.white, for: .normal)
            allExamButton.backgroundColor = .clear
            allExamButton.setTitleColor(UIColor(hex: "#B6B9BE"), for: .normal)
            historyTableView.isHidden = true
            importantTableView.isHidden = false
        default:
            fatalError("Unknown history type")
        }
    }
    
    @objc func backToMenu(sender: UIGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        
////        historyTableView.backgroundColor = UIColor(white: 0, alpha: 0)
////        historyTableView.roundWithBorder(borderRadius: 15)
////        historyTableView.boxShadow(offsetX: 3, offsetY: 3, opacity: 0.2, radius: 15)
//        firstLoadView = false
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        tableView.estimatedRowHeight = 85.0
//        tableView.rowHeight = UITableView.automaticDimension
        let heigh = self.historyTableView.frame.height / CGFloat(HistoryViewController.PRESENT_LIMIT)
        return heigh
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case historyTableView:
            return presentData.count
        case importantTableView:
            return importantPresentData.count
        default:
            fatalError("Unknown tableView")
        }
        
    }
    
    let titleButtonAttributes: [NSAttributedString.Key: Any] = [
          .font: UIFont.systemFont(ofSize: 14),
          .foregroundColor: UIColor.blue,
          .underlineStyle: NSUnderlineStyle.single.rawValue]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: HistoryTableViewCell
        let exam: ExamModel
        switch tableView {
        case historyTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
            exam = presentData[indexPath.row]
        case importantTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "importantHistoryCell", for: indexPath) as! HistoryTableViewCell
            exam = importantPresentData[indexPath.row]
        default:
            fatalError("Unknown tableView")
        }
        
        let attributeString = NSMutableAttributedString(string: "Xem lại",
                                                             attributes: titleButtonAttributes)
        cell.reviewButton.setAttributedTitle(attributeString, for: .normal)
        
//        cell.contentView.roundWithBorder(borderRadius: 15)
        cell.contentView.boxShadow(offsetX: 3, offsetY: 3, opacity: 0.2, radius: 15)
        var color = UIColor.black
        if let score = exam.score {
            color = rateColorList[Int(score)/5]
        }
        
        cell.color = color
        cell.facultyNameLabel.text = exam.facultyName
        cell.subjectNameLabel.text = exam.subjectName
        cell.createDateLabel.text = Date.fromTimestamp(timestamp: exam.createDate)?.toFormart(formatString: "dd/MM/yyyy")
        
        if let score = exam.score {
            cell.scoreLabel.text = "\(Int(score))/\(exam.nbQuestion)"
        } else {
            cell.scoreLabel.text = "?/\(exam.nbQuestion)"
        }
        return cell
    }
    
    func onSuccess(listExam: [ExamModel]?) {
        if let exams = listExam {
            dataSet = exams
            importantDataSet = [ExamModel]()
            for exam in exams {
                if exam.isImportant == 1 {
                    importantDataSet.append(exam)
                }
            }
            viewWillAppear(true)
        }
    }
    
    func onError(message: String) {
        print(message)
    }
    
    func showDataPage(pageNumber page: Int, limit: Int = HistoryViewController.PRESENT_LIMIT) {
        switch historyType {
        case HistoryViewType.ALL_HISTORY:
            guard page < dataSet.count else {
                fatalError("Page index out of range")
            }
            presentData.removeAll()
            let start = limit * page
            var end = start + limit
            if end > dataSet.count {
                end = dataSet.count
            }
            for ex in dataSet[start..<end] {
                presentData.append(ex)
            }
            historyTableView.reloadData()
        case HistoryViewType.IMPORTANT_HISTORY:
            guard page < importantDataSet.count else {
                fatalError("Page index out of range")
            }
            importantPresentData.removeAll()
            let start = limit * page
            var end = start + limit
            if end > importantDataSet.count {
                end = importantDataSet.count
            }
            for ex in importantDataSet[start..<end] {
                importantPresentData.append(ex)
            }
            importantTableView.reloadData()
        default:
            fatalError("Unknown history type")
        }
        
        
    }
    
    func changePage(pageNumber page: Int) {
        showDataPage(pageNumber: page)
    }
    
    func onDeleteSuccess(message: String) {
        print(message)
    }
    
    @IBAction func onClickAllHistoryButton(_ sender: UIButton) {
        historyType = HistoryViewType.ALL_HISTORY
        viewWillAppear(true)
    }
    
    @IBAction func onClickImportantHistoryButton(_ sender: Any) {
        historyType = HistoryViewType.IMPORTANT_HISTORY
        viewWillAppear(true)
    }
}
