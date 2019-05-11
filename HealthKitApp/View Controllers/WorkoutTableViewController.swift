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
        print(workout.startDate.description)
        cell.textLabel?.text = String(temp)
        
        let calories = workout.totalEnergyBurned?.doubleValue(for: HKUnit.largeCalorie()) ?? 0
        cell.detailTextLabel?.text = String(format: "Total Calories burned: %.2f", calories)
        
        
//        print(String(workout.duration))
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
