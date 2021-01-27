//
//  FacultySearchController.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/20/21.
//

import UIKit

class FacultySearchController: UIViewController, FacultyModelDelegate, UITableViewDelegate, UITableViewDataSource, MajorModelDeledate, SubjectSearchModelDelegate, UISearchBarDelegate {

    //Khai baó
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var facultytableView: UITableView!
    @IBOutlet weak var majortableView: UITableView!
    @IBOutlet weak var subjecttableView: UITableView!
    
    @IBOutlet weak var subjectSearchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
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
        
        facultysearchmodel=FacultySearchModelView(facultydelegate: self)
        facultysearchmodel.ListFaculty()
        majorsearchmodel = MajorSearchModelView(majormodeldelegate: self)
        subjectsearchmodel = SubjectSearchModelView(subjectmodeldelegate: self)
        
        //design searchBar
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.delegate = self
      
        //custom segment
        segmentedControl.roundWithBorder(borderWidth: 0, borderColor: UIColor(hex: "#F4F8FF"))
        facultytableView.backgroundColor = UIColor.clear
        majortableView.backgroundColor = UIColor.clear
        subjecttableView.backgroundColor = UIColor.clear
        //tắt keyboard
   
    }
   
    // Tìm kiếm theo tên
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        segmentedControl.selectedSegmentIndex = 2
        subjecttableView.isHidden = true
        facultytableView.isHidden = true
        majortableView.isHidden = true
        subjectSearchTableView.isHidden = false
        subjectsearchmodel.ListSubjectSearch()
        if searchText.isEmpty == false{
            filteredData = subject.filter({$0.subjectName.lowercased().contains(searchText.lowercased())})
            
        }else{
            segmentedControl.selectedSegmentIndex = 0
            subjecttableView.isHidden = true
            facultytableView.isHidden = false
            majortableView.isHidden = true
            subjectSearchTableView.isHidden = true
        }
        
        subjectSearchTableView.reloadData()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        subjectSearchTableView.reloadData()
 
    }
    //menu segment
    @IBAction func actionSegmented(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            facultytableView.isHidden = false
            majortableView.isHidden = true
            subjecttableView.isHidden = true
            subjectSearchTableView.isHidden = true
            major.removeAll()
            majortableView.reloadData()
           
        case 1:
            facultytableView.isHidden = true
            majortableView.isHidden = false
            subjecttableView.isHidden = true
            major.removeAll()
            majortableView.reloadData()
        
      
        case 2:
            facultytableView.isHidden = true
            majortableView.isHidden = true
            subjecttableView.isHidden = false
            subject.removeAll()
            subjecttableView.reloadData()
        default:
            break;
        }
        
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
           // self.facultytableView.deleteRows(at: [indexPath], with: .automatic)
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
            print("Some things Wrong!!")
        }
        
            return cell
       
        
    }
    //Onclick cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case facultytableView:
            facultytableView.deselectRow(at: indexPath, animated: true)
            majorsearchmodel.ListMajor(facultyId: faculty[indexPath.row].facultyId)
            facultytableView.isHidden = true
            majortableView.isHidden = false
            subjecttableView.isHidden = true
            segmentedControl.selectedSegmentIndex = 1
            
            
            
        case majortableView:
            majortableView.deselectRow(at: indexPath, animated: true)
            //subjectsearchmodel.ListSubject(majorId: 25)
            subjectsearchmodel.ListSubject(majorId: major[indexPath.row].majorId)
            facultytableView.isHidden = true
            majortableView.isHidden = true
            subjecttableView.isHidden = false
            segmentedControl.selectedSegmentIndex = 2
            //chuyền id môn sang bài thi
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
