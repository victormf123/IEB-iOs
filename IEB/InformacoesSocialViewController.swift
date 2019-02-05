//
//  InformacoesSocialViewController.swift
//  IEB
//
//  Created by Matheus Freitas on 03/02/19.
//  Copyright © 2019 Matheus Freitas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class InformacoesSocialViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    

    var objeto:Cenario!
    var escola:Escola!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelEstado: UILabel!
    @IBOutlet weak var mapa: MKMapView!
    var gerenciadorLocal = CLLocationManager()
    var localizacaoUser: CLLocation!
    var dados: [String] = ["dados"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.gerenciadorLocal.delegate = self
        self.mapa.delegate = self
        self.gerenciadorLocal.desiredAccuracy = kCLLocationAccuracyBest
        self.gerenciadorLocal.requestWhenInUseAuthorization()
        self.gerenciadorLocal.startUpdatingLocation()
        self.escola = Escola()
        self.mapa.showsUserLocation = true
        self.mapa.mapType = .hybrid
        self.localizacaoUser = self.gerenciadorLocal.location!
        
        // monta exibicao do mapa
                let deltaLatitude: CLLocationDegrees = 0.01
                let deltaLongitude: CLLocationDegrees = 0.01
        
                let localizacao: CLLocationCoordinate2D = CLLocationCoordinate2DMake(localizacaoUser.coordinate.latitude, localizacaoUser.coordinate.longitude)
                let areaVisualizacao: MKCoordinateSpan = MKCoordinateSpanMake(deltaLatitude, deltaLongitude)
        
                let regiao: MKCoordinateRegion = MKCoordinateRegionMake(localizacao, areaVisualizacao)
        
                self.mapa.setRegion(regiao, animated: true)
        
                CLGeocoder().reverseGeocodeLocation(localizacaoUser) { (detalhesLocal, erro) in
                    if erro == nil {
                        if let dadosLocal = detalhesLocal?.first{
                            var locality = ""
                            if dadosLocal.locality != nil{
                                locality = dadosLocal.locality!
                            }
        
                            var subLocality = ""
                            if dadosLocal.subLocality != nil{
                                subLocality = dadosLocal.subLocality!
                            }
        
                            self.labelEstado.text = locality + " - " + subLocality
        
                        }
                    }
                }
        
        switch self.objeto!.cenario {
        case "saude":
//            self.recuperandoPointActionsSaude(latitude: localizacaoUser.coordinate.latitude, longitude: localizacaoUser.coordinate.longitude)
            break
        case "transporte":
            let erroAlertController = AlertaFactory(titulo:"Atenção!", mensagem:"Ainda não Temos dados de Transporte Público, mas estamos trabalhando para obter!", style: UIAlertControllerStyle.alert)
            present(erroAlertController.alerta, animated: true, completion: nil)
            break
        case "educacao":
            self.recuperarPointAnotationsEducacao(latitude: localizacaoUser.coordinate.latitude, longitude: localizacaoUser.coordinate.longitude)
            
            
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celulaReuso = "celulaReuso"
        let celula = tableView.dequeueReusableCell(withIdentifier: celulaReuso, for: indexPath)
        return celula
    }

    
    
    
    private func recuperarPointAnotationsEducacao(latitude: Double, longitude: Double){
        let url = URL(string: "http://mobile-aceite.tcu.gov.br/nossaEscolaRS/rest/escolas/latitude/\(latitude)/longitude/\(longitude)/raio/50")
        let task = URLSession.shared.dataTask(with: url!) { (dados, response, erro) in
            if erro == nil {
                
                if let content = dados{
                    
                    do{
                        let objetoJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                        for item in objetoJson{
                            
                            // Exibir Anotação
                            let anotacao = MKPointAnnotation()
                            
                            if let dicionario = item as? NSDictionary{
                                if let latitude = dicionario["latitude"]{
                                    anotacao.coordinate.latitude = latitude as! Double
                                    print(latitude)
                                }
                                if let longitude = dicionario["longitude"]{
                                    anotacao.coordinate.longitude = longitude as! Double
                                    print(longitude)
                                }
                                
                                if let nome = dicionario["nome"]{
                                    anotacao.title = nome as? String
                                    print(nome)
                                }
                                if let codEscola = dicionario["codEscola"]{
                                    anotacao.subtitle = String(describing: codEscola)
                                    print(codEscola)
                                }
                                
                                self.mapa.addAnnotation(anotacao)
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
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
