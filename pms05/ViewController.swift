//
//  ViewController.swift
//  pms05
//
//  Created by Пользователь on 28.12.2017.
//  Copyright © 2017 Пользователь. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var loginfield: UITextField!
    @IBOutlet var passwordfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginaction(_ sender: Any) {
        DoLogin(_user: loginfield.text!, _psw: passwordfield.text!)
        
    }
    func DoLogin(_user:String,_psw:String)
    {
        let json: [String: Any] = ["login": _user,
                                   "password": _psw]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://localhost:8888/auth")!
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
    
}

