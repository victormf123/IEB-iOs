//
//  ViewController.swift
//  IEB
//
//  Created by Matheus on 11/09/17.
//  Copyright © 2017 Matheus Freitas. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.fire     
        let user = Auth.auth()
        
        do {
            try user.signOut()
        } catch {
            print("erro ao fazer signOut")
        }
    }
    
    @IBAction func login(_ sender: Any) {
        let user = Auth.auth()
        
        if self.email.text != nil && self.pass.text != nil{
            user.signIn(withEmail: self.email.text!, password: self.pass.text!, completion: { (user, erro) in
                if erro == nil {
                    
                    let destinationView = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                    self.present(destinationView, animated: true, completion: nil)
                    
                }else{
                    let erroAlertController = AlertaFactory(titulo:"Atenção!", mensagem:"você digitou a senha ou email errado, tente novamente.", style: UIAlertControllerStyle.alert)
                    self.present(erroAlertController.alerta, animated: true, completion: nil)
                }
            })
        }else{
            let erroAlertController = AlertaFactory(titulo:"Atenção!", mensagem:"Senha ou Usuario em nulo", style: UIAlertControllerStyle.alert)
            self.present(erroAlertController.alerta, animated: true, completion: nil)
        }
        
        
        
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

