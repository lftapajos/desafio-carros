//
//  ShadowView.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 14/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRY, green: SHADOW_GRY, blue: SHADOW_GRY, alpha: SHADOW_GRY).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
    }
}
