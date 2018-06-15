//
//  Alert.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 14/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class Alert: NSObject {
    
    // MARK: Declarações
    let controller: UIViewController
    
    // MARK: Construtor
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    // MARK: Métodos
    func show(_ title: String = "ATENÇÃO", message: String = "Error", handler: @escaping (UIAlertAction) -> Void) {
        let details = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: handler)
        details.addAction(cancel)
        controller.present(details, animated: true, completion: nil)
    }
}
