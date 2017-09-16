//
//  SocialViewController.swift
//  IEB
//
//  Created by Matheus on 14/09/17.
//  Copyright © 2017 Matheus Freitas. All rights reserved.
//

import UIKit
import FirebaseAuth


class SocialViewController: UIViewController {
    
    var email:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let user = Auth.auth()
        user.addStateDidChangeListener { (autenticacao, user) in
            if let usuario = user{
                self.email = String(describing: usuario.uid)
                print("===== EMAIL =====")
                print(self.email)
                print("===== EMAIL =====")
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let viewControllerDestino = segue.destination as! DetalhesSocialViewController
        
       
                if segue.identifier == "segueEducacao"{
                    viewControllerDestino.objeto = Cenario(titulo: "Educação", tituloAvaliacao: "Avaliação - Educação", cenario:"educacao", entityName: "EducacaoRespostas", user: "\(self.email!)")
                }
                if segue.identifier == "segueTransporte"{
                    viewControllerDestino.objeto = Cenario(titulo: "Transporte", tituloAvaliacao: "Avaliação - Transporte", cenario: "transporte", entityName: "TransporteRespostas", user: "\(self.email!)")
                }
                if segue.identifier == "segueSaude"{
                    viewControllerDestino.objeto = Cenario(titulo: "Saúde", tituloAvaliacao: "Avaliação - Saúde", cenario: "saude", entityName: "SaudeRespostas", user: "\(self.email)")
                }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
