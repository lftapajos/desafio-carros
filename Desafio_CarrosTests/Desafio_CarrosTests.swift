//
//  Desafio_CarrosTests.swift
//  Desafio_CarrosTests
//
//  Created by Luis Felipe Tapajos on 14/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import XCTest
@testable import Desafio_Carros

class Desafio_CarrosTests: XCTestCase {
    
    var help = Help()
    
    func testformatCoin() {
        
        let retorno = help.formatCoin("pt_BR", valor: 100000.00)
        XCTAssertEqual(retorno, "R$100.000,00")
        
    }
}
