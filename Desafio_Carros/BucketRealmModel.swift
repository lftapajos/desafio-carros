//
//  BucketRealmModel.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 15/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: Modelo de Cliente
class BucketRealmModel {
    
    //Cria um novo carrinho de compras para o cliente no Realm
    func createBucket(_ bucket: Bucket) -> String {
        
        let newBucket = Bucket()
        var retorno = ""
        
        newBucket.id = bucket.id
        newBucket.status = bucket.status
        
        let realm = try! Realm()
        
        //Verifica se possui um carrio ativo
        let bucketExists = verifyBucketExists()
        
        if (bucketExists != "") {
            retorno = bucketExists
        } else {
            try! realm.write {
                realm.add(newBucket)
                print("Bucket \(newBucket.id) add with success in Realm.")
                retorno = newBucket.id
            }
        }
        
        return retorno
    }
    
    //Verifica se já possui um Carrinho de Compras ativo
    func verifyBucketExists() -> String {
        
        let realm = try! Realm()
        
        let buck = realm.objects(Bucket.self)
        
        if (buck.count > 0) {
            print("Bucket exist: \(String(describing: buck.first!.id))")
            return buck.first!.id
        } else {
            print("Bucket don't exists!")
            return ""
        }
    }
    
    //Adiciona Carro para Cliente no Carrinho de Compras do Realm
    func addClientCars(clientCar: ClientCarsModel) -> Bool {
        
        let newClientCar = ClientCars()
        var retorno = false
        
        newClientCar.idBucket = clientCar.idBucket!
        newClientCar.idClient = clientCar.idClient!
        newClientCar.idCar = clientCar.idCar!
        newClientCar.quantidade = clientCar.quantidade!
        newClientCar.valor = clientCar.valor!
        
        let realm = try! Realm()
        
        //Verifica se possui saldo par aa compra
        let sale = getBucketSale()
        if (sale > 0) {
            if (verifyClientCarExists(newClientCar)) {
                //Se já existe o carro adicionado para o Cliente no Carrinho, atualiza a quantidade e o valor
                updateClientCar(newClientCar)
                retorno = true
            } else {
                try! realm.write {
                    realm.add(newClientCar)
                    print("ClientCar added with success in Realm.")
                    retorno = true
                }
            }
        } else {
            retorno = false
        }
        return retorno
    }
    
    //Verifica se o Carrinho de Compras já possui o Carro adicionado para ao Cliente
    func verifyClientCarExists(_ clientCar: ClientCars) -> Bool {
        
        let realm = try! Realm()
        
        let cli = realm.objects(ClientCars.self)
        
        let predicate = NSPredicate(format: "idBucket = %@ AND idClient = %@ AND idCar = %@", clientCar.idBucket, clientCar.idClient, clientCar.idCar)
        let filteredClientCar = cli.filter(predicate)
        
        if (filteredClientCar.count > 0) {
            print("Client and Car exist in Bucket: \(String(describing: filteredClientCar.first!.idBucket))")
            return true
        } else {
            print("Client and Car don't exists!")
            return false
        }
    }
    
    //Atualiza saldo do cliente
    func updateClientCar(_ clientCar: ClientCars) {
        
        let realm = try! Realm()
        
        let cliCar = realm.objects(ClientCars.self).filter("idBucket = %@ AND idClient = %@ AND idCar = %@", clientCar.idBucket, clientCar.idClient, clientCar.idCar)
        
        if let updateClientCar = cliCar.first {
            try! realm.write {
                updateClientCar.quantidade += clientCar.quantidade
                updateClientCar.valor += clientCar.valor
            }
        }
    }
    
    //Recupera dados do Carrinho
    func getBucket() -> BucketSaleModel {
        
        let realm = try! Realm()
        let cli = BucketSaleModel()
 
        cli.idBucket = ""
        cli.isBucket = false
        cli.quantidade = 0
        cli.valor = 0.0
        
        let cliCar = realm.objects(ClientCars.self)
        
        for c in cliCar {
            
            cli.idBucket = c.idBucket
            cli.isBucket = true
            cli.quantidade = Int(cli.quantidade!) + Int(c.quantidade)
            cli.valor = cli.valor! + c.valor
        }
        
        return cli
    }
    
    //Recupera dados de um carro que está dentro do Carrinho
    func getCarBucket(_ carBucketId: String) -> Int {
        
        let realm = try! Realm()
        let car = CarBucketModel()
        
        car.quantidade = 0
        
        let bucketCar = realm.objects(ClientCars.self).filter("idCar = %@", carBucketId)
        
        for c in bucketCar {
            car.quantidade = (Int(car.quantidade!) + Int(c.quantidade))
        }
        
        return car.quantidade!
    }
    
    //Recupera dados do Carrinho
    func getBucketSale() -> Double {
        
        let realm = try! Realm()
        let cli = BucketSaleModel()
        
        //Recupera o saldo inicial do Cliente
        cli.valor = SALE_CLIENT
        
        let cliCar = realm.objects(ClientCars.self)
        
        //Subtrai os valores adicionados
        for c in cliCar {
            cli.valor = cli.valor! - c.valor
        }
        
        return cli.valor!
    }
}
