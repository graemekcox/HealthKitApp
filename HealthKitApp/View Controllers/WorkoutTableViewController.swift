//
//  WorkoutTableViewController.swift
//  HealthKitApp
//
//  Created by Graeme Cox on 2019-05-08.
//  Copyright © 2019 Graeme Cox. All rights reserved.
//

import UIKit
import HealthKit

class WorkoutTableViewController: UITableViewController {

    var workouts = [HKWorkout]()
    var healthStore: HKHealthStore!
    let dateFormatter = DateFormatter()
    var segueIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy - HH:mm"
        
//        self.tableView = UITableView(frame: self.tableView.frame, style: .plain)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "workoutCell")
        
        getWorkouts()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getWorkouts() {
        
        self.healthStore = HKHealthStore()
        print("Get workouts")
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        
        let componentFlags: Set<Calendar.Component> = [.day, .month, .year, .era]
        var components = Calendar.current.dateComponents(componentFlags, from: Date())
        components.calendar = Calendar.current
        let predicateDate = HKQuery.predicateForActivitySummary(with: components)
        let combinePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicateDate])
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        
        let query = HKSampleQuery(
            sampleType: .workoutType(),
            predicate: predicate,
            limit: 0,
            sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                DispatchQueue.main.async {
                    guard
                        let samples = samples as? [HKWorkout],
                        error == nil
                        else {
                            //                            completion(nil, error)
                            return
                    }
                    
                    for sample in samples {
//                        print(sample)
                        self.workouts.append(sample)
                        self.tableView.reloadData()
                    }
//                    workouts.append(samples)
                    //                    completion(samples, nil)
                }
        }
        self.healthStore.execute(query)
    }
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.workouts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "workoutCell"

        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifier)
        }

        // Configure the cell...
        let workout: HKWorkout = self.workouts[indexPath.row]
        // workout.workoutActivityType
//        let kmUnit = HKQuantity(unit: HKUnit.meter()
//                                doubleValue: workout.totalDistance?.doubleValue(for: HKUnit.meter()))
        
        // distance = workout.totalDistance!.doubleValue(for: HKUnit.meter())
        // duration = workout.duration
        // calories = workout.totalEnergyBurned?.doubleValue(for: HKUnit.largeCalorie()) ?? 0
        

//        DateFormatter.
        let temp = dateFormatter.string(from: workout.startDate)
        cell.textLabel?.text = String(temp)
        
        let calories = workout.totalEnergyBurned?.doubleValue(for: HKUnit.largeCalorie()) ?? 0
        cell.detailTextLabel?.text = String(format: "Total Calories burned: %.2f", calories)

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let ind = self.postData.count - 1 - indexPath.row // reverse array
//
//        let tempID = postData[ind].replacingOccurrences(of: " / ", with: "%D")
//
//        workoutID = self.date_stuff.getDatabaseDate(date: tempID)
        self.segueIndex = indexPath.row
        self.performSegue(withIdentifier: "to_workout", sender: self)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.destination is WorkoutViewController{
            let vc = segue.destination as? WorkoutViewController
            vc?.workout = workouts[self.segueIndex]
        }
    }
 

}
