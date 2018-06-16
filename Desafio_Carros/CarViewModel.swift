//
//  CarViewModel.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 14/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class CarViewModel: NSObject {
    
    @IBOutlet weak var apiClient: APIClient!
    @IBOutlet weak var buttonBucket: UIButton!
    
    var carsList = [CarsModel]()
    var clientsList = [ClientsModel]()
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    //Adiciona cliente inicial
    func addClient(complete: @escaping AddComplete) {
        
        //Cliente de teste criado com saldo de 100 mil reais para compra
        let client = ClientsModel()
        
        client.id = UUID().uuidString
        client.nome = NAME_CLIENT
        client.email = EMAIL_CLIENT
        client.saldo = SALE_CLIENT
        
        let confirm = ClientRealmModel().addClient(client)
        if (confirm) {
            complete()
        }
        
    }
    
    //Verifica se cliente possui itens na cesta de compras
    func showBucket() {
        if (BucketRealmModel().verifyBucketExists() != "") {
            self.buttonBucket.isHidden = false
        }
    }
    
    //Recupera Carros
    func getCars(complete: @escaping DownloadComplete) {
        
        self.apiClient.downloadCar {
            self.carsList = self.apiClient._carsList
            complete()
        }
    }
    
    func numberOfItemsToDisplay(in section: Int) -> Int {
        return carsList.count
    }
    
    // start loading
    func startloading(_ controller: ViewController)
    {
        activityIndicator.center = controller.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        controller.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    // stop loading
    func stopLoading()
    {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
}
