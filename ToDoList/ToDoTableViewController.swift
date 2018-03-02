//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Philip van der Hoek on 02/03/2018.
//  Copyright © 2018 Philip van der Hoek. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    var todos = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedToDos = ToDo.loadToDos() {
            todos = savedToDos
        } else {
            todos = ToDo.loadSampleToDos()
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // All model object are displayed in a cell and all cells are in the same section
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt
        // Setting up view controller
        indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier:
                "ToDoCellIdentifier") as? ToDoCell else {
                    fatalError("Could not dequeue a cell")
        }
        
        let titleLabel = cell.viewWithTag(10) as! UILabel
        let isCompleteButton = cell.viewWithTag(5) as! UIButton
        
        let todo = todos[indexPath.row]
        titleLabel.text = todo.title
        isCompleteButton.isSelected = todo.isComplete
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt
        indexPath: IndexPath) -> Bool {
        // All cells are editable
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit
        editingStyle: UITableViewCellEditingStyle, forRowAt indexPath:
        IndexPath) {
        // Verify that delete button is triggered
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(todos)
        }
    }
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        // Save changes
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ToDoViewController
        
        if let todo = sourceViewController.todo {
            if let selectedIndexPath =
                tableView.indexPathForSelectedRow {
                todos[selectedIndexPath.row] = todo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: todos.count, section: 0)
                todos.append(todo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        ToDo.saveToDos(todos)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Show details when clicked on cell
        if segue.identifier == "showDetails" {
            let todoViewController = segue.destination
                as! ToDoViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedTodo = todos[indexPath.row]
            todoViewController.todo = selectedTodo
        }
    }
    
}
