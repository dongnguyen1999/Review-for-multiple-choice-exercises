//
//  HomeViewController.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 17/01/2021.
//

import UIKit
import Charts

class HomeViewController: UIViewController, ExamModelDelegate, SubjectModelDelegate {
    @IBOutlet weak var avatarImageView: UIImageView!
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
        userModel = PreferencesUtils.getCachedUserModel()
        scoreChartView.noDataText = "Dong Nguyen"
        
        homeViewModel = HomeViewModel(examDelegate: self, subjectDelegate: self)
        homeViewModel.onGetListExam(userId: userModel.userId)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        avatarImageView.setOnTapListener(context: self, action: #selector(onTappedAvatar(sender:)))
    }
    
    @objc func onTappedAvatar(sender: UIGestureRecognizer) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let menuViewController = mainStoryboard.instantiateViewController(withIdentifier: "MenuScreen") as? MenuController else {
            print("Can not create menu screen view controller")
            return
        }
        
        navigationController?.pushViewController(menuViewController, animated: true)
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        print(startChatView.frame.size.width)
        avatarImageView.roundWithBorder()
        startExamView.roundWithBorder(borderWidth: 5, borderColor: UIColor(hex: "#f9aa33"))
        startChatView.roundWithBorder(borderWidth: 5, borderColor: UIColor(hex: "#9b52d4"))
        
        
        bestScoreView.boxShadow(offsetX: 3, offsetY: 3, opacity: 0.1, radius: 10)
        numberExamView.boxShadow(offsetX: 3, offsetY: 3, opacity: 0.1, radius: 10)
        sumExamView.boxShadow(offsetX: 3, offsetY: 3, opacity: 0.1, radius: 10)
        rateView.boxShadow(offsetX: 3, offsetY: 3, opacity: 0.1, radius: 10)
        
        chartAreaView.boxShadow(offsetX: 3, offsetY: 3, opacity: 0.2, radius: 10)
        
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
        
        for exam in exams {
            if !listBySubjectId.keys.contains(exam.subjectId) {
                let subjectId = exam.subjectId
                listBySubjectId[subjectId] = exams.filter {
                    $0.subjectId == subjectId
                }
            }
        }
        
        let sortedSubjectId = listBySubjectId.keys.sorted {
            key1, key2 in
            return (listBySubjectId[key1]?.count ?? 0) > (listBySubjectId[key2]?.count ?? 0)
        }
        
        var result = [Int: [ExamModel]]()
        for i in 0..<3 {
            result[sortedSubjectId[i]] = listBySubjectId[sortedSubjectId[i]]
        }
        return result
    }
    
    func setupChart(data: LineChartData) {
        
//        let data = LineChartData()
//
//        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug"]
//        let unitsSold = [10.0, 4.0, 6.0, 3.0, 9.0, 8.0, 4.0, 7.0, 2.0]
//
//        let months1 = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//        let unitsSold1 = [10.0, 6.0, 8.0, 9.0, 10.0, 10.0, 2.0, 9.0, 3.0, 6.0, 1.0, 2.0]
//
//        let months2 = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug"]
//        let unitsSold2 = [10.0, 10.0, 5.0, 9.0, 10.0, 10.0, 8.0, 7.0]
//
//
//        data.addDataSet(createDataset(exam: months, score: unitsSold, subject: "Lập trình python", tintColor: UIColor.red))
//        data.addDataSet(createDataset(exam: months1, score: unitsSold1, subject: "Nhập môn công nghệ phần mềm", tintColor: UIColor.green))
//        data.addDataSet(createDataset(exam: months2, score: unitsSold2, subject: "Lập trình android", tintColor: UIColor.blue))
    
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
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
            let date = dateFormatter.date(from: timestampString)
            
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
        
            
//            print("Current datetime: \(dateFormatter.string(from: currentDate))")
//
//            print("Exam datetime: \(dateFormatter.string(from: date!))")
            
            
            sumExam += 1
        }
        rateValue.text = "\(Int(sumRate*100/Float(submitedCount)))%"
        bestScoreValue.text = "\(Int(maxScore))"
        numberExamValue.text = "\(sumWeekExam)"
        sumExamValue.text = "\(sumExam)"
    }
    
    func produceChartData(exams: [ExamModel]) -> ([Int], [Int: [Float]]) {
//        produceChartData(from: exams)
        let examBySubject = getPresentSubjects(from: exams)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var time = [Int]()
        var data = [Int: [Float]]()
        
        for (subjectId, subjectExams) in examBySubject {
//            print(subjectExams)
            let sortedExams = subjectExams.sorted {
                ex1, ex2 in
                let date1 = dateFormatter.date(from: ex1.createDate)
                let date2 = dateFormatter.date(from: ex2.createDate)
                return date1 ?? Date() > date2 ?? Date()
            }
            var listScore = [Float]()
            for i in 0..<sortedExams.count {
                let ex = sortedExams[i]
                listScore.append(ex.score ?? 0)
                
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
                listScore.insert(0, at: listScore.startIndex)
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
        print("Starting chat...")
    }


}
