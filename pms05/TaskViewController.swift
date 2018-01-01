
import UIKit
var tasks = [Task]()
var projectRowNum:Int = 0
class TaskViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            "TaskCell") as? TaskCell else {return UITableViewCell()}
        print("HELLOWORLD")
        cell.taskDescLabel.text=tasks[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        downloadJson()
        tableView.delegate=self
        tableView.dataSource=self
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTask", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? TaskEditViewController{
            destination._task = tasks[(tableView.indexPathForSelectedRow?.row)!]
        }
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        downloadJson()
        tableView.delegate=self
        tableView.dataSource=self
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadJson(){
        var url = URL(string : "http://pms5.herokuapp.com/db/tasks/projectId="+selectedIdOfProject)
        guard let downloadURL = url else {return}
        URLSession.shared.dataTask(with: downloadURL){data,URLResponse,error in
            guard let data = data, error == nil, URLResponse != nil else {
                print("something is wrong")
                return
            }
            print(url)
            do
            {
                let decoder = JSONDecoder()
                let dowloadedtasks = try decoder.decode([Task].self, from: data)
                tasks=dowloadedtasks
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch let error
            {
                print(error)
            }
            }.resume()
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default,title:"Delete"){(action,indexPath)->Void in
            self.isEditing = false
            tableView.beginUpdates()
            let url = URL(string: "http://pms5.herokuapp.com/db/tasks/"+tasks[indexPath.row]._id!)
            print("DElete task"+tasks[indexPath.row].description!)
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
        return [deleteAction]
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

