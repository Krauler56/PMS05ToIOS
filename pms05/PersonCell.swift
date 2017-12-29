//
//  Person.swift
//  pms05
//
//  Created by Пользователь on 29.12.2017.
//  Copyright © 2017 Пользователь. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {
   
    
    @IBOutlet weak var firstname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var secondname: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
