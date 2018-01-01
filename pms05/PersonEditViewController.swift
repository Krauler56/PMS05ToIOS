//
//  PersonEditViewController.swift
//  pms05
//
//  Created by Пользователь on 30.12.2017.
//  Copyright © 2017 Пользователь. All rights reserved.
//

import UIKit

class PersonEditViewController: UIViewController {
    var person :Person?
    @IBOutlet weak var personEditId: UILabel!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var isadministrator: UISwitch!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var ismanager: UISwitch!
    @IBOutlet weak var issupermanager: UISwitch!
    @IBOutlet weak var isworker: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        personEditId.text="Edit a person "+(person?.firstName)!+" "+(person?.lastName)!
        firstname.text=person?.firstName
        lastname.text=person?.lastName
        email.text=person?.email
        isadministrator.isOn=(person?.roles?.contains("A"))!
        ismanager.isOn=(person?.roles?.contains("M"))!
        issupermanager.isOn=(person?.roles?.contains("S"))!
        isworker.isOn=(person?.roles?.contains("W"))!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func rolesBuilder()->String
    {
        var roles:String = ""
        if(isadministrator.isOn)
        {
            roles.append("A")
        }
        if(ismanager.isOn)
        {
            roles.append("M")
        }
        if(issupermanager.isOn)
        {
            roles.append("S")
        }
        if(isworker.isOn)
        {
            roles.append("W")
        }
        return roles
    }
    @IBAction func submitChanges(_ sender: Any) {
        
        let json: [String: Any] = ["_id": person?._id,
                                   "firstName": firstname.text,"lastName" : lastname.text,"email":email.text,
                                   "password":person?.password,"roles" :rolesBuilder()]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://pms5.herokuapp.com/db/persons/"+(person?._id)!)!
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
