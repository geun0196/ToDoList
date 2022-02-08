//
//  ViewController.swift
//  ToDoList
//
//  Created by usg on 2022/02/07.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    private let table : UITableView = {
        
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
        
    }()
    
    var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tasks = UserDefaults.standard.stringArray(forKey: "tasks") ?? []
        title = "To do List"
        view.addSubview(table)
        table.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapApp))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    // Add 버튼 클릭 이벤트 함수
    @objc private func didTapApp() {
        //Alert컨트롤러 객체 생성
        let alert = UIAlertController(title: "New task", message: "Enter new to do list", preferredStyle: .alert)

        alert.addTextField{ field in
            field.placeholder = "Enter list..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self](_) in
            if let field = alert.textFields?.first{
                // Textfield에 문자가 비어있지 않다면
                if let text = field.text, !text.isEmpty{
                    // 입력받은 text를 tasks배열에 추가
                    DispatchQueue.main.async {
                        self?.tasks.append(text)
                        self?.table.reloadData()
                        //입력받은 문자를 userdefaults를 이용하여 "tasks" key에 저장
                        var currentTasks = UserDefaults.standard.stringArray(forKey: "tasks") ?? []
                        currentTasks.append(text)
                        UserDefaults.standard.setValue(currentTasks, forKey: "tasks")
                    }
                }
            }
        }))

        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // 정보 저장
            UserDefaults.standard.setValue(tasks, forKey: "tasks")
            
        }
        else if editingStyle == .insert {
        }
    }
    
    //섹션 내 셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // 셀 객체 - 셀 생성 후 반납
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }
}
