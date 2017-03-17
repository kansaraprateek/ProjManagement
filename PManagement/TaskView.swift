//
//  TaskView.swift
//  PManagement
//
//  Created by Prateek Kansara on 17/03/17.
//  Copyright © 2017 prateek. All rights reserved.
//



import Foundation
import UIKit

import UIKit
import RealmSwift

class TaskViewController: UIViewController {
    
    var projectObject : Projects!
    
    @IBOutlet var taskTable : UITableView!
    @IBOutlet var searchBar : UISearchBar!
    
    var searchBarActive : Bool = false
    let realm = try! Realm()
    
    
    /// Task List ream results
    var taskList : Results<Tasks>?{
        if searchBarActive{
            let predicate = NSPredicate(format : "(title BEGINSWITH[c] %@ OR title CONTAINS[c] %@) AND projectName = %@", searchBar.text!, searchBar.text!, projectObject.name!)
            return realm.objects(Tasks.self).filter(predicate)
        }
        let predicate = NSPredicate(format : "projectName = %@", projectObject.name!)
        return realm.objects(Tasks.self).filter(predicate)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUI()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Stting up UI when loading view
    func setupUI(){
        
        let lPgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        taskTable.addGestureRecognizer(lPgr)
        
        view.layer.insertSublayer(UtilityMethods().appBackground(), at: 0)
        taskTable.tableFooterView = UIView.init(frame: .zero)
        taskTable.estimatedRowHeight = 66
        taskTable.rowHeight = UITableViewAutomaticDimension
        
    }
    
    /// Stting up navigation Items for current view
    func setupNavigation() {
        navigationController?.setNavBackgrounColor(PMColors().navigationColor)
        navigationController?.navigationBar.tintColor = UIColor.white
        let titleAttributes : NSDictionary = [
            NSFontAttributeName : constants().navigationTitleFont!,
            NSForegroundColorAttributeName : UIColor.white
        ]
        navigationController!.navigationBar.titleTextAttributes = titleAttributes as? [String : AnyObject]
        navigationController?.topViewController?.title = "Tasks"
        
        //        navigationItem.rightBarButtonItem?.target = self
        //        navigationItem.rightBarButtonItem?.action = #selector(self.addButtonPressed)
        
    }

    func handleLongPress(_ getsureRecognizer : UILongPressGestureRecognizer) {
        
        let touchPoint : CGPoint = getsureRecognizer.location(in: taskTable)
        
        
        if let indexPath = taskTable.indexPathForRow(at: touchPoint){
            if getsureRecognizer.state == .began {
                
                let documentSheet : PMActionSheet = PMActionSheet()
                let cell = taskTable.cellForRow(at: indexPath)
                documentSheet.showActionSheet("Choose option to perform on Task", data: ["Delete Task", "Edit Task"], fromRect: cell?.frame, inView: view, selection: {
                    (selectedValue : String, selectedIndex : Int) in
                    
                    var taskObject : Tasks = Tasks()
                    taskObject = self.taskList![indexPath.row]
                   
                    
                    if selectedIndex == 0 {
                        try! self.realm.write({
                            self.realm.delete(taskObject)
                        })
                        self.taskTable.reloadData()
                    }
                    else if selectedIndex == 1 {
                        self.editTasks(taskObject)
                    }
                    
                }, dismiss: {
                    (buttonIndex : Int) in
                    
                })
            }
        }
    }
    
    func editTasks(_ taskObject : Tasks) {
        
        let editTask = self.storyboard?.instantiateViewController(withIdentifier: storyBoardID().addEditTasks) as! AddEditTask
        editTask.GlobalTaskObject = taskObject
        navigationController?.pushViewController(editTask, animated: true)
    }

    
    /// Navigation method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == PMSegues().taskDetailSegue{
            var selectedTasks : Tasks? = nil
            if let cell = sender as? TaskTableViewCell, let indexPath = taskTable.indexPath(for: cell){
                selectedTasks = taskList?[indexPath.row]
                let detailObject = segue.destination as! TaskDetailView
               detailObject.taskObject = selectedTasks
            }
        }else{
            let detailObject = segue.destination as! AddEditTask
            detailObject.projectName = projectObject.name
        }
    }
}

extension TaskViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = nil
        if taskList?.count == 0 {
            
            return 0
        }
        return taskList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let taskCell = tableView.dequeueReusableCell(withIdentifier: storyBoardID().taskCell, for: indexPath) as! TaskTableViewCell
        
        let taskObject = taskList?[indexPath.row]
        
        taskCell.taskLabel.attributedText = cellData().getTaskCellData(taskObject: taskObject!)
        
        return taskCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

// MARK: - Search Bar Extension methods
extension TaskViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            searchBarActive = true
        }
        else{
            searchBarActive = false
        }
        taskTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarActive = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        taskTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarActive = true
        view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

