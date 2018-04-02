//
//  KindOfProjectTableViewCell.swift
//  vimojo
//
//  Created by Jesus Huerta on 02/04/2018.
//  Copyright © 2018 Videona. All rights reserved.
//

import UIKit

class KindOfProjectTableViewCell: UITableViewCell {
    
    var presenter: KindOfProjectPresenterProtocol?
    var arrayOfCellData = ["Falso directo", "Vídeo en bruto", "Colas", "Gráfico", "Piezas"]

    @IBOutlet weak var mainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func setKindOfProject(_ sender: UISwitch) {
        presenter?.setKindOfProject(arrayOfCellData[sender.tag])
    }
}
