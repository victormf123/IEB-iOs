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
                if segue.identifier == "segueTransporte"{
                    let viewControllerDestino = segue.destination as! TransporteViewController
                    viewControllerDestino.objeto = Cenario(titulo: "Transporte", tituloAvaliacao: "Avaliação - Transporte", cenario: "transporte", entityName: "TransporteRespostas", user: "\(self.email!)")
                }
                if segue.identifier == "segueSaude"{
                    let tableViewControllerDestino = segue.destination as! DadosDetalhesSocialTableViewController
                    tableViewControllerDestino.objeto = Cenario(titulo: "Saúde", tituloAvaliacao: "Avaliação - Saúde", cenario: "saude", entityName: "SaudeRespostas", user: "\(self.email!)")
                }
        
                if segue.identifier == "segueEducacao"{
                    let tableViewControllerDestino = segue.destination as! DadosDetalhesSocialTableViewController
                    tableViewControllerDestino.objeto = Cenario(titulo: "Educação", tituloAvaliacao: "Avaliação - Educação", cenario:"educacao", entityName: "EducacaoRespostas", user: "\(self.email!)")
                }
       
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
