//
//  CarrosModel.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 14/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import ObjectMapper

class CarsModel: Mappable {
    
    var cars : [CarsModel]?
    
    var id: Int?
    var nome: String?
    var descricao: String?
    var marca: String?
    var quantidade: Int?
    var preco: Double?
    var imagem: String?
    var quantidadeCesta: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        nome <- map["nome"]
        descricao <- map["descricao"]
        marca <- map["marca"]
        quantidade <- map["quantidade"]
        preco <- map["preco"]
        imagem <- map["imagem"]
        quantidadeCesta <- map["quantidadeCesta"]
        
    }
    
}
