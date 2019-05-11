//
//  WorkoutViewController.swift
//  HealthKitApp
//
//  Created by Graeme Cox on 2019-05-11.
//  Copyright © 2019 Graeme Cox. All rights reserved.
//

import UIKit
import HealthKit

class WorkoutViewController: UIViewController {

    var workout:HKWorkout!
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var date_string: UILabel!
    
    @IBOutlet weak var calorie_string: UILabel!
    @IBOutlet weak var distance_string: UILabel!
    @IBOutlet weak var duration_string: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MMM dd, yyyy - HH:mm"
        
//        self.date_string.text = dateFormatter.string(from: workout.startDate)

        // Do any additional setup after loading the view.
        
//        let workout: HKWorkout = self.workouts[indexPath.row]
        // workout.workoutActivityType
        //        let kmUnit = HKQuantity(unit: HKUnit.meter()
        //                                doubleValue: workout.totalDistance?.doubleValue(for: HKUnit.meter()))
        let date = dateFormatter.string(from: workout.startDate)
//        self.date_string.text = String(format: "Date - %s", date)
        self.date_string.text = "Date: " + date
        
        let calorie = workout.totalEnergyBurned?.doubleValue(for: HKUnit.largeCalorie()) ?? 0
        self.calorie_string.text = String(format: "Total Calories Burned: %.2f", calorie)
        
        let distance = workout.totalDistance?.doubleValue(for: HKUnit.meter()) ?? 0
        self.distance_string.text = String(format: "Total Distance(m): %.2f", distance)
        
        let duration = String(format: "Total Time(s): %.2f", workout.duration)
        self.duration_string.text = duration
//        self.calorie_string.text = workout.
        // distance = workout.totalDistance!.doubleValue(for: HKUnit.meter())
        // duration = workout.duration
        // calories = workout.totalEnergyBurned?.doubleValue(for: HKUnit.largeCalorie()) ?? 0
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
