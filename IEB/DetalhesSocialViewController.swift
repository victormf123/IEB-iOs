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
        
        switch self.objeto.cenario {
        case "saude":
            break
        case "transporte":
            break
        case "educacao":
            break
        default:
            break
        }
        
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
        let deltaLatitude: CLLocationDegrees = 0.08
        let deltaLongitude: CLLocationDegrees = 0.08
        
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
