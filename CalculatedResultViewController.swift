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
    var conversionRate: Double?
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var convertedAmountLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var countDownTimer : Timer?
    var secondsRemaining = 30
    
    @IBAction func convertAndTransferCurrency(_ sender: UIButton) {
        
        countDownTimer?.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToConvertedResultScreen"{
            
            let destinationVC = segue.destination as! ConvertedResultViewController
            
            
            if let convertedAmount = self.convertedAmount {
                destinationVC.convertedAmount = convertedAmount
            }
            
            if let conversionRate = conversionRate {
                destinationVC.conversionRate = conversionRate
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountLabel.text = amount
        convertedAmountLabel.text = convertedAmount
        
        countDownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
    }
    
    // MARK: - Selectors
    
    @objc func updateCounter(){
        
        if secondsRemaining >= 0 {
            timerLabel.text = "\(secondsRemaining) sec left"
            secondsRemaining -= 1
        } else {
            // reset timer
            secondsRemaining = 30
            // stop countdown timer to save battery
            countDownTimer?.invalidate()
            
            let alert = UIAlertController(title: "Time is Up", message: "Please start again!", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
    }
}



