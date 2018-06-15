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
    
    var carsList = [CarsModel]()
    var clientsList = [ClientsModel]()
    
    //Adiciona cliente inicial
    func addClient(complete: @escaping AddComplete) {
        
        //Cliente de teste criado com saldo de 100 mil reais para compra
        let client = ClientsModel()
        client.id = UUID().uuidString
        client.nome = "Jose"
        client.email = "jose@gmail.com"
        client.saldo = 100000
        
        let confirm = ClientRealmModel().addClient(client)
        if (confirm) {
            complete()
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
    
    
}
