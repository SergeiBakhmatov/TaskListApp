//
//  TaskListViewController.swift
//  TaskListApp
//
//  Created by Alexey Efimov on 17.05.2023.
//

import UIKit

enum TypeAlert {
    case newTask
    case updateTask
}

final class TaskListViewController: UITableViewController {
    
    private let storageManager = StorageManager.shared
    
    private let cellID = "cell"
    private var taskList: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .white
        setupNavigationBar()
        taskList = storageManager.fetchData()
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - UITableViewDelegate
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let task = taskList[indexPath.row]
            showAlert(withTitle: "Edit Task", andMessage: "How do you want to change the task?", .updateTask, task)
        }

    @objc private func addNewTask() {
        showAlert(withTitle: "New Task", andMessage: "What do you want to do?", .newTask)
    }
    
    @objc private func deleteTasks() {
        storageManager.delete()
        taskList.removeAll()
        tableView.reloadData()
    }
    
    private func showAlert(withTitle title: String, andMessage message: String,_ type: TypeAlert,_ task: Task = Task()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var action = UIAlertAction()
        switch type {
        case .newTask:
            action = UIAlertAction(title: "Save Task", style: .default) { [unowned self] _ in
                guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
                save(task)
            }
            
        case .updateTask:
            action = UIAlertAction(title: "Update Task", style: .default) { [unowned self] _ in
                guard let taskName = alert.textFields?.first?.text, !taskName.isEmpty else { return }
                update(taskName, task)
                tableView.reloadData()
            }
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(action)
        alert.addAction(cancelAction)
        alert.addTextField { textText in
            textText.placeholder = "New Task"
        }
        present(alert, animated: true)
    }
    
    private func save(_ taskName: String) {
        taskList.append(storageManager.save(task: taskName))
        
        let indexPath = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    private func update(_ taskName: String,_ task: Task){
        storageManager.update(name: taskName, task)
    }
}

// MARK: - SetupUI
private extension TaskListViewController {
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(named: "MilkBlue")
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        // Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(deleteTasks)
        )

        navigationController?.navigationBar.tintColor = .white
    }
}
