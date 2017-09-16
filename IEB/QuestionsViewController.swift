//
//  QuestionsViewController.swift
//  IEB
//
//  Created by Matheus on 14/09/17.
//  Copyright © 2017 Matheus Freitas. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreData

class QuestionsViewController: UIViewController {
    
    var objeto:Cenario!
    
    var respostasRecuperadas: [NSManagedObject] = []
    
    @IBOutlet weak var p001: UILabel!
    @IBOutlet weak var p002: UILabel!
    @IBOutlet weak var p003: UILabel!
    @IBOutlet weak var p004: UILabel!
    @IBOutlet weak var p005: UILabel!
    
    
    @IBOutlet weak var r001: RatingControl!
    @IBOutlet weak var r002: RatingControl!
    @IBOutlet weak var r003: RatingControl!
    @IBOutlet weak var r004: RatingControl!
    @IBOutlet weak var r005: RatingControl!
    
    @IBAction func enviarVoto(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if self.verificarSeTemResposta(context: context){
            
            let alertController = UIAlertController(title: "Atenção!", message: "Você já Realizou aX avaliação, espere ate o proximo ciclo", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (UIAlertAction) in
                
                if let navigation = self.navigationController {
                    navigation.popViewController(animated: true)
                }
            }
            
            alertController.addAction(okAction)
            present(alertController, animated: true, completion:nil)
        }else{
            self.SalvarDadosCoreData(context: context)
        }
        
    
    }
    
    private func SalvarDadosCoreData(context: NSManagedObjectContext){
            /*
             Salvando dados no CoreData
             
             */
            let formatacaoData = DateFormatter()
                formatacaoData.dateFormat = "dd/MM/yyyy hh:mm:ss"
            let data = formatacaoData.string(from: Date())
        
            let resposta = NSEntityDescription.insertNewObject(forEntityName: self.objeto.entityName, into: context)
        
            resposta.setValue(data, forKey: "data")
            resposta.setValue(self.r001.rating, forKey: "r001")
            resposta.setValue(self.r002.rating, forKey: "r002")
            resposta.setValue(self.r003.rating, forKey: "r003")
            resposta.setValue(self.r004.rating, forKey: "r004")
            resposta.setValue(self.r005.rating, forKey: "r005")
            /*
                Salvando Respostas no Firebase
            */
        
            let db = Database.database().reference()
        
            let respostas = db.child("Respostas")
            let usuarioResposta = respostas.child(self.objeto.user)
            let etityResposta = usuarioResposta.child(self.objeto.entityName)
            etityResposta.child("data").setValue(data)
            etityResposta.child("r001").setValue(self.r001.rating)
            etityResposta.child("r002").setValue(self.r002.rating)
            etityResposta.child("r003").setValue(self.r003.rating)
            etityResposta.child("r004").setValue(self.r004.rating)
            etityResposta.child("r005").setValue(self.r005.rating)
        
            do {
                try context.save()
                let sucessoAlertController = AlertaFactory(titulo:"Obrigado!", mensagem:"Muito obrigado por compartilhar a sua Avaliação!", style: UIAlertControllerStyle.alert)
                present(sucessoAlertController.alerta, animated: true, completion: {() in
                    if let navigation = self.navigationController {
                        navigation.popViewController(animated: true)
                    }
                })
                
                
            } catch {
                let erroAlertController = AlertaFactory(titulo:"Atenção!", mensagem:"Erro ao salvar dados", style: UIAlertControllerStyle.alert)
                present(erroAlertController.alerta, animated: true, completion: nil)
            }
        
    }
    
    private func verificarSeTemResposta (context: NSManagedObjectContext) -> Bool {
        
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: self.objeto.entityName)
        do {
            let respostasCoreData = try context.fetch(requisicao)
            self.respostasRecuperadas = respostasCoreData as! [NSManagedObject]
            if respostasRecuperadas.count > 0{
                return true
            }else{
                return false
            }
        } catch {
            let erroAlertController = AlertaFactory(titulo:"Atenção!", mensagem:"Erro ao recuperar dados", style: UIAlertControllerStyle.alert)
            present(erroAlertController.alerta, animated: true, completion: nil)
            return false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if self.verificarSeTemResposta(context: context){
            
            let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: self.objeto.entityName)
            
            do {
                let respostasCoreData = try context.fetch(requisicao)
                self.respostasRecuperadas = respostasCoreData as! [NSManagedObject]
                for item in respostasRecuperadas{
                    if let r01 = item.value(forKey: "r001"){
                        self.r001.rating = r01 as! Int
                    }
                    if let r02 = item.value(forKey: "r002"){
                        self.r002.rating = r02 as! Int
                    }
                    if let r03 = item.value(forKey: "r003"){
                        self.r002.rating = r03 as! Int
                    }
                    if let r04 = item.value(forKey: "r004"){
                        self.r004.rating = r04 as! Int
                    }
                    if let r05 = item.value(forKey: "r005"){
                        self.r005.rating = r05 as! Int
                    }
                }
            } catch {
                let erroAlertController = AlertaFactory(titulo:"Atenção!", mensagem:"Erro ao recuperar dados", style: UIAlertControllerStyle.alert)
                present(erroAlertController.alerta, animated: true, completion: nil)
            }
            
            
            
        }
        
        
        self.navigationItem.title = objeto.TituloAvaliacao
        
        let database = Database.database().reference()
        
        let p001 = database.child(objeto.cenario).child("Perguntas").child("001")
        p001.observe(DataEventType.value) { (dados) in
            self.p001.text = dados.value as? String
        }
        let p002 = database.child(objeto.cenario).child("Perguntas").child("002")
        p002.observe(DataEventType.value) { (dados) in
            self.p002.text = dados.value as? String
        }
        let p003 = database.child(objeto.cenario).child("Perguntas").child("003")
        p003.observe(DataEventType.value) { (dados) in
            self.p003.text = dados.value as? String
        }
        let p004 = database.child(objeto.cenario).child("Perguntas").child("004")
        p004.observe(DataEventType.value) { (dados) in
            self.p004.text = dados.value as? String
        }
        let p005 = database.child(objeto.cenario).child("Perguntas").child("005")
        p005.observe(DataEventType.value) { (dados) in
            self.p005.text = dados.value as? String
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
