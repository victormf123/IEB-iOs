//
//  DetalhesSocialViewController.swift
//  IEB
//
//  Created by Matheus on 14/09/17.
//  Copyright © 2017 Matheus Freitas. All rights reserved.
//

import UIKit
import MapKit

class DetalhesSocialViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var objeto:Cenario!
    
    
    
    @IBOutlet weak var labelEstado: UILabel!
    
    @IBOutlet weak var mapa: MKMapView!
    var gerenciadorLocal = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        gerenciadorLocal.delegate = self
        gerenciadorLocal.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocal.requestWhenInUseAuthorization()
        
        gerenciadorLocal.startUpdatingLocation()
        
        self.navigationItem.title = objeto.Titulo
        
        let localizacao = gerenciadorLocal.location?.coordinate
        
        switch self.objeto.cenario {
        case "saude":
            self.recuperandoDadosSaude(latitude: (localizacao?.latitude)!, longitude: (localizacao?.longitude)!)
            break
        case "transporte":
            let erroAlertController = AlertaFactory(titulo:"Atenção!", mensagem:"Ainda não Temos dados de Transporte Público, mas estamos trabalhando para obter!", style: UIAlertControllerStyle.alert)
            present(erroAlertController.alerta, animated: true, completion: nil)
            break
        case "educacao":
            self.recuperarDadosEducacao(latitude: (localizacao?.latitude)!, longitude: (localizacao?.longitude)!)
            break
        default:
            break
        }
        
        
        
    }
    
    private func recuperandoDadosSaude(latitude: Double, longitude: Double){
        let url = URL(string: "http://mobile-aceite.tcu.gov.br/mapa-da-saude/rest/estabelecimentos/latitude/\(latitude)/longitude/\(longitude)/raio/2")
        let task = URLSession.shared.dataTask(with: url!) { (dados, response, erro) in
            if erro == nil {
                
                if let content = dados{
                    
                    do{
                        let objetoJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                        for item in objetoJson{
                            
                            // Exibir Anotação
                            let anotacao = MKPointAnnotation()
                            if let dicionario = item as? NSDictionary{
                                print("==== INICIO ====")
                                print(item)
                                print("==== FIM ====")
                                if let latitude = dicionario["lat"]{
                                    anotacao.coordinate.latitude = latitude as! Double
                                    
                                }
                                if let longitude = dicionario["long"]{
                                    anotacao.coordinate.longitude = longitude as! Double
                                    
                                }
                                
                                if let nomeFantasia = dicionario["nomeFantasia"]{
                                    anotacao.title = nomeFantasia as? String
                                    print(nomeFantasia)
                                }
                                if let logradouro = dicionario["logradouro"]{
                                    anotacao.subtitle = logradouro as? String
                                    print(logradouro)
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
    
    private func recuperarDadosEducacao(latitude: Double, longitude: Double){
        let url = URL(string: "http://mobile-aceite.tcu.gov.br/nossaEscolaRS/rest/escolas/latitude/\(latitude)/longitude/\(longitude)/raio/2")
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
                                    if let rede = dicionario["rede"]{
                                        anotacao.subtitle = rede as? String
                                        print(rede)
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse{
            
            let alertController = UIAlertController(title: "Permissão de localização", message: "Necessario permissão para acesso à sua localização, por favor habílite", preferredStyle: UIAlertControllerStyle.alert)
            
            let acaoConfiguracoes = UIAlertAction(title: "Abrir Configurações", style: .default, handler: { (alertaConfiguaracoes) in
                if let configuacoes = NSURL(string: UIApplicationOpenSettingsURLString){
                
                    UIApplication.shared.open(configuacoes as URL)
                }
            })
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertController.addAction(acaoConfiguracoes)
            alertController.addAction(acaoCancelar)
            
            present(alertController, animated: true, completion: nil)
        
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let localizacaoUser: CLLocation = locations.last!
        
        // monta exibicao do mapa
        let deltaLatitude: CLLocationDegrees = 0.02
        let deltaLongitude: CLLocationDegrees = 0.02
        
        let localizacao: CLLocationCoordinate2D = CLLocationCoordinate2DMake(localizacaoUser.coordinate.latitude, localizacaoUser.coordinate.longitude)
        let areaVisualizacao: MKCoordinateSpan = MKCoordinateSpanMake(deltaLatitude, deltaLongitude)
        
        let regiao: MKCoordinateRegion = MKCoordinateRegionMake(localizacao, areaVisualizacao)
        
        mapa.setRegion(regiao, animated: true)
        
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
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let viewControllerDestino = segue.destination as! QuestionsViewController
        
        if segue.identifier == "avaliacao"{
            
            viewControllerDestino.objeto = objeto
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
