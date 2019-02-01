//
//  DetalhesSocialViewController.swift
//  IEB
//
//  Created by Matheus on 14/09/17.
//  Copyright © 2017 Matheus Freitas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetalhesSocialViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var objeto:Cenario!
    var escola:Escola!
    
    
    
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var labelEstado: UILabel!
    
    @IBOutlet weak var mapa: MKMapView!
    var gerenciadorLocal = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.escola = Escola()
        gerenciadorLocal.delegate = self
        gerenciadorLocal.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocal.requestWhenInUseAuthorization()
        let localizacaoUser: CLLocation = gerenciadorLocal.location!
        self.mapa.showsUserLocation = true
        self.mapa.mapType = .hybrid
        self.mapa.delegate = self
        
        let deltaLatitude: CLLocationDegrees = 0.02
        let deltaLongitude: CLLocationDegrees = 0.02
        
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
        
        self.navigationItem.title = objeto.Titulo
        
        
        
        switch self.objeto.cenario {
        case "saude":
            self.recuperandoPointActionsSaude(latitude: (localizacaoUser.coordinate.latitude), longitude: (localizacaoUser.coordinate.longitude))
            break
        case "transporte":
            let erroAlertController = AlertaFactory(titulo:"Atenção!", mensagem:"Ainda não Temos dados de Transporte Público, mas estamos trabalhando para obter!", style: UIAlertControllerStyle.alert)
            present(erroAlertController.alerta, animated: true, completion: nil)
            break
        case "educacao":
            self.recuperarPointAnotationsEducacao(latitude: (localizacaoUser.coordinate.latitude), longitude: (localizacaoUser.coordinate.longitude))
            
            
            break
        default:
            break
        }
        
        
        
    }
    
    private func recuperandoPointActionsSaude(latitude: Double, longitude: Double){
        let url = URL(string: "http://mobile-aceite.tcu.gov.br/mapa-da-saude/rest/estabelecimentos/latitude/\(latitude)/longitude/\(longitude)/raio/50")
        let task = URLSession.shared.dataTask(with: url!) { (dados, response, erro) in
            if erro == nil {
                
                if let content = dados{
                    
                    do{
                        let objetoJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                        for item in objetoJson{
                            
                            // Exibir Anotação
                            let anotacao = MKPointAnnotation()
                            //ToDo: For para percorrer a dictionary use um print()
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
        
        let _: CLLocation = locations.last!
        
        // monta exibicao do mapa
//        let deltaLatitude: CLLocationDegrees = 0.02
//        let deltaLongitude: CLLocationDegrees = 0.02
//
//        let localizacao: CLLocationCoordinate2D = CLLocationCoordinate2DMake(localizacaoUser.coordinate.latitude, localizacaoUser.coordinate.longitude)
//        let areaVisualizacao: MKCoordinateSpan = MKCoordinateSpanMake(deltaLatitude, deltaLongitude)
//
//        let regiao: MKCoordinateRegion = MKCoordinateRegionMake(localizacao, areaVisualizacao)
//
//        self.mapa.setRegion(regiao, animated: true)
//
//        CLGeocoder().reverseGeocodeLocation(localizacaoUser) { (detalhesLocal, erro) in
//            if erro == nil {
//                if let dadosLocal = detalhesLocal?.first{
//                    var locality = ""
//                    if dadosLocal.locality != nil{
//                        locality = dadosLocal.locality!
//                    }
//
//                    var subLocality = ""
//                    if dadosLocal.subLocality != nil{
//                        subLocality = dadosLocal.subLocality!
//                    }
//
//                    self.labelEstado.text = locality + " - " + subLocality
//
//                }
//            }
//        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation{
            return
        }
        let codEscola:String = view.annotation!.subtitle!!
        let codUnidade:String = view.annotation!.subtitle!!
        switch self.objeto.cenario {
        case "saude":
            //self.recuperarHospitail(codUnidade)
            break
        case "transporte":
            break
        case "educacao":
            self.recuperarEscola(codEscola: codEscola)
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let viewControllerDestino = segue.destination as! QuestionsViewController
        
        if segue.identifier == "avaliacao"{
            
            viewControllerDestino.objeto = objeto
            
        }
    }
    
    private func recuperarEscola(codEscola: String){
        let url = URL(string: "http://mobile-aceite.tcu.gov.br/nossaEscolaRS/rest/escolas/\(codEscola)")
        let task = URLSession.shared.dataTask(with: url!) { (dados, response, erro) in
            if erro == nil {
                
                if let dadosRetorno = dados{
                    
                    do{
                        if let objJSON = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [String: Any]{
                            print(objJSON)
                            
                            
                            
                            if let infraestrutura = objJSON["infraestrutura"] as? [String: Any] {
                                
                                if let endereco = objJSON["endereco"] as? [String: Any] {
                                    DispatchQueue.main.async(execute: {
                                        self.escola.codEscola = objJSON["codEscola"]  as? Double
                                        self.escola.nome = objJSON["nome"] as? String
                                        self.escola.latitude = objJSON["latitude"] as? Double
                                        self.escola.longitude = objJSON["longitude"] as? Double
                                        self.escola.logradouro = objJSON["logradouro"] as? String
                                        self.escola.rede = objJSON["rede"] as? String
                                        self.escola.zona = objJSON["zona"] as? String
                                        self.escola.telefone = objJSON["telefone"] as? String
                                        self.escola.email = objJSON["email"] as? String
                                        
                                        //Endereço
                                        
                                        self.escola.bairro = endereco["bairro"] as? String
                                        self.escola.cep = endereco["cep"] as? String
                                        self.escola.descricao = endereco["descricao"] as? String
                                        self.escola.municipio = endereco["municipio"] as? String
                                        self.escola.uf = endereco["uf"] as? String
                                        
                                        
                                        //Informações de Infraestrutura basica
                                        self.escola.qtdComputadores = objJSON["qtdComputadores"] as? Int
                                        self.escola.qtdComputadoresPorAluno = objJSON["qtdComputadoresPorAluno"] as? Int
                                        self.escola.qtdSalasExistentes = objJSON["qtdSalasExistentes"] as? Int
                                        self.escola.qtdSalasUtilizadas = objJSON["qtdSalasUtilizadas"] as? Int
                                        self.escola.qtdAlunos = objJSON["qtdAlunos"] as? Int
                                        self.escola.esferaAdministrativa = objJSON["esferaAdministrativa"] as? String
                                        self.escola.seConveniadaSetorPublico = objJSON["seConveniadaSetorPublico"] as? String
                                        self.escola.qtdFuncionarios = objJSON["qtdFuncionarios"] as? Int
                                        self.escola.situacaoFuncionamento = objJSON["situacaoFuncionamento"] as? String
                                        self.escola.categoriaEscolaPrivada = objJSON["categoriaEscolaPrivada"] as? String
                                        self.escola.tipoConvenioPoderPublico = objJSON["tipoConvenioPoderPublico"] as? String
                                        
                                        //Informações de Infraestrutura
                                        self.escola.atendeEducacaoEspecializada = infraestrutura["atendeEducacaoEspecializada"] as? String
                                        self.escola.banheiroTemChuveiro = infraestrutura["banheiroTemChuveiro"] as? String
                                        self.escola.ofereceAlimentacao = infraestrutura["ofereceAlimentacao"] as? String
                                        self.escola.temAcessibilidade = infraestrutura["temAcessibilidade"] as? String
                                        self.escola.temAguaFiltrada = infraestrutura["temAguaFiltrada"] as? String
                                        self.escola.temAlmoxarifado = infraestrutura["temAlmoxarifado"] as? String
                                        self.escola.temAreaVerde = infraestrutura["temAreaVerde"] as? String
                                        self.escola.temAuditorio = infraestrutura["temAuditorio"] as? String
                                        self.escola.temBandaLarga = infraestrutura["temBandaLarga"] as? String
                                        self.escola.temBercario = infraestrutura["temBercario"] as? String
                                        self.escola.temBiblioteca = infraestrutura["temBiblioteca"] as? String
                                        self.escola.temCozinha = infraestrutura["temCozinha"] as? String
                                        self.escola.temCreche = infraestrutura["temCreche"] as? String
                                        self.escola.temDespensa = infraestrutura["temDespensa"] as? String
                                        self.escola.temEducacaoIndigena = infraestrutura["temEducacaoIndigena"] as? String
                                        self.escola.temEducacaoJovemAdulto = infraestrutura["temEducacaoJovemAdulto"] as? String
                                        self.escola.temEnsinoFundamental = infraestrutura["temEnsinoFundamental"] as? String
                                        self.escola.temEnsinoMedio = infraestrutura["temEnsinoMedio"] as? String
                                        self.escola.temEnsinoMedioIntegrado = infraestrutura["temEnsinoMedioIntegrado"] as? String
                                        self.escola.temEnsinoMedioNormal = infraestrutura["temEnsinoMedioNormal"] as? String
                                        self.escola.temEnsinoMedioProfissional = infraestrutura["temEnsinoMedioProfissional"] as? String
                                        self.escola.temInternet = infraestrutura["temInternet"] as? String
                                        self.escola.temLaboratorioCiencias = infraestrutura["temLaboratorioCiencias"] as? String
                                        self.escola.temLaboratorioInformatica = infraestrutura["temLaboratorioInformatica"] as? String
                                        self.escola.temParqueInfantil = infraestrutura["temParqueInfantil"] as? String
                                        self.escola.temPatioCoberto = infraestrutura["temPatioCoberto"] as? String
                                        self.escola.temPatioDescoberto = infraestrutura["temPatioDescoberto"] as? String
                                        self.escola.temQuadraEsporteCoberta = infraestrutura["temQuadraEsporteCoberta"] as? String
                                        self.escola.temQuadraEsporteDescoberta = infraestrutura["temQuadraEsporteDescoberta"] as? String
                                        self.escola.temRefeitorio = infraestrutura["temRefeitorio"] as? String
                                        self.escola.temSalaLeitura = infraestrutura["temSalaLeitura"] as? String
                                        self.escola.temSanitarioForaPredio = infraestrutura["temSanitarioForaPredio"] as? String
                                        self.escola.temSanitarioNoPredio = infraestrutura["temSanitarioNoPredio"] as? String
                                        
                                        
                                        self.nome.text = """
                                        \(String(describing: self.escola.nome!))
                                        \(String(describing: self.escola.descricao!)), \(String(describing: self.escola.bairro!))
                                        \(String(describing: self.escola.municipio!)) \(String(describing: self.escola.uf!))
                                        """
                                        //self.escola.nome
                                        print("==== ESCOLA ====")
                                        print(self.escola.temSanitarioNoPredio)
                                    })
                                }
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
        // Dispose of any resources that can be recreated.
    }
    
    
}
