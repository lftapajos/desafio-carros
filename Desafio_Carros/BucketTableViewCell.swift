//
//  BucketTableViewCell.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 17/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit
import SDWebImage

class BucketTableViewCell: UITableViewCell {

    //confiqureBucketCell
    
    @IBOutlet var bucketViewModel: BucketViewModel!
    
    @IBOutlet weak var carImage: CircleImage!
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var carQuantity: UILabel!
    @IBOutlet weak var carPrice: UILabel!
    
    var car = [Car]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func confiqureBucketCell(item: Car){
        self.carImage.sd_setImage(with: URL(string: (item.imagem)))
        self.carName.text = item.nome
        self.carQuantity.text = "\(item.quantidade)"
        self.carPrice.text = "\(String(describing: item.preco))"
        
        self.car = [item]
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
