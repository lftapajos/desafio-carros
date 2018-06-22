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
    var cList = [CarsModel]()
    var clientRealm = ClientRealmModel()
    var bucketRealm = BucketRealmModel()
    
    //Função para Retornar para a View de lista de carros
    func callReturnViewController(_ controller: BucketViewController) {
        controller.navigationController?.popToRootViewController(animated: true)
    }
    
    //Recupera carros contidos na cesta de compras
    func getAllBucket() -> [Car] {
        
        //Carrega todos os carros da lista de carroa
        let bucket = bucketRealm.getAllBucket()
        return bucket
        
    }
    
    func showBucketSale() -> String {
        
        let bucketSale = "\(Help.shared.formatCoin("pt_BR", valor: self.bucketRealm.getClientSale()))"
        return bucketSale
    }
    
    //Verifica se cliente possui itens na cesta de compras
    func getBucket(_ controller: BucketTableViewCell) -> Bool {
        
        //Calcula saldo do cliente por possível cesta de compras
        let actualBucket = bucketRealm.getBucket()
        
        //Saldo atual do cliente
        //let cli = client.getClient(EMAIL_CLIENT)
        //let newSale = (cli.saldo - actualBucket.valor!)
        //controller.labelSale.text = "\(Help.shared.formatCoin("pt_BR", valor: newSale))"
        
        //Se os dados do carro forem encontrados
        if (self.carsList.first?.id != nil) {
            
            //Recupera saldo substraido da cesta de compas
            let actualCarBucket = bucketRealm.getCarBucket("\((self.carsList.first?.id)!)")
            
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
    
    //Mostra mensagem de confirmação de exclusão da cesta de compras
    func showConfirmAlertRemoveBucket(_ controller: BucketViewController, message: String, returnPage: Bool) {
        Alert(controller: controller).showConfirm(MESSAGE_CONFIRM, message: MESSAGE_REMOVE_BUCKET, okMessage: MESSAGE_YES, cancelMessage: MESSAGE_NO, success: { action in
            
            self.confirmRemoveBucket(controller)
            controller.navigationController?.popViewController(animated: true)
        }, cancel: { action in
            //print("CANCEL")
        })
    }
    
    //Mostra mensagem de confirmação de compra dos carros da cesta de compras
    func showConfirmAlertBucket(_ controller: BucketViewController, message: String, returnPage: Bool) {
        Alert(controller: controller).showConfirm(MESSAGE_CONFIRM, message: MESSAGE_CONFIRM_BUCKET, okMessage: MESSAGE_YES, cancelMessage: MESSAGE_NO, success: { action in
            
            self.confirmBucket(controller)
            if (returnPage) {
                controller.navigationController?.popViewController(animated: true)
            }
        }, cancel: { action in
            //print("CANCEL")
        })
    }
    
    func confirmRemoveBucket(_ controller: BucketViewController) {

        //Chama a remoção da cesta de compras
        bucketRealm.removeAllBucket()
        
        //Mostra mensagem de cesta de compras removida
        Alert(controller: controller).show(message: MESSAGE_BUCKET_REMOVED, handler : { action in
            controller.navigationController?.popViewController(animated: true)
        })
    }
    
    func confirmBucket(_ controller: BucketViewController) {

        //Salva em transações a cesta de compras
        bucketRealm.saveAllBucket()
        
        //Mostra mensagem compra da cesta de compras
        Alert(controller: controller).show(message: MESSAGE_BUCKET_CONFIRMED, handler : { action in
            controller.navigationController?.popViewController(animated: true)
        })
    }
    
}
