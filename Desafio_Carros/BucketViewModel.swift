//
//  BucketViewModel.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 17/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class BucketViewModel: NSObject {

    @IBOutlet weak var apiClient: APIClient!
    
    var bucketList = [ClientCarsModel]()
    var carsList = [Car]()
    var client = ClientRealmModel()
    var bucket = BucketRealmModel()
    var cList = [CarsModel]()
    
    //Função para Retornar para a View de lista de carros
    func callReturnViewController(_ controller: BucketViewController) {
        controller.navigationController?.popToRootViewController(animated: true)
    }
    
    //Recupera carros contidos na cesta de compras
    func getAllBucket() -> [Car] {
        
        //Carrega todos os carros da lista de carroa
        let bucket = BucketRealmModel().getAllBucket()
        return bucket
        
    }
    
    func showBucketSale() -> String {
        
        let bucketSale = "\(Help.shared.formatCoin("pt_BR", valor: self.bucket.getClientSale()))"
        return bucketSale
    }
    
    //Verifica se cliente possui itens na cesta de compras
    func getBucket(_ controller: BucketTableViewCell) -> Bool {
        
        //Calcula saldo do cliente por possível cesta de compras
        let actualBucket = bucket.getBucket()
        
        //Saldo atual do cliente
        //let cli = client.getClient(EMAIL_CLIENT)
        //let newSale = (cli.saldo - actualBucket.valor!)
        //controller.labelSale.text = "\(Help.shared.formatCoin("pt_BR", valor: newSale))"
        
        //Se os dados do carro forem encontrados
        if (self.carsList.first?.id != nil) {
            
            //Recupera saldo substraido da cesta de compas
            let actualCarBucket = bucket.getCarBucket("\((self.carsList.first?.id)!)")
            
            //Se o carro selecionado está na cesta de compras, mostra botão de remover
            if (actualCarBucket > 0) {
                
                //Nova quantidade em estoque subtraindo a quantidade da cesta de compras
                let newQuantity = ((self.carsList.first?.quantidade)! - actualCarBucket)
                controller.carQuantity.text = "\(newQuantity)"
                
            }
            
        }
        
        //Retorna se existe uma cesta de compras ativa
        return actualBucket.isBucket!
        
    }
    
    //Mostra mensagem
    func showConfirmAlert(_ controller: BucketViewController, message: String, returnPage: Bool) {
        Alert(controller: controller).show(message: message, handler : { action in
            if (returnPage) {
                controller.navigationController?.popViewController(animated: true)
            }
        })
    }
    
}
