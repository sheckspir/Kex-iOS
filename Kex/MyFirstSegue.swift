//
//  MyFirstSegue.swift
//  Kex
//
//  Created by Александр Карамышев on 11/07/2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//
import UIKit

class MyFirstSegue : UIStoryboardSegue {
    

    override func perform() {
        print("perform MyFirstSegue")
        let src = self.source
        let dst = self.destination
        
        let navDesc = ((src.navigationController?.description) ?? "null")
        print("src " + src.description + " dst " + dst.description + " navController " + navDesc)
        dst.modalPresentationStyle = .fullScreen
        
        let id = self.identifier
        print("id " + id!)
        if (self.identifier == "Registration") {
            
        } else {
            if (src is RegistrationViewController) {
                if (dst is Authorization) {
                    src.present(dst, animated: true)
                }
            }
        }
        
    }

}
