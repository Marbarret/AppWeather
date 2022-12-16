//
//  ViewController.swift
//  AppClima
//
//  Created by Marcylene Barreto on 14/12/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var cityInformations: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var mxmTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var searchCity: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
        
        weatherManager.delegate = self
        searchCity.delegate = self
    }
    
    @IBAction func locationPress(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            weatherManager.fetchWeather(lat, long)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension ViewController: UITextFieldDelegate {
    @IBAction func locationSearch(_ sender: UIButton) {
        searchCity.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchCity.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = textField.text {
            weatherManager.fetchCity(cityName)
        }
        searchCity.text = ""
    }
}

// MARK: - WeatherManagerDelegate
extension ViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel) {
        DispatchQueue.main.async {
            self.tempLabel.text = weather.tempString
            self.imgView.image = UIImage(named: weather.conditionName)
            self.cityName.text = weather.name
            self.mxmTemp.text = "\(weather.maxTempString)°C"
            self.minTemp.text = "\(weather.mintempString)°C"
            self.speedLabel.text = "\(weather.speedString)m/s"
            self.humidityLabel.text = "\(weather.humidity)%"
            
            self.cityInformations.text = "Today \(Date().dateFormatter(style: .medium)!)"
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
