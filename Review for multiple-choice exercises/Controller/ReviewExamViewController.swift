//
//  ReviewExamViewController.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 03/02/2021.
//

import UIKit

class ReviewExamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var sampleData = ["lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem ", "lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem ", "lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem ", "lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem "]
    
    @IBOutlet weak var reviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTableView.dataSource = self
        reviewTableView.delegate = self
        reviewTableView.rowHeight = UITableView.automaticDimension
        reviewTableView.estimatedRowHeight = 600
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell") as! ReviewExamTableViewCell
        cell.questionLabel.text = sampleData[indexPath.row]
        return cell
    }
    
}
