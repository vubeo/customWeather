//
//  Model.swift
//  customWeather
//
//  Created by Đỗ Hoàng Vũ on 3/29/18.
//  Copyright © 2018 Đỗ Hoàng Vũ. All rights reserved.
//

import Foundation
import UIKit
typealias JSON = Dictionary<AnyHashable, Any>
class Location {
    var name : String
    init?(dict : JSON) {
        guard let name = dict["name"] as? String else {return nil}
        self.name = name
    }
}

class Current {
    var temp_c : Double
    init?(dict : JSON) {
        guard let temp_c = dict["temp_c"] as? Double else {return nil}
        self.temp_c = temp_c
    }
}

class Condition {
    var text : String
    var icon : String
    var image : UIImage?
    init?(dict : JSON) {
        guard let text = dict["text"] as? String else {return nil}
        guard let icon = dict["icon"] as? String else {return nil}
        self.text = text
        print(icon)
        self.icon = "http:\(icon)"
        fetchImage()
     
    }
    func fetchImage() {
        guard let url = URL(string: icon) else {return}
        var imageData: Data?
        do {
            var data = try? Data(contentsOf: url)
            imageData = data
        } catch {
            print(error)
        }
        
        self.image = UIImage(data: (imageData)!)
//        NotificationCenter.default.post(name: .dataUpdate, object: nil)
    }

}

class Day {
    var avgtemp_c : Double
    var condition : Condition
    init?(dict : JSON){
        guard let avgtemp_c = dict["avgtemp_c"] as? Double else {return nil}
        guard let conditionObject = dict["condition"] as? JSON else {return nil}
        guard let condition = Condition(dict : conditionObject) else {return nil}
        self.avgtemp_c = avgtemp_c
        self.condition = condition
    }
}

class Forecastday {
    var date : String
    var day : Day
    
    init?(dict : JSON) {
        guard let date = dict["date"] as? String else {return nil}
        guard let dayObject = dict["day"] as? JSON else {return nil}
        guard let day = Day(dict: dayObject) else {return nil}
        self.date = date
        self.day = day
        
    }
}
class Forecast {
    var forecastdays : [Forecastday] = []
    init?(dict : JSON) {
        guard let forecastday = dict["forecastday"] as? [JSON] else {return nil}
        for i in forecastday {
            if let h = Forecastday(dict: i) {
                forecastdays.append(h)
            }
        }
    }
}

class Weather {
    var location : Location
    var current : Current
    var forecast : Forecast
    init?(dict : JSON) {
        guard let locationObject = dict["location"] as? JSON else {return nil}
        guard let location = Location(dict:locationObject) else {return nil}
        guard let currentObject = dict["current"] as? JSON else {return nil}
        guard let current = Current(dict:currentObject) else {return nil}
        guard let forecastObject = dict["forecast"] as? JSON else {return nil}
        guard let forecast = Forecast(dict:forecastObject) else {return nil}
        
        self.location = location
        self.current = current
        self.forecast = forecast
    }
}
