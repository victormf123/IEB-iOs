//
//  InformacaoEscolaPopupViewController.swift
//  IEB
//
//  Created by Matheus Freitas on 04/02/19.
//  Copyright © 2019 Matheus Freitas. All rights reserved.
//

import UIKit

class InformacaoEscolaPopupViewController: UIViewController {
    
    var objeto: Cenario!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
