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
    
    //Cria uma nova cesta de compras para o cliente no Realm
    func createBucket(_ bucket: Bucket) -> String {
        
        let newBucket = Bucket()
        var retorno = ""
        
        newBucket.id = bucket.id
        newBucket.status = bucket.status
        
        let realm = try! Realm()
        
        //Verifica se possui uma cesta de compras ativa
        let bucketExists = verifyBucketExists()
        
        if (bucketExists != "") {
            retorno = bucketExists
        } else {
            
            //Cria uma cesta de compras
            try! realm.write {
                realm.add(newBucket)
                print("Bucket \(newBucket.id) add with success in Realm.")
                retorno = newBucket.id
            }
        }
        
        return retorno
    }
    
    //Verifica se já possui uma cesta de compras ativa
    func verifyBucketExists() -> String {
        
        let realm = try! Realm()
        
        let buck = realm.objects(Bucket.self)
        
        if (buck.count > 0) {
            print("Bucket exist: \(String(describing: buck.first!.id))")
            
            //Verifica se a cesta de compras está vazia
            return verifyBucketEmpty()
        } else {
            print("Bucket don't exists!")
            return ""
        }
    }
    
    //Verifica se a cesta de compras possui itens dentro dela
    func verifyBucketEmpty() -> String {
        
        let realm = try! Realm()
        
        let bucket = realm.objects(Bucket.self)
        let buck = realm.objects(ClientCars.self)
        
        //Verifica se a cesta de compras existe mas está vazia
        if (buck.count > 0) {
            print("Bucket not empty: \(String(describing: buck.first!.idBucket))")
            
            //Retorno o id da cesta de compras caso a cesta não esteja vazia
            return buck.first!.idBucket
        } else {
            
            //Se a cesta de compras existe mas não possui itens nela, então deve ser excluída
            try! realm.write {
                
                //Exclui os itens
                realm.delete(buck)
                
                //Exclui a cesta de compras
                realm.delete(bucket)
            }
            
            //Após excluir, retorno vazio
            print("Bucket is empty!")
            return ""
        }
    }
    
    //Adiciona Carro para o Cliente na cesta de compras do Realm
    func addClientCars(clientCar: ClientCarsModel, car: [CarsModel]) -> Bool {
        
        let newClientCar = ClientCars()
        let newCar = Car()
        //let newClient = Client()
        var retorno = false
        
        //Armazena dados da cesta
        newClientCar.idBucket = clientCar.idBucket!
        newClientCar.idClient = clientCar.idClient!
        newClientCar.idCar = clientCar.idCar!
        newClientCar.quantidade = clientCar.quantidade!
        newClientCar.valor = clientCar.valor!
        
        //Armazena dados do carro inserido
        newCar.id = (car.first?.id!)!
        newCar.nome = (car.first?.nome!)!
        newCar.descricao = (car.first?.descricao!)!
        newCar.marca = (car.first?.marca!)!
        newCar.quantidade = (car.first?.quantidade!)!
        newCar.preco = (car.first?.preco!)!
        newCar.imagem = (car.first?.imagem!)!
        //newCar.quantidadeCesta = (car.first?.quantidadeCesta!)!
        
        let realm = try! Realm()
        
        let sale = (getBucketSale() - (car.first?.preco!)!)
        
        //Verifica se o cliente possui saldo para a compra
        if (sale >= 0) {
            
            //Atualiza saldo do Cliente
            let client = realm.objects(Client.self).filter("email = %@", EMAIL_CLIENT)
            if let updateClientSale = client.first {
                try! realm.write {
                    updateClientSale.saldo = sale
                }
            }
            
            if (verifyClientCarExists(newClientCar)) {
                
                //Se já existe o carro adicionado para o Cliente na cesta de compras, atualiza a quantidade e o valor
                updateClientCar(newClientCar, car: newCar)
                retorno = true
            } else {
                try! realm.write {
                    
                    //Adiciona o carro na cesta de compras
                    realm.add(newClientCar)
                    print("ClientCar added with success in Realm.")
                    realm.add(newCar)
                    print("Car added with success in Realm.")
                    retorno = true
                }
            }
        } else {
            retorno = false
        }
        return retorno
    }
    
    //Deleta Carro para Cliente na cesta de compras do Realm
    func deleteClientCars(clientCar: ClientCarsModel, car: [CarsModel]) -> Bool {
        
        let newClientCar = ClientCars()
        let newCar = Car()
        var retorno = false
        
        //Armazena dados da cesta
        newClientCar.idBucket = clientCar.idBucket!
        newClientCar.idClient = clientCar.idClient!
        newClientCar.idCar = clientCar.idCar!
        newClientCar.quantidade = clientCar.quantidade!
        newClientCar.valor = clientCar.valor!
        
        //Armazena dados do carro a ser excluido
        newCar.id = (car.first?.id!)!
        newCar.nome = (car.first?.nome!)!
        newCar.descricao = (car.first?.descricao!)!
        newCar.marca = (car.first?.marca!)!
        newCar.quantidade = (car.first?.quantidade!)!
        newCar.preco = (car.first?.preco!)!
        newCar.imagem = (car.first?.imagem!)!
        
        //Verifica se o cliente possui saldo para a compra
        //let sale = getBucketSale()
        
        let sale = (getBucketSale() + (car.first?.preco!)!)
        
        if (sale <= SALE_CLIENT) {
            
            //Remove o saldo
            deleteClientCar(newClientCar, car: newCar)
            retorno = true
        } else {
            retorno = false
        }
        return retorno
    }
    
    //Verifica se a cesta de compras já possui o Carro adicionado para ao Cliente
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
    
    //Verifica se o carro já foi adicionado na cesta de compras
    func getCarInBucket(car: CarsModel) -> Bool {
        
        var retorno = false
        
        let realm = try! Realm()
        let carBuket = realm.objects(Car.self).filter("id = %@", car.id!)

        if (carBuket.count > 0) {
            retorno = true
        }
        return retorno
    }
    
    //Adiciona saldo do cliente
    func updateClientCar(_ clientCar: ClientCars, car: Car) {
        
        let realm = try! Realm()
        
        //Atualiza a quantidade em estoque do carro
        let aCar = realm.objects(Car.self).filter("id = %@", car.id)
        if let updateACar = aCar.first {
            try! realm.write {
                updateACar.quantidade -= (aCar.first?.quantidade)!
            }
        }
        
        //Atualiza valores na cesta de compras
        let cliCar = realm.objects(ClientCars.self).filter("idBucket = %@ AND idClient = %@ AND idCar = %@", clientCar.idBucket, clientCar.idClient, clientCar.idCar)
        
        if let updateClientCar = cliCar.first {
            try! realm.write {
                updateClientCar.quantidade += clientCar.quantidade
                updateClientCar.valor += clientCar.valor
            }
        }
        
        
    }
    
    //Remove saldo do cliente
    func deleteClientCar(_ clientCar: ClientCars, car: Car) {
        
        let realm = try! Realm()
        
        let cliCar = realm.objects(ClientCars.self).filter("idBucket = %@ AND idClient = %@ AND idCar = %@", clientCar.idBucket, clientCar.idClient, clientCar.idCar)
        
        let cCar = realm.objects(Car.self).filter("id = %@", car.id)
        
        var apagaCarro = false

        if let deleteClientCar = cliCar.first {
            try! realm.write {
                deleteClientCar.quantidade -= clientCar.quantidade
                deleteClientCar.valor -= clientCar.valor
                
                //Se o novo valor for igual a zero, deve escluir o carro da cesta de compras
                if (deleteClientCar.valor == 0) {
                    
                    apagaCarro = true
                }
            }
        }
        
        if (apagaCarro) {
            if let deleteCar = cCar.first {
                try! realm.write {
                    deleteCar.quantidade += car.quantidade
                }
            }
            deleteCar(clientCar, car: car)
        } else {
            if let deleteCar = cCar.first {
                try! realm.write {
                    deleteCar.quantidade += car.quantidade
                }
            }
        }
        
        
    }
    
    //Remove Quantidade do carro na cesta de compras
    func deleteCar(_ clientCar: ClientCars, car: Car) {
        
        let realm = try! Realm()
        
        //Remove os carros da cesta de compras do Realm
        let predicate = NSPredicate(format: "idBucket = %@ AND idClient = %@ AND idCar = %@", clientCar.idBucket, clientCar.idClient, clientCar.idCar)
        let cliCar = realm.objects(ClientCars.self).filter(predicate)
        
        try! realm.write {
            realm.delete(cliCar)
        }
        
        //Remove o carro do Realm
        let aCar = realm.objects(Car.self).filter("id = %@", car.id)
        try! realm.write {
            realm.delete(aCar)
        }
    }

    //Recupera dados da cesta de compras
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
    
    //Recupera quantidade de um carro que está dentro da cesta de compras
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
    
    //Recupera quantidade de um carro que está dentro da cesta de compras
    func getAllCarBucket(_ id: Int) -> [CarBucketModel] {
        
        let realm = try! Realm()
        let car = CarBucketModel()
        
        let bucketCar = realm.objects(Car.self).filter("id = %@", id)
        
        for c in bucketCar {
            car.id = c.id
            car.nome = c.nome
            car.imagem = c.imagem
            car.quantidade = c.quantidade
            car.preco = c.preco
        }
        
        return [car]
    }
    
    //Recupera saldo da cesta de compras
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
    
    //Recupera saldo da cesta de compras do cliente
    func getClientSale() -> Double {
        
        let realm = try! Realm()
        var valor = 0.0
        
        //Recupera o saldo inicial do Cliente
        let cliCar = realm.objects(ClientCars.self)
        
        //Subtrai os valores adicionados
        for c in cliCar {
            valor = valor + c.valor
        }
        
        return valor
    }
    
    //Recupera Todos os dados dos carros da cesta de compras
    func getAllBucket() -> [Car] {
        
        let realm = try! Realm()
        let bucketRealm = realm.objects(Car.self)
  
        let bucketList = Array(bucketRealm)
        return bucketList
    }
    
    //Remove a cesta de compras
    func removeAllBucket() {
        
        //Recupera o Bucket ativo
        let bucketId = self.verifyBucketExists()
        
        let realm = try! Realm()
        
        //Recupera o Bucket
        let bucket = realm.objects(Bucket.self).filter("id = %@", bucketId)
        
        //Recupera os carros
        let cars = realm.objects(Car.self)
        
        var newSale = 0.0
        
        //Recupera o novo saldo dos carros do Bucket
        let carsInBucket = realm.objects(ClientCars.self).filter("idBucket = %@", bucketId)
        
        for carBucket in carsInBucket {
            let preco = carBucket.valor
            newSale = newSale + preco
        }
        
        //Recupera e atualiza o saldo do Ciente
        let client = realm.objects(Client.self).filter("email = %@", EMAIL_CLIENT)
        
        if let updateClientSale = client.first {
            try! realm.write {
                updateClientSale.saldo = (updateClientSale.saldo + newSale)
            }
        }
        
        //Remove a cesta de compras
        try! realm.write {
            realm.delete(bucket)
            realm.delete(carsInBucket)
            realm.delete(cars)
        }
        
    }
    
    //Salva cesta de compras ativa
    func saveAllBucket() {
        
        //Recupera o Bucket ativo
        let bucketId = self.verifyBucketExists()
        
        let realm = try! Realm()
        
        //Recupera o Bucket
        let bucket = realm.objects(Bucket.self).filter("id = %@", bucketId)
        
        //Recupera os carros do Bucket
        let carsInBucket = realm.objects(ClientCars.self).filter("idBucket = %@", bucketId)
        
        //Recupera os carros
        let cars = realm.objects(Car.self)
        
        //Recupera dados do Cliente
        let client = ClientRealmModel().getClient(EMAIL_CLIENT)
        
        //Prepara para salvar a transação de compra
        var newSale = 0.0
        var listCars = ""
        
        for carBucket in carsInBucket {
            let preco = carBucket.valor
            let carroId = carBucket.idCar
            
            newSale = newSale + preco
            listCars = listCars + "\(carroId) | "
        }
        
        let transaction = BucketTransactionsModel()
        transaction.idBucket = bucketId
        transaction.idClient = client.id
        transaction.listCars = listCars
        transaction.valor = newSale
        
        //Remove dados da cesta de compras
        try! realm.write {
            realm.delete(bucket)
            realm.delete(carsInBucket)
            realm.delete(cars)
        }
        
        //Salva a compra em transações
        BucketTransactionsRealmModel().saveBucketTransactions(transaction)
        
    }
}
