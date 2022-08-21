//
//  CalculatedResultViewController.swift
//  HamiltonTask
//
//  Created by Aya Bassi on 20/08/2022.
//

import UIKit

class CalculatedResultViewController: UIViewController {

    var amount: String?
    var convertedAmount: String?
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var convertedAmountLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountLabel.text = amount
        convertedAmountLabel.text = convertedAmount
        
    }
    

}
