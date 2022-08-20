//
//  ViewController.swift
//  HamiltonTask
//
//  Created by Aya Bassi on 16/08/2022.
//

import UIKit
import Foundation

//api key from apilayer: cJnWcE3rqizyyeb9ObAJW8aZ4hupF3NX
//"https://api.apilayer.com/exchangerates_data/convert?to=\(targetCur)&from=\(sourceCur)&amount=\(amount)"

// api key from exchangerate-api: 5c950ea0cc082cf1fc601ac9
//https://v6.exchangerate-api.com/v6/YOUR-API-KEY/pair/EUR/GBP/AMOUNT
let API_KEY_FROM_XCHANGE_API = "5c950ea0cc082cf1fc601ac9"


// response example
/*
"result":"success",
 "documentation":"https://www.exchangerate-api.com/docs",
 "terms_of_use":"https://www.exchangerate-api.com/terms",
 "time_last_update_unix":1660953601,
 "time_last_update_utc":"Sat, 20 Aug 2022 00:00:01+0000",
 "time_next_update_unix":1661040001,
 "time_next_update_utc":"Sun, 21 Aug 2022 00:00:01 +0000",
 "base_code":"USD",
 "target_code":"GBP",
 "conversion_rate":0.8451,
 "conversion_result":84.51}
*/

class ViewController: UIViewController {
    
    // MARK: - Properties
    struct ConversionInfo: Codable {
    let conversion_rate: Double
    let conversion_result: Double
    }
    
    let currencies = ["AED","AFN","ALL","AMD","ANG","AOA","ARS","AUD","AWG","AZN","BAM","BBD","BDT","BGN","BHD","BIF","BMD","BND","BOB","BRL","BSD","BTN","BWP","BYN","BZD","CAD","CDF","CHF","CLP","CNY","COP","CRC","CUP","CVE","CZK","DJF","DKK","DOP","DZD","EGP","ERN","ETB","EUR","FJD","FKP","FOK","GBP","GEL","GGP","GHS","GIP","GMD","GNF","GTQ","GYD","HKD","HNL","HRK","HTG","HUF","IDR","ILS","IMP","INR","IQD","IRR","ISK","JEP","JMD","JOD","JPY","KES","KGS","KHR","KID","KMF","KRW","KWD","KYD","KZT","LAK","LBP","LKR","LRD","LSL","LYD","MAD","MDL","MGA","MKD","MMK","MNT","MOP","MRU","MUR","MVR","MWK","MXN","MYR","MZN","NAD","NGN","NIO","NOK","NPR","NZD","OMR","PAB","PEN","PGK","PHP","PKR","PLN","PYG","QAR","RON","RSD","RUB","RWF","SAR","SBD","SCR","SDG","SEK","SGD","SHP","SLE","SOS","SRD","SSP","STN","SYP","SZL","THB","TJS","TMT","TND","TOP","TRY","TTD","TVD","TWD","TZS","UAH","UGX","USD","UYU","UZS","VES","VND","VUV","WST","XAF","XCD","XDR","XOF","XPF","YER","ZAR","ZMW","ZWL","LYD","SSP","SYP","VES","YER","ZWL"]
    
    @IBOutlet weak var sourceCurrencyRightTextField: UITextField!
    
    @IBOutlet weak var targetCurrencyRightTextField: UITextField!
    
    @IBOutlet weak var inputAmountTextField: UITextField!
    
    @IBAction func convertButton(_ sender: UIButton) {
        
        guard let amount = inputAmountTextField.text else { return }
        guard let sourceCurrency = sourceCurrencyRightTextField.text else { return }
        guard let targetCurrency = targetCurrencyRightTextField.text else { return }
        convert(amount: amount, sourceCur: sourceCurrency, targetCur: targetCurrency)
        
        
        
    }
    
    var sourceCurrencyPickerView = UIPickerView()
    var targetCurrencyPickerview = UIPickerView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        sourceCurrencyPickerView.delegate = self
        sourceCurrencyPickerView.dataSource = self
        
        targetCurrencyPickerview.delegate = self
        targetCurrencyPickerview.dataSource = self
        
        sourceCurrencyRightTextField.inputView = sourceCurrencyPickerView
        targetCurrencyRightTextField.inputView = targetCurrencyPickerview
        
        sourceCurrencyPickerView.tag = 1
        targetCurrencyPickerview.tag = 2
        
        sourceCurrencyRightTextField.text = currencies.first
        targetCurrencyRightTextField.text = currencies.first
    }
    
    //MARK: - API CALL
    
    func convert(amount:String,sourceCur:String, targetCur:String){
        let semaphore = DispatchSemaphore (value: 0)

        let url = "https://v6.exchangerate-api.com/v6/\(API_KEY_FROM_XCHANGE_API)/pair/\(sourceCur)/\(targetCur)/\(amount)"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            // success
            do {
                let decodedSentences = try JSONDecoder().decode(ConversionInfo.self, from: data)
                
                print(decodedSentences.conversion_rate)
                print(decodedSentences.conversion_result)
                
            } catch { print(error) }
            
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
}

extension ViewController :  UIPickerViewDelegate , UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            sourceCurrencyRightTextField.text = currencies[row]
        case 2:
            targetCurrencyRightTextField.text = currencies[row]
        default:
            break
        }
        
        sourceCurrencyRightTextField.resignFirstResponder()
    }
}



