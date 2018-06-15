//
//  CarResponse.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 14/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import ObjectMapper

class CarResponse: Mappable {
    
    var carModelList : [CarsModel]?
    var carModelDetail : CarsModel?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        carModelList <- map ["results"]
        carModelDetail <- map ["results"]
    }
}
