//
//  AlertaFactory.swift
//  IEB
//
//  Created by Matheus on 14/09/17.
//  Copyright © 2017 Matheus Freitas. All rights reserved.
//

import UIKit

class AlertaFactory{
    
    var titulo:String
    var mensagem:String
    var alerta:UIAlertController!
    
    
      init(titulo:String, mensagem:String, style: UIAlertControllerStyle) {
        self.titulo = titulo
        self.mensagem = mensagem
        
        let alertController = UIAlertController(title: titulo, message: mensagem, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (UIAlertAction) in
            NSLog("Ok Pressed")
        }
        
        alertController.addAction(okAction)
        
        self.alerta = alertController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
