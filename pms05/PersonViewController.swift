//
//  PersonViewController.swift
//  pms05
//
//  Created by Пользователь on 29.12.2017.
//  Copyright © 2017 Пользователь. All rights reserved.
//

import UIKit
var persons = [Person]()
class PersonViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            "PersonCell") as? PersonCell else {return UITableViewCell()}
        cell.firstname.text=persons[indexPath.row].firstName+" "+persons[indexPath.row].lastName
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        if (editingStyle == .delete){
            let url = URL(string: "http://pms5.herokuapp.com/db/persons/"+persons[indexPath.row]._id)
            print("DElete person"+persons[indexPath.row].lastName)
            var request = URLRequest(url: url!)
            request.httpMethod = "DELETE"
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
            }
            task.resume()
            persons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PersonEditViewController{
            destination.person = persons[(tableView.indexPathForSelectedRow?.row)!]
        }
        
    }
    final let url = URL(string : "http://pms5.herokuapp.com/db/persons")
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.delegate=self
        tableView.dataSource=self
        tableView.reloadData()
        downloadJson()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        tableView.reloadData()
        downloadJson()
        
        // Do any additional setup after loading the view.
    }
    
   
    func downloadJson(){
        guard let downloadURL = url else {return}
        URLSession.shared.dataTask(with: downloadURL){data,URLResponse,error in
            guard let data = data, error == nil, URLResponse != nil else {
                print("something is wrong")
                return
            }
            print("DOWNLOADED")
            do
            {
                let decoder = JSONDecoder()
                let dowloadedpersons = try decoder.decode([Person].self, from: data)
                persons=dowloadedpersons
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch
            {
                print("something wrong after" )
            }
            }.resume()
        
        }
    
    @IBAction func addUser(_ sender: Any) {
        
        performSegue(withIdentifier: "addUser", sender: self)
    }
    
    
}
