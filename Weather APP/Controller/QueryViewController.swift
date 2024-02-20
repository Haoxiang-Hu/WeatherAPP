//
//  QueryViewController.swift
//  Weather APP
//
//  Created by Evan Hu on 2/19/24.
//

import UIKit

protocol QueryViewControllerDelegate{
    func didChangeCity(city: String)
}

class QueryViewController: UIViewController {
    
    var currentCity = ""
    var delegate: QueryViewControllerDelegate?
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var currentCityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextField.becomeFirstResponder()   //cityTextField.resignFirstResponder()
        currentCityLabel.text = currentCity
    }
    
    @IBAction func back(_ sender: Any) { dismiss(animated: true) }
    
    @IBAction func query(_ sender: Any) {
        dismiss(animated: true)
        if !cityTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            delegate?.didChangeCity(city: cityTextField.text!)
        }
    }
    
}
