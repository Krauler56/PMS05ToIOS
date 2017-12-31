//
//  ProjectEditViewController.swift
//  pms05
//
//  Created by Пользователь on 30.12.2017.
//  Copyright © 2017 Пользователь. All rights reserved.
//

import UIKit

class ProjectEditViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    var project :Project?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    @IBOutlet weak var projectname: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var desc: UITextField!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            "PersonCell") as? PersonCell else {return UITableViewCell()}
        cell.firstname.text=persons[indexPath.row].firstName+" "+persons[indexPath.row].lastName
        if project?.manager[0]._id==persons[indexPath.row]._id
        {
            cell.backgroundColor=UIColor.red
        }
        return cell
    }
    var selectedIndex:Int = 0
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex=indexPath.row
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectname.text=project?.name
        desc.text=project?.description
        tableView.delegate=self
        tableView.dataSource=self
        tableView.reloadData()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitChanges(_ sender: Any) {
        
        let json: [String: Any] = ["_id": project?._id,
                                   "name": projectname,"description" : desc,"managerId":project?.managerId
                                   "manager":["_id": persons[selectedIndex]._id,
                                              "firstName": persons[selectedIndex].firstName,"lastName" : persons[selectedIndex].lastName,"email":persons[selectedIndex].email,
                                              "password":persons[selectedIndex].email,"roles" : persons[selectedIndex].roles]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://pms5.herokuapp.com/db/projects/"+(project?._id)!)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
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
