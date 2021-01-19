//
//  HomeViewController.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 17/01/2021.
//

import UIKit
import Charts

class HomeViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var startExamView: UIView!
    @IBOutlet weak var startChatView: UIView!
    
    @IBOutlet weak var bestScoreView: UIView!
    @IBOutlet weak var numberExamView: UIView!
    @IBOutlet weak var sumExamView: UIView!
    @IBOutlet weak var rateView: UIView!
    
    @IBOutlet weak var chartAreaView: UIView!
    @IBOutlet weak var scoreChartView: LineChartView!
    
    let userId = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreChartView.noDataText = "Dong Nguyen"
            
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
        
        setupChart()
    }
    
    func createDataset(exam xAxis: [String], score yAxis: [Double], subject label: String, tintColor color: UIColor) -> LineChartDataSet {
        var dataEntries: [ChartDataEntry] = []
                
        for i in 0..<xAxis.count {
            let entry = ChartDataEntry(x: Double(i), y: yAxis[i])
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
    
    func setupChart() {
        
        let data = LineChartData()
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug"]
        let unitsSold = [10.0, 4.0, 6.0, 3.0, 9.0, 8.0, 4.0, 7.0, 2.0]
        
        let months1 = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold1 = [10.0, 6.0, 8.0, 9.0, 10.0, 10.0, 2.0, 9.0, 3.0, 6.0, 1.0, 2.0]
        
        let months2 = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug"]
        let unitsSold2 = [10.0, 10.0, 5.0, 9.0, 10.0, 10.0, 8.0, 7.0]
        
        
        data.addDataSet(createDataset(exam: months, score: unitsSold, subject: "Lập trình python", tintColor: UIColor.red))
        data.addDataSet(createDataset(exam: months1, score: unitsSold1, subject: "Nhập môn công nghệ phần mềm", tintColor: UIColor.green))
        data.addDataSet(createDataset(exam: months2, score: unitsSold2, subject: "Lập trình android", tintColor: UIColor.blue))
    
        let chartData = data
        scoreChartView.data = chartData
        scoreChartView.gridBackgroundColor = .white
        scoreChartView.drawGridBackgroundEnabled = true
        scoreChartView.minOffset = 0
        scoreChartView.leftAxis.axisMaximum = 15
        
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
    
    
    @IBAction func onTapStartExam(_ sender: UITapGestureRecognizer) {
        print("Starting exam...")
    }
    
    @IBAction func onTapStartChat(_ sender: UITapGestureRecognizer) {
        print("Starting chat...")
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
