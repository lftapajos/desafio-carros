//
//  CarRealmModel.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 14/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: Modelo de Cliente
class CarRealmModel {
    
    //Adiciona um novo cliente ao Realm
    func addCar(_ car: CarsModel) -> Bool {
        
        let newcar = Car()
        var retorno = false
        
        newcar.id = car.id!
        newcar.nome = car.nome!
        newcar.descricao = car.descricao!
        newcar.marca = car.marca!
        newcar.quantidade = car.quantidade!
        newcar.preco = car.preco!
        newcar.imagem = car.imagem!
        newcar.quantidadeCesta = car.quantidadeCesta!
        
        let realm = try! Realm()
        
        if (verifyCarExists(car)) {
            retorno = false
        } else {
            try! realm.write {
                realm.add(newcar)
                print("Car \(newcar.nome) add with success in Realm.")
                retorno = true
            }
        }
        return retorno
    }
    
    //Verifica se o Carro já existe
    func verifyCarExists(_ car: CarsModel) -> Bool {
        
        let realm = try! Realm()
        
        let car = realm.objects(Car.self)
        
        let predicate = NSPredicate(format: "nome = %@", (car.first?.nome)!)
        let filteredCar = car.filter(predicate)
        
        if (filteredCar.count > 0) {
            print("Nome: \(String(describing: filteredCar.first!.nome))")
            return true
        } else {
            print("Car don't exists!")
            return false
        }
    }
    
    //Recupera dados do Carro
    func getCar(_ id: Int) -> Car {
        
        let realm = try! Realm()
        let car = Car()
        
        let detailCar = realm.objects(Car.self)
        
        let predicate = NSPredicate(format: "id = %@", id)
        let filteredCar = detailCar.filter(predicate)
        
        for c in filteredCar {
            
            car.id = c.id
            car.nome = c.nome
            car.descricao = c.descricao
            car.marca = c.marca
            car.quantidade = c.quantidade
            car.preco = c.preco
            car.imagem = c.imagem
            car.quantidadeCesta = c.quantidadeCesta
        }
        return car
    }
    
    //Atualiza quantidade do Carro
    func updateCarQuantity(_ id: Int, newQuantity: Int) {
        
        let realm = try! Realm()
        
        let detailCar = realm.objects(Car.self).filter("id = %@", id)
        
        if let car = detailCar.first {
            try! realm.write {
                car.quantidade = newQuantity
            }
        }
    }
}
