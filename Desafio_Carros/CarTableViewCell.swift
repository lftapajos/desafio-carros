//
//  CarTableViewCell.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 14/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit
import SDWebImage

class CarTableViewCell: UITableViewCell {

    @IBOutlet weak var carImage: CircleImage!
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var carPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func confiqureCarCell(item: CarsModel){
        
        self.carImage.sd_setImage(with: URL(string: (item.imagem)!))
        self.carName.text = item.nome
        self.carPrice.text = "\(Help.shared.formatCoin("pt_BR", valor: item.preco!))"
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
