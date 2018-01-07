//
//  ProjectViewController.swift
//  pms05
//
//  Created by Пользователь on 30.12.2017.
//  Copyright © 2017 Пользователь. All rights reserved.
//

import UIKit
var projects = [Project]()
var selectedIdOfProject:String=""
var selectedNameOfProject:String=""
var selectedIndexOfProject:Int=0
class ProjectViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            "ProjectCell") as? ProjectCell else {return UITableViewCell()}
        cell.name.text=projects[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         selectedIdOfProject=projects[indexPath.row]._id!
        selectedNameOfProject=projects[indexPath.row].name!
        selectedIndexOfProject=indexPath.row
          projectRowNum=indexPath.row
        performSegue(withIdentifier: "lookTasks", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? ProjectEditViewController{
            destination.project = projects[projectRowNum]
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.delegate=self
        tableView.dataSource=self
        tableView.reloadData()
        downloadJson()
    }
    @objc func RightSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        self.performSegue(withIdentifier: "addProject", sender: self)
    }
    override func viewDidLoad() {
      
        super.viewDidLoad()
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(self.RightSideBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem=button
         self.navigationItem.title="Projects"
        tableView.delegate=self
        tableView.dataSource=self
        tableView.reloadData()
        downloadJson()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    final let url = URL(string : "http://pms5.herokuapp.com/db/projects")
    func downloadJson(){
        guard let downloadURL = url else {return}
        URLSession.shared.dataTask(with: downloadURL){data,URLResponse,error in
            guard let data = data, error == nil, URLResponse != nil else {
                print("something is wrong")
                return
            }
            print("DOWNLOADED-PROJECTS")
            do
            {
                let decoder = JSONDecoder()
                let dowloadedprojects = try decoder.decode([Project].self, from: data)
                projects=dowloadedprojects
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch
            {
                print("something wrong after" )
            }
            }.resume()
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        selectedIdOfProject=projects[indexPath.row]._id!
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal,title:"Look tasks"){(action,indexPath)->Void in
            projectRowNum=indexPath.row
            self.performSegue(withIdentifier: "showProjectDetails", sender: self)
            self.isEditing = false
        }
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default,title:"Delete"){(action,indexPath)->Void in
            self.isEditing = false
            tableView.beginUpdates()
            let url = URL(string: "http://pms5.herokuapp.com/db/projects/"+projects[indexPath.row]._id!)
            print("DElete project"+projects[indexPath.row].name!)
            var request = URLRequest(url: url!)
            request.httpMethod = "DELETE"
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
            }
            task.resume()
            projects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
            
        }
        return [shareAction,deleteAction]
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
