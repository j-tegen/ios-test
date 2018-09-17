//
//  ViewController.swift
//  Reseersättaren
//
//  Created by Jonatan Tegen on 2018-09-05.
//  Copyright © 2018 Jonatan Tegen. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var PaymentPicker: UIPickerView!
    @IBOutlet weak var NameInput: UITextField!
    @IBOutlet weak var SocialSecurityInput: UITextField!
    @IBOutlet weak var FromStationInput: UITextField!
    @IBOutlet weak var ToStationInput: UITextField!
    @IBOutlet weak var ExpectedArrivalInput: UIDatePicker!
    @IBOutlet weak var ActualArrivalInput: UIDatePicker!
    @IBOutlet weak var BankInput: UITextField!
    @IBOutlet weak var ClearingInput: UITextField!
    @IBOutlet weak var BankAccountInput: UITextField!
    @IBOutlet weak var StationView: UIView!
    
    @IBOutlet weak var SearchFromSation: UITextField!
    @IBOutlet weak var StationTableView: UITableView!
    let dateFormatter = DateFormatter()
    let userDefaults = UserDefaults.standard
    
    var paymentPickerData: [String] = [String]()
    var selectedPaymentType: String!
    
    var mainList = [String]()
    var stationList = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        //En delegate lyssnar på en tableview. Om man gör något med den. Self i datasource är min viewcontroller.
        StationTableView.delegate = self
        StationTableView.dataSource = self
        
        FromStationInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        paymentPickerData = ["Kort", "App", "Jojo-kort"]
        selectedPaymentType = paymentPickerData[0]
        
        PaymentPicker.delegate = self
        PaymentPicker.dataSource = self
        NameInput.delegate = self
        SocialSecurityInput.delegate = self
        FromStationInput.delegate = self
        ToStationInput.delegate = self
        BankInput.delegate = self
        ClearingInput.delegate = self
        BankAccountInput.delegate = self
        
        NameInput.text = userDefaults.object(forKey: "name") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInputInvalid(input: UIView){
        input.layer.borderColor = UIColor.red.cgColor
        input.layer.borderWidth = 1.0
    }
    
    func setInputValid(input: UIView) {
        input.layer.borderColor = UIColor.black.cgColor
        input.layer.borderWidth = 0.0
    }
    
    func checkTextFieldValid(input: UITextField) -> Bool {
        if (input.text == "") {
            setInputInvalid(input: input)
            return false
        }
        return true
    }
    
    func validateInput() -> Bool {
        var valid = true
        
        valid = checkTextFieldValid(input: NameInput) && valid
        valid = checkTextFieldValid(input: SocialSecurityInput) && valid
        valid = checkTextFieldValid(input: FromStationInput) && valid
        valid = checkTextFieldValid(input: ToStationInput) && valid
        valid = checkTextFieldValid(input: BankInput) && valid
        valid = checkTextFieldValid(input: ClearingInput) && valid
        valid = checkTextFieldValid(input: BankAccountInput) && valid
        
        return valid
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return paymentPickerData.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return paymentPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPaymentType = paymentPickerData[row]
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("didendedit")
        if (textField.text == "") {
            setInputInvalid(input: textField)
        }
        if(textField == SearchFromSation){
            searchStation(stationName: SearchFromSation.text!)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setInputValid(input: textField)
        if textField == FromStationInput {
            stationList = ["Lund C", "Malmö C", "Malmö Hyllie", "Triangeln"]
            StationView.isHidden = false
            StationTableView.reloadData()
        }
    }
    
    //Denna funger. Borde dock försöka få igång textfielddidchange. känns snyggare
    @IBAction func SearchFromStation(_ sender: Any) {
        print(SearchFromSation.text!)
        searchStation(stationName: SearchFromSation.text!)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if(textField == SearchFromSation){
            print("test")
        }
    }
    
    @IBAction func CloseStationButton(_ sender: Any) {
        closeStationView()
    }
    
    func closeStationView() {
        StationView.isHidden = true
    }
    
    func setUserDefaults() {
        userDefaults.set(NameInput.text, forKey: "name")
    }
    
    func searchStation(stationName: String) {
        //Temp list of stations. Can we store them somewhere else?
        mainList = ["Lund C", "Malmö C", "Malmö Hyllie", "Triangeln",
                    "Lund C",
                    "CPH Airport",
                    "Lund Botulfsplatsen",
                    "Lund Univ-sjukhuset",
                    "Lund Bankgatan",
                    "Lund Bantorget",
                    "Ludvigsborgs friskola",
                    "Lundavägen 1 Malmö",
                    "Lundsbäcksgatan 5 Helsingborg",
                    "Luftkastellet",
                    "Lugna Gården",
                    "Lugna gatan 1 Malmö",
                    "Luhrsjöbaden",
                    "Lundegatan 1 Simrishamn",
                    "Lupinvägen 1 Löddeköpinge"]
        stationList = mainList.filter { $0.lowercased().contains(stationName.lowercased()) }
        StationTableView.reloadData()
    }
 
    @IBAction func GoToSendEmail(_ sender: Any) {
        if (!validateInput()) {
            return
        }
        setUserDefaults()
        performSegue(withIdentifier: "SkanetrafikenToSendEmail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SkanetrafikenToSendEmail") {
            if let send = segue.destination as? SendEmailViewController {
                send.name = NameInput.text!
                send.socialSecurity = SocialSecurityInput.text!
                send.fromStation = FromStationInput.text!
                send.toStation = ToStationInput.text!
                send.expectedArrival = dateFormatter.string(from: ExpectedArrivalInput.date)
                send.actualArrival = dateFormatter.string(from: ActualArrivalInput.date)
                send.bank = BankInput.text!
                send.clearingNumber = ClearingInput.text!
                send.account = BankAccountInput.text!
                send.paymentType = selectedPaymentType!
            }
        }
    }
    
    // numberOfRowsInsections = hur många rader ska vi ha i listan
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationList.count
    }
    
    //CellForRowAt = här bygger man hur cellen ska se ut och vad man ska ha i varje cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"row", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = stationList[indexPath.row]
        return cell
    }
}

