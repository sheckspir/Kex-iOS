//
//  PartnersViewController.swift
//  Kex
//
//  Created by Alex on 15.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit

class PartnersViewController: UIViewController, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func onFindNewClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSearchPartner", sender: nil)
    }
}
