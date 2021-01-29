//
//  ReadyStartViewController.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 22/01/2021.
//

import Foundation
import UIKit

class ReadyStartViewController: UIViewController, ExamModelDelegate {
    
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    var userModel: UserModel!
    var subjectModel: SubjectModel!
    var examModel: ExamModel!
    
    var examViewModel: ExamViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userModel = Prefs.getCachedUserModel()
        
        loadSampleSubject()
        
        startButton.roundWithBorder(borderRadius: 15)
        
        subjectNameLabel.font = subjectNameLabel.font.italic
        durationLabel.font = durationLabel.font.italic
        minuteLabel.font = minuteLabel.font.italic
        
        subjectNameLabel.text = subjectModel.subjectName
        
        examViewModel = ExamViewModel(examDelegate: self)
        examViewModel.startExam(userId: userModel.userId, subjectId: subjectModel.subjectId)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ExamViewController {
            dest.subjectModel = subjectModel
            dest.examModel = self.examModel
        }
        
        if segue.destination is HomeViewController {
            examViewModel.cancelTemporatyExam(examId: examModel.examId)
        }
    }
    
    func loadSampleSubject() {
        subjectModel = SubjectModel()
        subjectModel.subjectId = 4
        subjectModel.subjectName = "Hoá học"
        subjectModel.majorId = 25
    }
    
    
    func onSuccess(listExam: [ExamModel]?) {
        if let exam = listExam?[0] {
            durationLabel.text = "\(exam.duration):00"
            examModel = exam
        }
    }
    
    func onError(message: String) {
        print(message)
    }
    
    func onDeleteSuccess(message: String) {
        print(message)
    }

    
}
