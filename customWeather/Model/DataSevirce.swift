//
//  DataSevirce.swift
//  customWeather
//
//  Created by Đỗ Hoàng Vũ on 3/29/18.
//  Copyright © 2018 Đỗ Hoàng Vũ. All rights reserved.
//

import Foundation
extension Notification.Name {
    static let dataUpdate = Notification.Name(rawValue: "dataUpdate")
}
class DataService {
    static let shared : DataService = DataService()
    private var _weather: Weather?
    
    var weather: Weather? {
        set {
            _weather = newValue
        }
        get {
            if _weather == nil {
                updateWeather()
            }
            return _weather
        }
    }
    
    func updateWeather() {
        let url = URL(string: "https://api.apixu.com/v1/forecast.json?key=9635350a9436406fb1974932182303&q=Hanoi&lang=vi&days=7")
        let _ = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) else {return}
            guard let json = jsonObject as? JSON else {return}
            let c = Weather(dict: json)
            print(c?.location.name)
            print(c?.current.temp_c)
            self._weather = c
            NotificationCenter.default.post(name: Notification.Name(rawValue: "dataUpdate"), object: nil)
            }.resume()
    }
}
