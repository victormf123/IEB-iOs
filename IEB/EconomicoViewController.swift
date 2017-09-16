//
//  EconomicoViewController.swift
//  IEB
//
//  Created by Matheus on 16/09/17.
//  Copyright © 2017 Matheus Freitas. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class EconomicoViewController: UIViewController {
    
    var user:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let user = Auth.auth()
        
        user.addStateDidChangeListener { (auth, user) in
            if let usuarioLogado = user{
                print("usuario está logado! \(String(describing: usuarioLogado.email))")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
