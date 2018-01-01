//
//  ProjectAddViewController.swift
//  pms05
//
//  Created by Пользователь on 01.01.2018.
//  Copyright © 2018 Пользователь. All rights reserved.
//

import UIKit

class ProjectAddViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var AddProjectLabel: UILabel!
    @IBOutlet weak var projectname: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            "PersonCell") as? PersonCell else {return UITableViewCell()}
        cell.firstname.text=persons[indexPath.row].firstName!+" "+persons[indexPath.row].lastName!
        if(indexPath.row==0){
            cell.backgroundColor=UIColor.red
        }
        else{
            cell.backgroundColor=UIColor.blue
        }
            return cell
    }
    var selectedIndex:Int = 0
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ind = IndexPath(row:selectedIndex,section:0)
        var cellOld:UITableViewCell = tableView.cellForRow(at: ind)!
        var cellNew:UITableViewCell = tableView.cellForRow(at: indexPath)!
        cellNew.contentView.backgroundColor=UIColor.red
        cellOld.contentView.backgroundColor=UIColor.blue
        selectedIndex=indexPath.row
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        tableView.reloadData()
        self.hideKeyboardWhenTappedAround()
        AddProjectLabel.text="Add project"
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func save() {
        let json: [String: Any] = ["name" : projectname.text!,"description" : desc.text!,"managerId" : persons[selectedIndex]._id]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        print("JSONDATA"+String(describing: jsonData))
        // create post request
        let url = URL(string: "http://pms5.herokuapp.com/db/projects/json")!
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
    
    @IBAction func addNewProject(_ sender: Any) {
        save()
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
