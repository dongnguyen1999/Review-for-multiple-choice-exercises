//
//  FacultySearchController.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/20/21.
//

import UIKit

class FacultySearchController: UIViewController, FacultyModelDelegate, UITableViewDelegate, UITableViewDataSource, MajorModelDeledate, SubjectSearchModelDelegate, UISearchBarDelegate {

    
    //Ánh xạ
    @IBOutlet weak var facultytableView: UITableView!
    @IBOutlet weak var majortableView: UITableView!
    @IBOutlet weak var subjecttableView: UITableView!
    @IBOutlet weak var subjectSearchTableView: UITableView!
    @IBOutlet weak var btnfaculty: UIButton!
    @IBOutlet weak var btnmajor: UIButton!
    @IBOutlet weak var btnsubject: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewbackground: UIView!
    @IBOutlet weak var stackview: UIStackView!
    //Khai báo
    var facultysearchmodel : FacultySearchModelView!
    var majorsearchmodel : MajorSearchModelView!
    var subjectsearchmodel :SubjectSearchModelView!
    let cellSpacingHeight: CGFloat = 5
    var faculty : [FacultyModel] = []
    var major : [MajorModel] = []
    var subject : [SubjectModel] = []
    var filteredData : [SubjectModel] = []
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      
        facultytableView.delegate = self
        facultytableView.dataSource = self
        facultytableView.isHidden = false
        majortableView.delegate = self
        majortableView.dataSource = self
        majortableView.isHidden = true
        subjecttableView.delegate = self
        subjecttableView.dataSource = self
        subjecttableView.isHidden = true
        subjectSearchTableView.delegate = self
        subjectSearchTableView.dataSource = self
        subjectSearchTableView.isHidden = true
        
        searchBar.delegate = self
        facultysearchmodel=FacultySearchModelView(facultydelegate: self)
        facultysearchmodel.ListFaculty()
        majorsearchmodel = MajorSearchModelView(majormodeldelegate: self)
        subjectsearchmodel = SubjectSearchModelView(subjectmodeldelegate: self)
        
       
        facultytableView.backgroundColor = UIColor.clear
        majortableView.backgroundColor = UIColor.clear
        subjecttableView.backgroundColor = UIColor.clear
        //Khởi tạo màu button
        btnfaculty.backgroundColor = UIColor(hex: "9069CD")
        btnmajor.backgroundColor = UIColor(hex: "F4F8FF")
        btnsubject.backgroundColor = UIColor(hex: "F4F8FF")
       //Thay đổi background Image
        viewbackground?.contentMode = UIView.ContentMode.scaleToFill
        viewbackground.layer.contents = UIImage(named:"background_history")?.cgImage
        stackview.layer.contents = UIImage(named:"background_history")?.cgImage
        searchBar.layer.contents = UIImage(named:"background_history")?.cgImage
        
      
        
    }
    
   
   
    
    
    // Tìm kiếm theo tên môn
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       // segmentedControl.selectedSegmentIndex = 2
        subjecttableView.isHidden = true
        facultytableView.isHidden = true
        majortableView.isHidden = true
        subjectSearchTableView.isHidden = false
        subjectsearchmodel.ListSubjectSearch()
        
        if searchText.isEmpty == false{
            let filterD = NSPredicate(format: "self contains[d] %@", "hoang")
            filteredData = subject.filter({$0.subjectName.lowercased().contains(searchText.lowercased())})
        }else{
            //segmentedControl.selectedSegmentIndex = 0
            subjecttableView.isHidden = true
            facultytableView.isHidden = false
            majortableView.isHidden = true
            subjectSearchTableView.isHidden = true
            }
        
        subjectSearchTableView.reloadData()
        
    }
    //Cancle tìm kiếm
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        subjectSearchTableView.reloadData()
        
    }

    //Sự kiện click button chọn khoa
    @IBAction func ActionBtnFaculty(_ sender: UIButton) {
        btnfaculty.backgroundColor = UIColor(hex: "9069CD")
        btnsubject.backgroundColor = UIColor(hex: "F4F8FF")
        btnmajor.backgroundColor = UIColor(hex: "F4F8FF")
        facultytableView.isHidden = false
        majortableView.isHidden = true
        subjecttableView.isHidden = true
        subjectSearchTableView.isHidden = true
        major.removeAll()
        majortableView.reloadData()
    }
    //Sự kiện click button chọn nghành
    @IBAction func ActionBtnMajor(_ sender: UIButton) {
        btnmajor.backgroundColor = UIColor(hex: "9069CD")
        btnsubject.backgroundColor = UIColor(hex: "F4F8FF")
        btnfaculty.backgroundColor = UIColor(hex: "9069CD")
        facultytableView.isHidden = true
        majortableView.isHidden = false
        subjecttableView.isHidden = true
        major.removeAll()
        majortableView.reloadData()
        majorsearchmodel.ListMajorSearch()
    }
    //Sự kiện click button chọn môn
    @IBAction func ActionBtnSubject(_ sender: Any) {
        btnsubject.backgroundColor = UIColor(hex: "9069CD")
        btnmajor.backgroundColor = UIColor(hex: "9069CD")
        btnfaculty.backgroundColor = UIColor(hex: "9069CD")
        facultytableView.isHidden = true
        majortableView.isHidden = true
        subjecttableView.isHidden = false
        subject.removeAll()
        subjecttableView.reloadData()
        subjectsearchmodel.ListSubjectSearch()
    }

    // table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        switch tableView {
        case facultytableView:
            numberOfRow = faculty.count
        case majortableView:
          
            numberOfRow = major.count
            
        case subjecttableView:
            numberOfRow = subject.count
        case subjectSearchTableView:
            numberOfRow = filteredData.count
        default:
            print("Không")
        }
        return numberOfRow
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch tableView {
        case facultytableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
            cell.textLabel?.text = faculty[indexPath.row].facultyName
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            cell.textLabel?.textColor = UIColor(red: 0.565, green: 0.412, blue: 0.804, alpha: 1)
          
        case majortableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "majorcell",for: indexPath)
            cell.textLabel?.text = major[indexPath.row].majorName
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            cell.textLabel?.textColor = UIColor(red: 0.565, green: 0.412, blue: 0.804, alpha: 1)
            
        case subjecttableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "subjectcell", for: indexPath)
           cell.textLabel?.text = subject[indexPath.row].subjectName
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            cell.textLabel?.textColor = UIColor(red: 0.565, green: 0.412, blue: 0.804, alpha: 1)
            
        case subjectSearchTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "subjectsearch", for: indexPath)
            cell.textLabel?.text = filteredData[indexPath.row].subjectName
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            cell.textLabel?.textColor = UIColor(red: 0.565, green: 0.412, blue: 0.804, alpha: 1)
        
        default:
           break
        }
        
            return cell
       
    }
    //Sự kiện click cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case facultytableView:
            facultytableView.deselectRow(at: indexPath, animated: true)
            majorsearchmodel.ListMajor(facultyId: faculty[indexPath.row].facultyId)
            facultytableView.isHidden = true
            majortableView.isHidden = false
            subjecttableView.isHidden = true
            // Đổi màu button khi chọn
            btnfaculty.backgroundColor = UIColor(hex: "9069CD")
            btnmajor.backgroundColor = UIColor(hex: "9069CD")
            btnsubject.backgroundColor = UIColor(hex: "F4F8FF")
        case majortableView:
            
            majortableView.deselectRow(at: indexPath, animated: true)
            subjectsearchmodel.ListSubject(majorId: major[indexPath.row].majorId)
            facultytableView.isHidden = true
            majortableView.isHidden = true
            subjecttableView.isHidden = false
            // Đổi màu button khi chọn
            btnfaculty.backgroundColor = UIColor(hex: "9069CD")
            btnmajor.backgroundColor = UIColor(hex: "9069CD")
            btnsubject.backgroundColor = UIColor(hex: "9069CD")
            
        case subjecttableView:
            print("subjectId:\(subject[indexPath.row].subjectId)+Name:\(subject[indexPath.row].subjectName)")
        case subjectSearchTableView:
            print("subjectId:\(subject[indexPath.row].subjectId)+Name:\(subject[indexPath.row].subjectName)")
        default:
           break
        }
       }
   
  
    //list faculty
    func onSuccess(listFaculty: [FacultyModel]?) {
        if let listFaculty = listFaculty {
            faculty = listFaculty
            //filteredData = faculty
            facultytableView.reloadData()
        }
    }
    
    func onError(message: String) {
        print(message)
    }
    //list major
    func onSuccessMajor(listMajor: [MajorModel]?) {
        if let listMajor = listMajor {
            major = listMajor
            majortableView.reloadData()
        }
    }
    func onErrorMajor(message: String) {
        major.removeAll()
        majortableView.reloadData()
    }
    //list subject
    func onSuccessSubject(listSubject: [SubjectModel]?) {
        if let listSubject = listSubject {
            print(listSubject.count)
            subject = listSubject
            filteredData = subject
            subjecttableView.reloadData()
        }
    }
    
    func onErrorSubject(message: String) {
        subject.removeAll()
        subjecttableView.reloadData()
    }
    
}

