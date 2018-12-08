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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
