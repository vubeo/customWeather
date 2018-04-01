//
//  ViewController.swift
//  customWeather
//
//  Created by Đỗ Hoàng Vũ on 3/29/18.
//  Copyright © 2018 Đỗ Hoàng Vũ. All rights reserved.
//

import UIKit
import ImageIO
class ViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate {
    
    @IBOutlet weak var backgournd: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameCity: UILabel!
    @IBOutlet weak var temp_Current_C: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        DataService.shared.updateWeather()
        notificationRegiter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    func notificationRegiter() {
        NotificationCenter.default.addObserver(self, selector: #selector(data), name: Notification.Name(rawValue: "dataUpdate"), object: nil)
    }
    @objc func data() {
        DispatchQueue.main.async {
            self.nameCity.text = DataService.shared.weather?.location.name
            self.temp_Current_C.text = "\(DataService.shared.weather!.current.temp_c) "
            self.tableView.reloadData()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let array = DataService.shared.weather?.forecast.forecastdays.count else {return 0}
        return array
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ForecastTableViewCell
        
        cell.numberDay.text = DataService.shared.weather!.forecast.forecastdays[indexPath.row].date
        cell.temp_C.text = "\(DataService.shared.weather!.forecast.forecastdays[indexPath.row].day.avgtemp_c)°C"
        cell.status.text = DataService.shared.weather!.forecast.forecastdays[indexPath.row].day.condition.text
        cell.imageIcon.image = DataService.shared.weather?.forecast.forecastdays[indexPath.row].day.condition.image!
        return cell
    }
}
