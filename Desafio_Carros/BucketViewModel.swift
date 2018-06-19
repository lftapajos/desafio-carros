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
    var carsList = [CarsModel]()
    var client = ClientRealmModel()
    var bucket = BucketRealmModel()
    
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
    
    //Adiciona carro na cesta de compras
    func addCarInBucket(_ controller: BucketTableViewCell) {
        
        let bucket = Bucket()
        bucket.id = UUID().uuidString
        bucket.status = true
        
//        var carQuantity = 0
//        var carPrice = 0.0
        
//        //Cria e carrega o id do Bucket
        let bucketId = BucketRealmModel().createBucket(bucket)
        print(bucketId)
        
//        //Quantidade atual no estoque do carro selecionado
//        let actualQuantity = self.carsList.first!.quantidade!
//        
//        //Recupera dados do Cliente
//        let client = ClientRealmModel().getClient(EMAIL_CLIENT)
//        
//        //Saldo atual do cliente
//        let actualSale = client.saldo
//        
//        //Verifica se o saldo é maior que zero
//        if (actualSale > 0) {
//            
//            //Recupera o preço de compra do carro
//            carPrice = self.carsList.first!.preco!
//            
//            //Salva os dados do carro para o cliente na cesta de compras
//            let clientCars = ClientCarsModel()
//            clientCars.idBucket = bucketId
//            clientCars.idClient = client.id
//            clientCars.idCar = "\(String(describing: self.carsList.first!.id!))"
//            clientCars.quantidade = 1
//            clientCars.valor = carPrice
//            
//            //Se foi possível adicionar ou alterar os dados de compra do carro
//            if (BucketRealmModel().addClientCars(clientCar: clientCars, car: self.carsList)) {
//                
//                //Subtrai a quantidade atual
//                carQuantity = (actualQuantity - 1)
//                
//                //Carrega nova quantidade
//                self.carsList.first!.quantidade! = carQuantity
//                
//                //Verifica se possui uma cesta de compras criada
//                if (getBucket(controller)) {
//                    
//                    //Recupera detalhes do cliente, formata e carrega o saldo atual
//                    controller.carQuantity.text = "\(String(describing: carQuantity))"
//                    
//                }
//            }
//            
//        } else {
//            print("Saldo insuficiente!")
//        }
        
    }
    
    //Remove carro da cesta de compras
    func deleteCarInBucket(_ controller: BucketTableViewCell) {
        
//        var carPrice = 0.0
        
        //Recupera o ID do Bucket
        let bucketId = BucketRealmModel().verifyBucketExists()
        print(bucketId)
        
//
//        //Quantidade atual no estoque do carro selecionado
//        let actualQuantity = self.carsList.first!.quantidade!
//        
//        //Recupera dados do Cliente
//        let client = ClientRealmModel().getClient(EMAIL_CLIENT)
//        
//        //Saldo atual do cliente
//        let actualSale = BucketRealmModel().getBucketSale()
//        
//        //Verifica se o saldo é menor que saldo incial do cliente
//        if (actualSale < SALE_CLIENT) {
//            
//            //Recupera o preço de compra do carro
//            carPrice = self.carsList.first!.preco!
//            
//            //Salva os dados do carro para o cliente na cesta de compras
//            let clientCars = ClientCarsModel()
//            clientCars.idBucket = bucketId
//            clientCars.idClient = client.id
//            clientCars.idCar = "\(String(describing: self.carsList.first!.id!))"
//            clientCars.quantidade = 1
//            clientCars.valor = carPrice
//            
//            //Se foi possível deletar os dados de compra do carro
//            if (BucketRealmModel().deleteClientCars(clientCar: clientCars, car: self.carsList)) {
//                
//                //Adiciona a quantidade nova
//                let carQuantity = (actualQuantity + 1)
//                
//                //Carrega nova quantidade
//                self.carsList.first!.quantidade! = actualQuantity
//                
//                //Verifica se possui uma cesta de compras criada
//                if (getBucket(controller)) {
//                    
//                    //Recupera detalhes do cliente, formata e carrega a quantidade atual
//                    controller.carQuantity.text = "\(String(describing: actualQuantity))"
//                    
//                } else {
//                    //Recupera detalhes do cliente, formata e carrega aquantidade atual
//                    controller.carQuantity.text = "\(String(describing: carQuantity))"
//                }
//            }
//        } else {
//            print("Saldo insuficiente!")
//        }
        
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
    
}
