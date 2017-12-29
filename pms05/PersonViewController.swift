//
//  PersonViewController.swift
//  pms05
//
//  Created by Пользователь on 29.12.2017.
//  Copyright © 2017 Пользователь. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {
    final let url = URL(string : "http://localhost:8888/db/persons")
    var persons = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.persons=dowloadedpersons
                print(self.persons[0].firstName)
            }catch
            {
                print("something wrong after" )
            }
            }.resume()
        
        }
    

}
