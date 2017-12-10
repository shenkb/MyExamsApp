//
//  ViewController.swift
//  MyExams
//
//  Created by Kaining on 12/9/17.
//  Copyright © 2017 Kaining. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var exams = [Exam]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        exams.append(Exam(course: "Swift & iOS Programming", date: "May 15", time: "4pm", location: "Fulton 220", notes: ""))
        exams.append(Exam(course: "TechTrek West", date: "May 18", time: "4pm", location: "Fulton 110", notes: ""))
        exams.append(Exam(course: "Computers in Management", date: "May 16", time: "9am", location: "Fulton 250", notes: ""))
        loadFromUserDefaults()
    }
    
    func loadFromUserDefaults() {
        let defaults = UserDefaults.standard
        
        let courses = defaults.stringArray(forKey: "courses")
        let dates = defaults.stringArray(forKey: "dates")
        let times = defaults.stringArray(forKey: "times")
        let locations = defaults.stringArray(forKey: "locations")
        let notes = defaults.stringArray(forKey: "notes")
        
        if let courses = courses, let dates = dates, let times = times, let locations = locations, let notes = notes {
            exams = []
            for index in 0..<courses.count {
                exams.append(Exam(course: courses[index], date: dates[index], time: times[index], location: locations[index], notes: notes[index]))
            }
        }
    }
    
    func saveToUserDefaults() {
        var courses = [String]()
        var dates = [String]()
        var times = [String]()
        var locations = [String]()
        var notes = [String]()
        
        for exam in exams {
            courses.append(exam.course)
            dates.append(exam.date)
            times.append(exam.time)
            locations.append(exam.location)
            notes.append(exam.notes)
        }
        
        let defaults = UserDefaults.standard
        defaults.set(courses, forKey: "courses")
        defaults.set(dates, forKey: "dates")
        defaults.set(times, forKey: "times")
        defaults.set(locations, forKey: "locations")
        defaults.set(notes, forKey: "notes")
    }


    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing == true {
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }

    @IBAction func unwindFromDetail(sender: UIStoryboardSegue) {
        if let source = sender.source as? DetailViewController, let newExam = source.exam {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //Editing a selected row
                let index = selectedIndexPath.row
                exams[index] = newExam
                tableView.reloadData()
            } else {
                //Adding a new item
                exams.append(newExam)
                let newIndexPath = IndexPath(item: exams.count-1, section: 0)
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        } else {
            print("Error")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToEdit" {
            let destination = segue.destination as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            destination.exam = exams[indexPath.row]
        } else {
            if let selectedRow = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedRow, animated: true)
            }
        }
    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = exams[indexPath.row].course
        cell.detailTextLabel?.text = exams[indexPath.row].date
        return cell
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = exams[sourceIndexPath.row]
        exams.remove(at: sourceIndexPath.row)
        exams.insert(itemToMove, at: destinationIndexPath.row)
        saveToUserDefaults()
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            exams.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveToUserDefaults()
        }
    }
}
