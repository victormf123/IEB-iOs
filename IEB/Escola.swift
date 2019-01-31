//
//  Escola.swift
//  IEB
//
//  Created by Matheus Freitas on 30/01/19.
//  Copyright © 2019 Matheus Freitas. All rights reserved.
//

import UIKit

class Escola{
    
    var latitude:Double!
    var longitude:Double!
    var nomeFantasia:String!
    var logradouro:String!
    
    
    private func buscarListaDeEscolas(latitude: String, longitude: String) -> [Escola]{
        var escolas = [Escola]()
        let escola = Escola()
        let url = URL(string: "http://mobile-aceite.tcu.gov.br/mapa-da-saude/rest/estabelecimentos/latitude/\(latitude)/longitude/\(longitude)/raio/50")
        let task = URLSession.shared.dataTask(with: url!) { (dados, response, erro) in
            if erro == nil {
                
                if let content = dados{
                    
                    do{
                        
                        
                        let objetoJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                        for item in objetoJson{
                            //ToDo: retorna uma Dictionary
                            
                            if let dicionario = item as? NSDictionary{
                                print("==== INICIO ==== Escola")
                                print(item)
                                print("==== FIM ==== Escola")
                                if let latitude = dicionario["lat"]{
                                    escola.latitude = latitude as? Double
                                }
                                if let longitude = dicionario["long"]{
                                    escola.longitude = longitude as? Double
                                }
                                if let nomeFantasia = dicionario["nomeFantasia"]{
                                    escola.nomeFantasia = nomeFantasia as? String
                                }
                                if let logradouro = dicionario["logradouro"]{
                                    escola.logradouro = logradouro as? String
                                }
                                
                                escolas.append(escola)
                            }
                            
                        }
                        
                        
                    }catch{
                        print("ERRO AO CONVERTER")
                    }
                }
                
            }else{
                print("Sucesso ao acessar url ERRO: \(String(describing: erro))")
            }
        }
        task.resume()
        
        return escolas
    }
    
    private func buscarEscola(latitude: String, longitude: String) -> Escola {
        let escola = Escola()
        return escola
    }
}
