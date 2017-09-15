//
//  QuestionsViewController.swift
//  IEB
//
//  Created by Matheus on 14/09/17.
//  Copyright © 2017 Matheus Freitas. All rights reserved.
//

import UIKit
import FirebaseDatabase

class QuestionsViewController: UIViewController {
    
    var objeto:Cenario!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = objeto.TituloAvaliacao
        
        let database = Database.database().reference()
        
        let p001 = database.child(objeto.cenario).child("Perguntas").child("001")
        p001.observe(DataEventType.value) { (dados) in
            self.p001.text = dados.value as! String
        }
        let p002 = database.child(objeto.cenario).child("Perguntas").child("002")
        p002.observe(DataEventType.value) { (dados) in
            self.p002.text = dados.value as! String
        }
        let p003 = database.child(objeto.cenario).child("Perguntas").child("003")
        p003.observe(DataEventType.value) { (dados) in
            self.p003.text = dados.value as! String
        }
        let p004 = database.child(objeto.cenario).child("Perguntas").child("004")
        p004.observe(DataEventType.value) { (dados) in
            self.p004.text = dados.value as! String
        }
        let p005 = database.child(objeto.cenario).child("Perguntas").child("005")
        p005.observe(DataEventType.value) { (dados) in
            self.p005.text = dados.value as! String
        }
        
        /*self.p001.text = String(describing: database.child(objeto.cenario).child("Perguntas").value(forKey: "001"))
        self.p002.text = String(describing: database.child(objeto.cenario).child("Perguntas").value(forKey: "002"))
        self.p003.text = String(describing: database.child(objeto.cenario).child("Perguntas").value(forKey: "003"))
        self.p004.text = String(describing: database.child(objeto.cenario).child("Perguntas").value(forKey: "004"))
        self.p005.text = String(describing: database.child(objeto.cenario).child("Perguntas").value(forKey: "005"))*/
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
