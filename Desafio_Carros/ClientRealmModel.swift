//
//  ClientRealmModel.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 14/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: Modelo de Cliente
class ClientRealmModel {
    
    //Adiciona um novo cliente ao Realm
    func addClient(_ client: ClientsModel) -> Bool {
        
        let newClient = Client()
        var retorno = false
        
        newClient.id = client.id!
        newClient.nome = client.nome!
        newClient.email = client.email!
        newClient.saldo = client.saldo!

        let realm = try! Realm()
        
        if (verifyClientExists(newClient)) {
            retorno = false
        } else {
            try! realm.write {
                realm.add(newClient)
                print("Client \(newClient.nome) add with success in Realm.")
                retorno = true
            }
        }
        return retorno
    }
    
    //Verifica se o Carro já existe
    func verifyClientExists(_ client: Client) -> Bool {
        
        let realm = try! Realm()
        
        let cli = realm.objects(Client.self)
        
        let predicate = NSPredicate(format: "email = %@", client.email)
        let filteredClient = cli.filter(predicate)
        
        if (filteredClient.count > 0) {
            print("Client: \(String(describing: filteredClient.first!.nome))")
            return true
        } else {
            print("Client don't exists!")
            return false
        }
    }
    
    //Recupera ddos do Cliente
    func getClient(_ email: String) -> Client {
        
        let realm = try! Realm()
        let client = Client()
        
        let detailCliente = realm.objects(Client.self)
        
        let predicate = NSPredicate(format: "email = %@", email)
        let filteredCliente = detailCliente.filter(predicate)
        
        for cli in filteredCliente {
            
            client.id = cli.id
            client.nome = cli.nome
            client.email = cli.email
            client.saldo = cli.saldo
            
        }
        
        return client
    }
    
}

//let confirma = clienteModel.addCliente(nomeTextField.text!, email: emailTextField.text!, senha: senhaTextField.text!, saldo: 100000)
