//
//  SocialViewController.swift
//  IEB
//
//  Created by Matheus on 14/09/17.
//  Copyright © 2017 Matheus Freitas. All rights reserved.
//

import UIKit


class SocialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let viewControllerDestino = segue.destination as! DetalhesSocialViewController
        
        if segue.identifier == "segueEducacao"{
            viewControllerDestino.objeto = Cenario(titulo: "Educação", tituloAvaliacao: "Avaliação - Educação", cenario: "educacao")
        }
        if segue.identifier == "segueTransporte"{
            viewControllerDestino.objeto = Cenario(titulo: "Transporte", tituloAvaliacao: "Avaliação - Transporte", cenario: "transporte")
        }
        if segue.identifier == "segueSaude"{
             viewControllerDestino.objeto = Cenario(titulo: "Saúde", tituloAvaliacao: "Avaliação - Saúde", cenario: "saude")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
