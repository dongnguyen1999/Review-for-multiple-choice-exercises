//
//  HistoryViewController.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 20/01/2021.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExamModelDelegate {
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var pagingView: PagingView!
    @IBOutlet weak var allExamButton: UIButton!
    @IBOutlet weak var importantExamButton: UIButton!
    @IBOutlet weak var backButton: UIImageView!
    
//    var presentData: [ExamModel]!
    var presentData = [ExamModel]()
    var dataSet: [ExamModel]!
    
    var userModel: UserModel!
    var historyViewModel: HistoryViewModel!
    var facultyNames = [Int: String]()

    var rateColorList = [UIColor(hex: "#f44336"), UIColor(hex: "#9c27af"), UIColor(hex: "#3f51b5"), UIColor(hex: "#00bcd4"), UIColor(hex: "#4cae50")]
    
    static let PRESENT_LIMIT = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userModel = Prefs.getCachedUserModel()
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.alwaysBounceVertical = false
        historyTableView.backgroundColor = UIColor.clear
        
        allExamButton.roundWithBorder(borderRadius: 10)
        importantExamButton.roundWithBorder(borderRadius: 10)
        
        historyViewModel = HistoryViewModel(examDelegate: self)
        historyViewModel.onGetListExam(userId: userModel.userId)
        
        pagingView.onChangePageCallback = self.changePage(pageNumber:)
        
//        self.historyTableView.estimatedRowHeight = 44
//        self.historyTableView.rowHeight = UITableView.automaticDimension
        backButton.setOnTapListener(context: self, action: #selector(backToMenu(sender:)))
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
        return presentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        let exam = presentData[indexPath.row]
        
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
            pagingView.setNumberOfPage(totalPage: Int(ceil( Float(dataSet.count) / Float(HistoryViewController.PRESENT_LIMIT))))
            showDataPage(pageNumber: 0)
        }
    }
    
    func onError(message: String) {
        print(message)
    }
    
    func showDataPage(pageNumber page: Int, limit: Int = HistoryViewController.PRESENT_LIMIT) {
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
    }
    
    func changePage(pageNumber page: Int) {
        showDataPage(pageNumber: page)
    }
    
    func onDeleteSuccess(message: String) {
        print(message)
    }
}
