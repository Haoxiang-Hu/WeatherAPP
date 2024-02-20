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

class ViewController: UIViewController, CLLocationManagerDelegate, QueryViewControllerDelegate{
    
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
        
        //Weather request
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
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Loading Error"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? QueryViewController{
            vc.currentCity = weather.city
            vc.delegate = self
        }
    }
    
    func didChangeCity(city: String){
        
        //City name request
        AF.request("https://api.openweathermap.org/geo/1.0/direct?q=\(city)&appid=96947fc4fb3be40cf8110ba69548f522").responseJSON { response in
            if let cityData = response.value{
                let cityJSON = JSON(cityData)
                //City name, Lon, Lat
                self.weather.city = cityJSON[0]["name"].stringValue
                self.cityLabel.text = self.weather.city
                let lon = cityJSON[0]["lon"]
                let lat = cityJSON[0]["lat"]
                
                //Weather request
                AF.request("https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=96947fc4fb3be40cf8110ba69548f522").responseJSON { response in
                    if let data = response.value{
                        let weatherJSON = JSON(data)
                        print(weatherJSON)
                        //Data
                        self.weather.temp = String(round(weatherJSON["main"]["temp"].doubleValue - 273.15))
                        self.weather.icon = weatherJSON["weather",0,"icon"].stringValue
                        //UI
                        self.tempLabel.text = "\(self.weather.temp)°"
                        self.iconImageView.image = UIImage(named: self.weather.icon)
                    }
                }
                
            }
        }
    }

}

