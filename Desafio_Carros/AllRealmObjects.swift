//
//  AllRealmObjects.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 14/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: Modelos do Realm

// MARK: Modelo de Cliente
class Client : Object {
    
    dynamic var id: String = ""
    dynamic var nome: String = ""
    dynamic var email: String = ""
    dynamic var saldo: Double = 0.0
}

// MARK: Modelo de Carro
class Car : Object {
    
    dynamic var id: Int = 0
    dynamic var nome: String = ""
    dynamic var descricao: String = ""
    dynamic var marca: String = ""
    dynamic var quantidade: Int = 0
    dynamic var preco: Double = 0.0
    dynamic var imagem: String = ""
    dynamic var quantidadeCesta: Int = 0
}

// MARK: Modelo de Cesta de Compras
class Bucket : Object {
    
    dynamic var id: String = ""
    dynamic var status: Bool = true
}

class ClientCars : Object {
    
    dynamic var idBucket: String = ""
    dynamic var idClient: String = ""
    dynamic var idCar: String = ""
    dynamic var quantidade: Int = 0
    dynamic var valor: Double = 0.0
}

class BucketTransactions : Object {
    
    dynamic var idBucket: String = ""
    dynamic var idClient: String = ""
    dynamic var listCars: String = ""
    dynamic var valor: Double = 0.0
}
