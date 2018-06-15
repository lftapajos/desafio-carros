//
//  Help.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 15/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class Help: NSObject {
    
    static let shared = Help()

    func formatCoin(_ codigo: String, valor: Double) -> String {
        
        let formatter = NumberFormatter()
        let locale = Locale(identifier: codigo)
        formatter.locale = locale
        formatter.numberStyle = .currency
        let valorFormatado = formatter.string(from: valor as NSNumber)
        return valorFormatado!
        
    }
    
}
