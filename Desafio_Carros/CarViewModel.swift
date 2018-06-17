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
    func showBucket() -> Bool {
        var retorno = true
        if (BucketRealmModel().verifyBucketExists() != "") {
            retorno = false
        }
        return retorno
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
    
    //Mostra loading
    func startloading(_ controller: ViewController)
    {
        activityIndicator.center = controller.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        controller.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    //Remove loading
    func stopLoading()
    {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func showAlert(controller: ViewController) {
        //Mostra mensagem de cliente inserido
        Alert(controller: controller).show(message: "Client add with success!", handler : { action in
            controller.navigationController?.popViewController(animated: true)
        })
    }
    
    //Função para chamar a View de carrinho
    func callBucketViewController(_ controller: ViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bucketViewController = storyboard.instantiateViewController(withIdentifier: "BucketViewController") as! BucketViewController
        controller.navigationController?.pushViewController(bucketViewController, animated: true)
    }
}
