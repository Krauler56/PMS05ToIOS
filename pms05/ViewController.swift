//
//  ViewController.swift
//  pms05
//
//  Created by Пользователь on 28.12.2017.
//  Copyright © 2017 Пользователь. All rights reserved.
//

import UIKit
var loggedPerson :Person?
class ViewController: UIViewController {
    //let loginPerson:Person
    @IBOutlet var loginfield: UITextField!
    @IBOutlet var passwordfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden=true
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginaction(_ sender: Any) {
        DoLogin(_user: loginfield.text!, _psw: passwordfield.text!)
        
    }
    func createAlert(titleText : String,messageText : String)
    {
        let alert = UIAlertController(title: titleText, message : messageText,preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
        alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
    }
    func DoLogin(_user:String,_psw:String)
    {
        let json: [String: Any] = ["login": _user,
                                   "password": _psw]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://pms5.herokuapp.com/auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do
            {
                let decoder = JSONDecoder()
                let prs = try decoder.decode(Person.self, from: data)
                loggedPerson=prs
                if(loggedPerson?.firstName==nil)
                {
                    print("BAD LOGIN")
                    self.createAlert(titleText: "Error", messageText: "Bad e-mail or password")
                }
                else
                {
                     self.performSegue(withIdentifier: "loginSeg", sender: self)
                }
            }catch let error
            {
                print(error)
            }
           /* let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                if(String(describing: responseJSON)=="[:]"){
                    print("BAD LOGIN")
                    self.createAlert(titleText: "Error", messageText: "Bad e-mail or password")
                }
                else
                {
                    self.performSegue(withIdentifier: "loginSeg", sender: self)
                }
            }*/
        }
        task.resume()
    }
    
    
}

