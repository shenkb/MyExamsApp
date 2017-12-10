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
    }

    @IBAction func editBarButtonPresse(_ sender: UIBarButtonItem) {
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
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            exams.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
