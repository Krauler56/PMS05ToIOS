//
//  TaskEditViewController.swift
//  pms05
//
//  Created by Пользователь on 01.01.2018.
//  Copyright © 2018 Пользователь. All rights reserved.
import UIKit

class TaskEditViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    

    var _task :Task?
    
    @IBOutlet weak var descLabel: UITextField!
    
    @IBOutlet weak var projectPickerVIewOutlet: UIPickerView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    var selectedIndexes:[Int] = [] {
        didSet{
            var uniqueValues = [Int]()
            var addedValues = Set<Int>()
            for value in selectedIndexes {
                if !addedValues.contains(value) {
                    addedValues.insert(value)
                    uniqueValues.append(value)
                }
            }
            selectedIndexes = uniqueValues
        }
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            "PersonCell") as? PersonCell else {return UITableViewCell()}
        cell.firstname.text=persons[indexPath.row].firstName!+" "+persons[indexPath.row].lastName!
        if (_task?.workersIds?.contains(persons[indexPath.row]._id!))!{
            selectedIndexes.append(indexPath.row)
             self.tableView.selectRow(at:  IndexPath(row: indexPath.row, section: 0), animated: false, scrollPosition: .none)
        }
            else{
           // selectedIndexes.remove(at: indexPath.row)
            }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    @IBAction func datePickerAction(_ sender: Any) {
        setDate()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cell = tableView.cellForRow(at: indexPath)
        //if(_task?.workersIds?.contains(persons[indexPath.row]._id!))!{
            selectedIndexes.append(indexPath.row)
       // }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        selectedIndexes.remove(at: selectedIndexes.index(of: indexPath.row)!)
        
    }
    func numberOfComponents(in projectPickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return projects.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return projects[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndexOfProject=row
    }
    @IBOutlet weak var projectPickerView: UIPickerView!
    func setDate()->Void
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let dateString=dateFormatter.string(from: DatePicker.date as Date)
        dateLabel.text=dateString
    }
    func getDateToTaskEdit()->String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateString=dateFormatter.string(from: DatePicker.date as Date)
        return dateString
        
    }
    func getSelectedPersonsIds()->[String]
    {
        var rowsOfPersons = [String]()
        for index in 0...persons.count
        {
            if(selectedIndexes.contains(index))
                {
                    rowsOfPersons.append(persons[index]._id!)
                }
        }
        
        
        print(rowsOfPersons)
        return rowsOfPersons
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectPickerView.delegate = self
        projectPickerView.dataSource = self
        tableView.delegate=self
        tableView.dataSource=self
        tableView.reloadData()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        DatePicker.date=dateFormatter.date(from: (_task?.deadline)!)!
        setDate()
        projectPickerVIewOutlet.selectRow(projectRowNum, inComponent: 0, animated: true)
        descLabel.text=_task?.description
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editTaskAction(_ sender: Any) {
        save()
    }
    func save() {
        let todosURL = URL(string: "http://pms5.herokuapp.com/db/tasks/"+(_task?._id)!)
        var todosUrlRequest = URLRequest(url: todosURL!)
        todosUrlRequest.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        do {
            let tasktoedit :TaskToEdit=TaskToEdit(_id: (_task?._id)!, status: (_task?.status)!, managerId: (_task?.managerId)!, deadline: getDateToTaskEdit(), description: (descLabel.text)!, workersIds:getSelectedPersonsIds(), projectId: projects[selectedIndexOfProject]._id!)
            let newTodoAsJSON = try encoder.encode(tasktoedit)
            todosUrlRequest.httpBody = newTodoAsJSON
            
        } catch let error{
            print(error)
        }
        
        // ...
        let session = URLSession.shared
        let task = session.dataTask(with: todosUrlRequest, completionHandler: {
            (data, response, error) in
            // ...
        })
        task.resume()
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
