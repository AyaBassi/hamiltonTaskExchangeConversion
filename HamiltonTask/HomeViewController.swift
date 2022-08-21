//
//  ViewController.swift
//  HamiltonTask
//
//  Created by Aya Bassi on 16/08/2022.
//

import UIKit
import Foundation

//api key from apilayer: cJnWcE3rqizyyeb9ObAJW8aZ4hupF3NX
//http format "https://api.apilayer.com/exchangerates_data/convert?to=\(targetCur)&from=\(sourceCur)&amount=\(amount)"

// api key from exchangerate-api: 5c950ea0cc082cf1fc601ac9
//http format: "https://v6.exchangerate-api.com/v6/YOUR-API-KEY/pair/EUR/GBP/AMOUNT"
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

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    struct ConversionInfo: Codable {
    let conversion_rate: Double
    let conversion_result: Double
    }
    
    var conversionRate : Double?
    var conversionResult : Double?
    
    let currencies = ["AED","AFN","ALL","AMD","ANG","AOA","ARS","AUD","AWG","AZN","BAM","BBD","BDT","BGN","BHD","BIF","BMD","BND","BOB","BRL","BSD","BTN","BWP","BYN","BZD","CAD","CDF","CHF","CLP","CNY","COP","CRC","CUP","CVE","CZK","DJF","DKK","DOP","DZD","EGP","ERN","ETB","EUR","FJD","FKP","FOK","GBP","GEL","GGP","GHS","GIP","GMD","GNF","GTQ","GYD","HKD","HNL","HRK","HTG","HUF","IDR","ILS","IMP","INR","IQD","IRR","ISK","JEP","JMD","JOD","JPY","KES","KGS","KHR","KID","KMF","KRW","KWD","KYD","KZT","LAK","LBP","LKR","LRD","LSL","LYD","MAD","MDL","MGA","MKD","MMK","MNT","MOP","MRU","MUR","MVR","MWK","MXN","MYR","MZN","NAD","NGN","NIO","NOK","NPR","NZD","OMR","PAB","PEN","PGK","PHP","PKR","PLN","PYG","QAR","RON","RSD","RUB","RWF","SAR","SBD","SCR","SDG","SEK","SGD","SHP","SLE","SOS","SRD","SSP","STN","SYP","SZL","THB","TJS","TMT","TND","TOP","TRY","TTD","TVD","TWD","TZS","UAH","UGX","USD","UYU","UZS","VES","VND","VUV","WST","XAF","XCD","XDR","XOF","XPF","YER","ZAR","ZMW","ZWL","LYD","SSP","SYP","VES","YER","ZWL"]
    
    @IBOutlet weak var sourceCurrencyRightTextField: UITextField!
    
    @IBOutlet weak var targetCurrencyRightTextField: UITextField!
    
    @IBOutlet weak var inputAmountTextField: UITextField!
    
    // button will make an api call and get result regarding given amount and source currency to convertedAmount and also grab the conversion rate
    @IBAction func convertButton(_ sender: UIButton) {
        
        guard let sourceCurrency = sourceCurrencyRightTextField.text else { return }
        guard let targetCurrency = targetCurrencyRightTextField.text else { return }
        
        if !currencies.contains(sourceCurrency) || !currencies.contains(targetCurrency){
            print("Please write the correct currency Code")
            return
        }
        guard let amount = inputAmountTextField.text else { return }
        
        if inputAmountTextField.text == "" {
            print("please add an amount!")
            return
        }
        
        makeConversionApiCall(amount: amount, sourceCur: sourceCurrency, targetCur: targetCurrency) { data in
            // success
            do {
                let decodedConversionInfo = try JSONDecoder().decode(ConversionInfo.self, from: data)

                self.conversionRate = decodedConversionInfo.conversion_rate
                self.conversionResult = decodedConversionInfo.conversion_result

                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "goToCalculatedResultScreen", sender: self)
                    self.inputAmountTextField.text = ""
                }

            } catch { print(error) }
        }
    }
    // create two pickerViews one for source and one for target currency
    var sourceCurrencyPickerView = UIPickerView()
    var targetCurrencyPickerview = UIPickerView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let imageViewText = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 20))
        let imageText = UIImage(named: "angleBracket2")
        imageViewText.image = imageText
        sourceCurrencyRightTextField.rightView = imageViewText
        sourceCurrencyRightTextField.rightViewMode = .always
        
        let imageViewText2 = UIImageView(frame: CGRect(x: 0, y: 0.0, width: 20, height: 20))
        let imageText2 = UIImage(named: "angleBracket2")
        imageViewText2.image = imageText2
        
        targetCurrencyRightTextField.leftView = imageViewText2
        targetCurrencyRightTextField.leftViewMode = .always
        
        
        hideKeyboardWhenTappedAround()
        
        // set delegate and datasource of source currency pickerView
        sourceCurrencyPickerView.delegate = self
        sourceCurrencyPickerView.dataSource = self
        
        // set delegate and datasource of target currency picker view
        targetCurrencyPickerview.delegate = self
        targetCurrencyPickerview.dataSource = self
        
        // set the inputView of the textfields to the pickerviews
        sourceCurrencyRightTextField.inputView = sourceCurrencyPickerView
        targetCurrencyRightTextField.inputView = targetCurrencyPickerview
        
        // need to give tag to pickerviews to that in delegate methods can differentiate between the two
        sourceCurrencyPickerView.tag = 1
        targetCurrencyPickerview.tag = 2
        
        // Show preselected currencies for simplicity
        sourceCurrencyRightTextField.text = currencies[46]
        targetCurrencyRightTextField.text = currencies[145]
        
        // preselect currency code to GBP and USD for simplicity
        sourceCurrencyPickerView.selectRow(46, inComponent: 0, animated: false)
        targetCurrencyPickerview.selectRow(145, inComponent: 0, animated: false)
    }
    
    //MARK: - API CALL
    
    func makeConversionApiCall(amount:String,sourceCur:String, targetCur:String, completionHandler: @escaping (_ data : Data)->Void){
        let semaphore = DispatchSemaphore (value: 0)

        let url = "https://v6.exchangerate-api.com/v6/\(API_KEY_FROM_XCHANGE_API)/pair/\(sourceCur)/\(targetCur)/\(amount)"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            completionHandler(data)
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCalculatedResultScreen" {
            
            let destinationVC = segue.destination as! CalculatedResultViewController
            
                if let amount = self.inputAmountTextField.text ,
                   let sourceCurrency = self.sourceCurrencyRightTextField.text {
                    destinationVC.amount = "\(amount) \(sourceCurrency)"
                }
                
                if let targetCurrecy = self.targetCurrencyRightTextField.text ,
                   let convertedResult = conversionResult ,
                    var conversionRate = self.conversionRate {
                    
                    // round up the amount to 2 decimal point
                    let doubleConRes : Double = convertedResult
                    let roundedConRes = round(doubleConRes * 100 ) / 100
                    
                    destinationVC.convertedAmount = "\(roundedConRes) \(targetCurrecy)"
                    conversionRate = 1/conversionRate
                    destinationVC.conversionRate = conversionRate
                }
        }
    }
}



extension HomeViewController :  UIPickerViewDelegate , UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1). \(currencies[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            sourceCurrencyRightTextField.text = currencies[row]
            sourceCurrencyRightTextField.resignFirstResponder()
        case 2:
            targetCurrencyRightTextField.text = currencies[row]
            targetCurrencyRightTextField.resignFirstResponder()
        default:
            break
        }
    }
}


extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}


