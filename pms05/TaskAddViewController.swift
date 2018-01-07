//
//  TaskEditViewController.swift
//  pms05
//
//  Created by Пользователь on 01.01.2018.
//  Copyright © 2018 Пользователь. All rights reserved.
import UIKit

class TaskAddViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    var _task :Task?
    
    
    @IBOutlet weak var descLabel: UITextField!
    @IBOutlet weak var projectPickerVIewOutlet: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
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
    var selectedIndexOfProject:Int=0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            "PersonCell") as? PersonCell else {return UITableViewCell()}
        cell.firstname.text=persons[indexPath.row].firstName!+" "+persons[indexPath.row].lastName!
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
        selectedIndexes.append(indexPath.row)
        print("DZIALA")
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedIndexes.remove(at: selectedIndexes.index(of: indexPath.row)!)
        print("Na pewno")
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
        //let rows = tableView.indexPathsForSelectedRows?.map{$0.row}//.flatMap{Array(repeating: String($0), count:1)}//Rzutowanie [Int]->[String]
        var rowsOfPersons = [String]()
        //rowsOfPersons=(_task?.workersIds)!
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
        projectPickerVIewOutlet.delegate = self
        projectPickerVIewOutlet.dataSource = self
        tableView.delegate=self
        tableView.dataSource=self
        tableView.reloadData()
        setDate()
        projectPickerVIewOutlet.selectRow(projectRowNum, inComponent: 0, animated: true)
        let dateFormatter = DateFormatter()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTask(_ sender: Any) {
        save()
    }
    
    func save() {
        let json: [String: Any] = ["status":0,"projectId" : projects[projectPickerVIewOutlet.selectedRow(inComponent: 0)]._id,"description" : descLabel.text!,"deadline" : getDateToTaskEdit() , "workersIds" : getSelectedPersonsIds()]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        print("JSONDATA"+String(describing: jsonData))
        // create post request
        let url = URL(string: "http://pms5.herokuapp.com/db/tasks/json")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                print(responseJSON)
            }
        }
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

