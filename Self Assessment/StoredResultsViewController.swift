//
//  StoredResultsViewController.swift
//  Self Assessment
//
//  Created by John Ellison on 4/16/18.
//  Copyright © 2018 John Ellison. All rights reserved.
//

import UIKit
import CoreData


class StoredResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    struct GlobalVar{
        static var retrieveThreshR = [Double]()
        static var retrieveThreshL = [Double]()
        static var retrieveAvgR = [Double]()
        static var retrieveAvgL = [Double]()
    }

    var previousTests = [CurrentTest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<CurrentTest> = CurrentTest.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "displayOrder", ascending: true )
        
        do {
            fetchRequest.sortDescriptors = [sortDescriptor]
            let previousTests = try PersistenceService.context.fetch(fetchRequest)
            self.previousTests = previousTests
            self.tableView.reloadData()
        } catch {}
        
        if NewResultsViewController.GlobalVar.threshR.isEmpty {
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
            let dateString = dateFormatter.string(from: Date())
            let currentTest = CurrentTest(context: PersistenceService.context)
            currentTest.date = dateString
            currentTest.thresholdR_1k = NewResultsViewController.GlobalVar.threshR[0]
            currentTest.thresholdL_1k = NewResultsViewController.GlobalVar.threshL[0]
            currentTest.thresholdR_2k = NewResultsViewController.GlobalVar.threshR[1]
            currentTest.thresholdL_2k = NewResultsViewController.GlobalVar.threshL[1]
            currentTest.thresholdR_3k = NewResultsViewController.GlobalVar.threshR[2]
            currentTest.thresholdL_3k = NewResultsViewController.GlobalVar.threshL[2]
            currentTest.thresholdR_4k = NewResultsViewController.GlobalVar.threshR[3]
            currentTest.thresholdL_4k = NewResultsViewController.GlobalVar.threshL[3]
            currentTest.avgR = NewResultsViewController.GlobalVar.avgR[0]
            currentTest.avgL = NewResultsViewController.GlobalVar.avgL[0]
            PersistenceService.saveContext()
            previousTests.append(currentTest)
            tableView.reloadData()
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //extension StoredResultsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousTests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
        cell.textLabel?.text = previousTests[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = previousTests[indexPath.row]
        let destinationVC = SavedResultsViewController()
        destinationVC.selectedTest = selected
        GlobalVar.retrieveThreshR.append((destinationVC.selectedTest?.thresholdR_1k)!)
        GlobalVar.retrieveThreshR.append((destinationVC.selectedTest?.thresholdR_2k)!)
        GlobalVar.retrieveThreshR.append((destinationVC.selectedTest?.thresholdR_3k)!)
        GlobalVar.retrieveThreshR.append((destinationVC.selectedTest?.thresholdR_4k)!)
        GlobalVar.retrieveThreshL.append((destinationVC.selectedTest?.thresholdL_1k)!)
        GlobalVar.retrieveThreshL.append((destinationVC.selectedTest?.thresholdL_2k)!)
        GlobalVar.retrieveThreshL.append((destinationVC.selectedTest?.thresholdL_3k)!)
        GlobalVar.retrieveThreshL.append((destinationVC.selectedTest?.thresholdL_4k)!)
        GlobalVar.retrieveAvgR.append((destinationVC.selectedTest?.avgR)!)
        GlobalVar.retrieveAvgL.append((destinationVC.selectedTest?.avgL)!)
        self.performSegue(withIdentifier: "unwindSeguePlotSavedResults", sender: self)
        print("The right threshold is: \(GlobalVar.retrieveThreshR)")
        print("The left threshold is: \(GlobalVar.retrieveThreshL)")
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObjTemp = previousTests[sourceIndexPath.row]
        previousTests.remove(at: sourceIndexPath.row)
        previousTests.insert(movedObjTemp, at: destinationIndexPath.row)
        for i in 0..<previousTests.count {
            let idx = previousTests[i]
            idx.setValue(i, forKey: "displayOrder")
        }
        PersistenceService.saveContext()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            PersistenceService.context.delete(previousTests[indexPath.row])
            PersistenceService.saveContext()
            previousTests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = (self.tableView.isEditing) ? "Exit" : "Edit"
        if self.tableView.isEditing {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }

    }
    @IBAction func unwindSegueBackToStoredResults(_ sender: UIStoryboardSegue) {
        
    }
}
