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
    
    @IBOutlet weak var EditAddProjectLabel: UILabel!
    @IBOutlet weak var projectname: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var desc: UITextField!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            "PersonCell") as? PersonCell else {return UITableViewCell()}
        cell.firstname.text=persons[indexPath.row].firstName!+" "+persons[indexPath.row].lastName!
        if project?.manager![0]._id==persons[indexPath.row]._id
        {
            selectedIndex=indexPath.row
            self.tableView.selectRow(at:  IndexPath(row: indexPath.row, section: 0), animated: false, scrollPosition: .none)
          //  cell.backgroundColor=UIColor.red
        }
        else
        {
         //   cell.backgroundColor=UIColor.blue
        }
        return cell
    }
    var selectedIndex:Int = 0
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ind = IndexPath(row:selectedIndex,section:0)
        var cellOld:UITableViewCell = tableView.cellForRow(at: ind)!
        var cellNew:UITableViewCell = tableView.cellForRow(at: indexPath)!
        //cellNew.contentView.backgroundColor=UIColor.red
        //cellOld.contentView.backgroundColor=UIColor.blue
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
        EditAddProjectLabel.text="Edit project "+(project?.name)!
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitChanges(_ sender: Any) {
        var personsarray = [Person]()
        personsarray.append(persons[selectedIndex] )
        project?.setNameDescManager(name: projectname.text!, description: desc.text!, manager: personsarray)
        save()
    }
    
    func save() {
        // ...
        let todosURL = URL(string: "http://pms5.herokuapp.com/db/projects/"+(project?._id)!)
        var todosUrlRequest = URLRequest(url: todosURL!)
        todosUrlRequest.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        do {
            let newTodoAsJSON = try encoder.encode(project)
            todosUrlRequest.httpBody = newTodoAsJSON
        } catch {
            print("ERROR WITH HTTP PUT PROJECT")
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
