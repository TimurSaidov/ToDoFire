//
//  TasksTableViewController.swift
//  ToDoFire
//
//  Created by Timur Saidov on 07/12/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit
import Firebase

class TasksTableViewController: UITableViewController {
    
    var user: MyUser!
    var ref: DatabaseReference!
    var tasks: [Task] = []

    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Task", message: "Add new task", preferredStyle: .alert)
        alertController.addTextField()
        
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
            
            let newTask = Task(title: textField.text!, userId: (self?.user.uid)!)
            print("newTask - \(newTask)")
            let newTaskRef = self?.ref.child(newTask.title.lowercased()) // Создание ссылки в ссылку ref при добавлении новой задачи newTask в список задач tasks. То есть в директорию базы данных Firebase  users/user(currentUser)/tasks добавляется новая директория newTask.
            print("newTaskRef - \(newTaskRef as Any)")
            newTaskRef?.setValue(["title": newTask.title, "userId": newTask.userId, "completed": newTask.completed]) // setValue() - Write data to this Firebase Database location. По ссылке newTaskRef записываются данные, то есть создается директория newTask, куда записываются ее параметры: title, userId, completed.
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = MyUser(user: currentUser)
        print("Current User - \(String(describing: user))")
        ref = Database.database().reference(withPath: "users").child(user.uid).child("tasks") // Ссылка на задачи конкретного пользователя user(currentUser) в базе данных Firebase.
        print("ref - \(String(describing: ref))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        ref.observe(DataEventType.value) { [weak self] (snapshot) in // Поскльку ref = Database.database().reference(withPath: "users").child(user.uid).child("tasks"), то snapshot - это целый список задач, массив задач.
            var _tasks: [Task] = []
            
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }
            
            self?.tasks = _tasks
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        ref.removeAllObservers() // Удаление наблюдателя для того, чтобы не было предупреждений.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(tasks.count)
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.textLabel?.textColor = .white
        
        toogleCompletion(cell, isCompleted: task.completed)
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
            tasks.remove(at: indexPath.row)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed
        
        toogleCompletion(cell, isCompleted: isCompleted)
        task.ref?.updateChildValues(["completed": isCompleted])
    }

    func toogleCompletion(_ cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
}
