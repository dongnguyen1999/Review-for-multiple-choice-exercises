//
//  HomeViewController.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 17/01/2021.
//

import UIKit
import Charts

class HomeViewController: UIViewController, ExamModelDelegate, SubjectModelDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var avatarImageView: UIButton!
    @IBOutlet weak var startExamView: UIView!
    @IBOutlet weak var startChatView: UIView!
    
    @IBOutlet weak var bestScoreView: UIView!
    @IBOutlet weak var numberExamView: UIView!
    @IBOutlet weak var sumExamView: UIView!
    @IBOutlet weak var rateView: UIView!
    
    @IBOutlet weak var bestScoreValue: UILabel!
    @IBOutlet weak var numberExamValue: UILabel!
    @IBOutlet weak var rateValue: UILabel!
    @IBOutlet weak var sumExamValue: UILabel!
    
    @IBOutlet weak var chartAreaView: UIView!
    @IBOutlet weak var scoreChartView: LineChartView!
    
    var userModel: UserModel!
    var homeViewModel: HomeViewModel!
    var chartDataset: ([Int], [Int: [Float]])?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userModel = Prefs.getCachedUserModel()
        scoreChartView.noDataText = "Tuần qua chưa có bài kiểm tra nào"
        
        homeViewModel = HomeViewModel(examDelegate: self, subjectDelegate: self)
        homeViewModel.onGetListExam(userId: userModel.userId)
        
        navigationController?.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.setNavigationBarHidden(true, animated: false)
        } else {
            navigationController.setNavigationBarHidden(false, animated: false)
        }
    }
    
    func onSuccess(listExam: [ExamModel]?) {
        guard let exams = listExam else {
            fatalError("Api response nil for list exams")
        }
        updateFigures(exams: exams)
        chartDataset = produceChartData(exams: exams)
        if let data = chartDataset?.1 {
            homeViewModel.onGetSubjectDetails(listSubjectId: [Int](data.keys))
        }
    }
    
    func onSuccess(listSubject subjects: [SubjectModel]?) {
        guard let subjects = subjects else {
            fatalError("Api response nil for list subjects")
        }
        
        var subjectNames = [Int: String]()
        for subject in subjects {
            subjectNames[subject.subjectId] = subject.subjectName
        }
        let (time, data) = chartDataset!
        
        updateChart(time: time, data: data, subjectNames: subjectNames)
    }
    
    func onError(message: String) {
        print(message)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        userModel = Prefs.getCachedUserModel()
        if userModel.avatar == "" {
            avatarImageView.setImage(UIImage(named: "avatar"), for: UIControl.State.normal)
        } else {
            guard let url = URL(string: "\(Constants.URL.URL_SEVER)\(self.userModel.avatar)") else { return }
            if let data = try? Data(contentsOf: url) {
                 // Create Image and Update Image View
                 let image = UIImage(data: data)
                avatarImageView.setImage(image, for: UIControl.State.normal)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        print(startChatView.frame.size.width)
        avatarImageView.roundWithBorder()
        
        bestScoreView.boxShadow(offsetX: 3, offsetY: 3, opacity: 0.1, radius: 10)
        numberExamView.boxShadow(offsetX: 3, offsetY: 3, opacity: 0.1, radius: 10)
        sumExamView.boxShadow(offsetX: 3, offsetY: 3, opacity: 0.1, radius: 10)
        rateView.boxShadow(offsetX: 3, offsetY: 3, opacity: 0.1, radius: 10)
        
        chartAreaView.boxShadow(offsetX: 3, offsetY: 3, opacity: 0.1, radius: 10)
    }
    
    func createDataset(exam xAxis: [Int], score yAxis: [Float], subject label: String, tintColor color: UIColor) -> LineChartDataSet {
        var dataEntries: [ChartDataEntry] = []
                
        for i in 0..<xAxis.count {
            let entry = ChartDataEntry(x: Double(xAxis[i]), y: Double(yAxis[i]))
            dataEntries.append(entry)
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: label)
        
        chartDataSet.mode = .cubicBezier
        chartDataSet.setCircleColor(color)
        chartDataSet.circleRadius = 3
        chartDataSet.drawCirclesEnabled = true
        chartDataSet.lineWidth = 2
        chartDataSet.setColor(color)
        chartDataSet.fill = Fill(color: color)
        chartDataSet.fillAlpha = 0.2
        chartDataSet.drawFilledEnabled = true
        chartDataSet.valueTextColor = UIColor(hex: "#485465")
        
        return chartDataSet
    }
    
    func getPresentSubjects(from exams: [ExamModel]) -> [Int: [ExamModel]] {
        var listBySubjectId = [Int: [ExamModel]]()
        let today = Date()
        
        for exam in exams {
            if !listBySubjectId.keys.contains(exam.subjectId) {
                let subjectId = exam.subjectId
                listBySubjectId[subjectId] = exams.filter {
                    return ($0.subjectId == subjectId && Date.fromTimestamp(timestamp: $0.createDate)!.isInSameWeek(as: today))
                }
            }
        }
        
        let sortedSubjectId = listBySubjectId.keys.sorted {
            key1, key2 in
            return (listBySubjectId[key1]?.count ?? 0) > (listBySubjectId[key2]?.count ?? 0)
        }
        
        var result = [Int: [ExamModel]]()
        let end = min(3, listBySubjectId.count)
        for i in 0..<end {
            result[sortedSubjectId[i]] = listBySubjectId[sortedSubjectId[i]]
        }
        return result
    }
    
    func setupChart(data: LineChartData) {
    
//        let chartData = data
        scoreChartView.data = data
        scoreChartView.gridBackgroundColor = .white
        scoreChartView.drawGridBackgroundEnabled = true
        scoreChartView.minOffset = 0
        scoreChartView.leftAxis.axisMaximum = 25
        
        scoreChartView.legend.horizontalAlignment = .left
        scoreChartView.legend.verticalAlignment = .top
        scoreChartView.legend.orientation = .vertical
        scoreChartView.legend.drawInside = true
        scoreChartView.legend.font = UIFont(name: "Verdana", size: 12.0)!
        scoreChartView.legend.textColor = UIColor(hex: "#485465")

        let xAxis = scoreChartView.xAxis
        xAxis.drawAxisLineEnabled = false
        xAxis.drawLabelsEnabled = false
        xAxis.drawGridLinesEnabled = false
        let leftAxis = scoreChartView.leftAxis
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawGridLinesEnabled = false
        let rightAxis = scoreChartView.rightAxis
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawLabelsEnabled = false
        rightAxis.drawGridLinesEnabled = false
        
        scoreChartView.roundWithBorder(borderRadius: 10)
        
        
    }
    
    func updateFigures(exams: [ExamModel]) {
        var sumWeekExam = 0
        var sumExam = 0
        var maxScore = -Float.infinity
        var sumRate: Float = 0
        var submitedCount = 0
        let currentDate = Date()
        
        for exam in exams {
            let timestampString = exam.createDate
    
            let date = Date.fromTimestamp(timestamp: timestampString)
            
            if let sameWeek = date?.isInSameWeek(as: currentDate), sameWeek {
                sumWeekExam += 1
                if let score = exam.score {
                    submitedCount += 1
                    if score > maxScore {
                        maxScore = score
                    }
                    sumRate += score / Float(exam.nbQuestion)
                }
            }
            sumExam += 1
        }
        
        if maxScore == -Float.infinity {
            maxScore = 0
        }
        var rate = 0
        if submitedCount != 0 {
            rate = Int(sumRate*100/Float(submitedCount))
        }
        rateValue.text = "\(rate)%"
        bestScoreValue.text = "\(Int(maxScore))"
        numberExamValue.text = "\(sumWeekExam)"
        sumExamValue.text = "\(sumExam)"
    }
    
    func produceChartData(exams: [ExamModel]) -> ([Int], [Int: [Float]]) {
//        produceChartData(from: exams)
        let examBySubject = getPresentSubjects(from: exams)
        
        var time = [Int]()
        var data = [Int: [Float]]()
        
        for (subjectId, subjectExams) in examBySubject {
//            print(subjectExams)
            let sortedExams = subjectExams.sorted {
                ex1, ex2 in
                let date1 = Date.fromTimestamp(timestamp: ex1.createDate)
                let date2 = Date.fromTimestamp(timestamp: ex2.createDate)
                return date1 ?? Date() < date2 ?? Date()
            }
            var listScore = [Float]()
            for i in 0..<sortedExams.count {
                let ex = sortedExams[i]
                let score = ex.score ?? 0
                listScore.append(score)
                if time.firstIndex(of: i) == nil {
                    time.append(i)
                } else  {
                    time[i] = i
                }
            }
            data[subjectId] = listScore
//            print(time)
        }
        return (time, data)
    }
    
    
    func updateChart(time: [Int], data: [Int: [Float]], subjectNames: [Int: String]) {
        let chartData = LineChartData()
        let chartColors = [UIColor(hex: "#BB6BD9"), UIColor(hex: "#6FCF97"), UIColor(hex: "#EB5757")]
        
        var colorIndex = 0
        for var (subjectId, listScore) in data {
            while listScore.count < time.count {
                listScore.insert(0, at: 0)
            }
            chartData.addDataSet(createDataset(exam: time, score: listScore, subject: subjectNames[subjectId] ?? "Mã môn học \(subjectId)", tintColor: chartColors[colorIndex]))
            colorIndex += 1
        }
        setupChart(data: chartData)
    }
    
    
    @IBAction func onTapStartExam(_ sender: UITapGestureRecognizer) {
        print("Starting exam...")
    }
    
    @IBAction func onTapStartChat(_ sender: UITapGestureRecognizer) {

    }
    
    func onDeleteSuccess(message: String) {
        print(message)
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        homeViewModel.onGetListExam(userId: userModel.userId)
   }


}
