//
//  BucketViewModel.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 17/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class BucketViewModel: NSObject {

    @IBOutlet weak var apiClient: APIClient!
    
    //Função para Retornar para a View de lista de carros
    func callReturnViewController(_ controller: BucketViewController) {
        controller.navigationController?.popToRootViewController(animated: true)
    }
    
}
