//
//  KelimeDetayViewController.swift
//  Sozluk Uygulamasi
//
//  Created by Yunus Emre Berdibek on 26.02.2023.
//

import UIKit

class KelimeDetayViewController: UIViewController {

    @IBOutlet weak var turkceLabel: UILabel!
    @IBOutlet weak var ingilizceLabel: UILabel!
    
    var kelime:Kelimeler?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let k = kelime {
            ingilizceLabel.text = k.ingilizce
            turkceLabel.text = k.turkce
        }
    }
    


}
