//
//  ConvertedResultViewController.swift
//  HamiltonTask
//
//  Created by Aya Bassi on 21/08/2022.
//

import UIKit

class ConvertedResultViewController: UIViewController {
    
    // MARK: - Properties
    var convertedAmount : String = ""
    var targetCurrency : String = ""
    
    var conversionRate : Double?
    
    
    @IBAction func goToHomePageDoneButton(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var convertedAmountAndCurrencyLabel: UILabel!
    
    
    @IBOutlet weak var conversionRateLabel: UILabel!
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        convertedAmountAndCurrencyLabel.text = "Great now you have \(convertedAmount) in your account"
        
        if let conversionRate = conversionRate {
            let roundedConvertionRate = round(conversionRate * 100 ) / 100
            conversionRateLabel.text = "You conversion rate was 1\\\(roundedConvertionRate)"
        }
    }
}
