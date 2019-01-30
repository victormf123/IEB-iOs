//
//  Cenario.swift
//  IEB
//
//  Created by Matheus on 14/09/17.
//  Copyright © 2017 Matheus Freitas. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Cenario{
    
    var Titulo:String!
    var TituloAvaliacao:String!
    var Perguntas:[String] = []
    var Respostas:[Int] = []
    var cenario:String!
    var entityName:String!
    var user:String
    
    init(titulo: String, tituloAvaliacao:String, cenario:String, entityName:String, user: String! ){
        self.Titulo = titulo
        self.TituloAvaliacao = tituloAvaliacao
        self.cenario = cenario
        self.entityName = entityName
        self.user = user
    }
    
    func setPerguntas(perguntas: [String]){
        self.Perguntas = perguntas
    }
}
