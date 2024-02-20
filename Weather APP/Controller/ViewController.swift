//
//  ViewController.swift
//  Weather APP
//
//  Created by Evan Hu on 2/16/24.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let weather = Weather()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lon = locations[0].coordinate.longitude
        let lat = locations[0].coordinate.latitude
//        print(lon)
//        print(lat)
        AF.request("https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=96947fc4fb3be40cf8110ba69548f522").responseJSON { response in
            if let data = response.value{
                let weatherJSON = JSON(data)
                //Data
                self.weather.temp = String(round(weatherJSON["main"]["temp"].doubleValue - 273.15))
                self.weather.icon = weatherJSON["weather",0,"icon"].stringValue
                self.weather.city = weatherJSON["name"].stringValue
                //UI
                self.tempLabel.text = "\(self.weather.temp)°"
                self.cityLabel.text = self.weather.city
                self.iconImageView.image = UIImage(named: self.weather.icon)
//                print(weatherJSON["weather"][0]["icon"])
//                print(weatherJSON["name"])
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }


}

