//
//  BucketTransactionsRealmModel.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 22/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: Modelo de Cliente
class BucketTransactionsRealmModel {
    
    //Função para salvar a trabsação de compra
    func saveBucketTransactions(_ transaction: BucketTransactionsModel) {
        
        let realm = try! Realm()
        
        let newTransaction = BucketTransactions()
        
        newTransaction.idBucket = transaction.idBucket!
        newTransaction.idClient = transaction.idClient!
        newTransaction.listCars = transaction.listCars!
        newTransaction.valor = transaction.valor!
        
        try! realm.write {
            realm.add(newTransaction)
        }
        
        
    }
    
}
