//
//  ViewController.swift
//  PManagement
//
//  Created by Prateek Kansara on 17/03/17.
//  Copyright © 2017 prateek. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet var projectTable : UITableView!
    @IBOutlet var searchBar : UISearchBar!
    
    var searchBarActive : Bool = false
    let realm = try! Realm()
    
    
    /// Project List ream results
    var projectList : Results<Projects>?{
        if searchBarActive{
            let predicate = NSPredicate(format : "name BEGINSWITH[c] %@ OR name CONTAINS[c] %@", searchBar.text!, searchBar.text!)
            return realm.objects(Projects.self).filter(predicate)
        }
        return realm.objects(Projects.self)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUI()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        projectTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Stting up UI when loading view
    func setupUI(){
        view.layer.insertSublayer(UtilityMethods().appBackground(), at: 0)
        projectTable.tableFooterView = UIView.init(frame: .zero)
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
        navigationController?.topViewController?.title = "Projects"
        
//        navigationItem.rightBarButtonItem?.target = self
//        navigationItem.rightBarButtonItem?.action = #selector(self.addButtonPressed)
        
    }
    
    /// Navigation method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == PMSegues().projectDetailSegue{
            var selectedProject : Projects? = nil
            if let cell = sender as? ProjectTableViewCell, let indexPath = projectTable.indexPath(for: cell){
                selectedProject = projectList?[indexPath.row]
                let detailObject = segue.destination as! TaskViewController
                detailObject.projectObject = selectedProject
            }
        }
        
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = nil
        if projectList?.count == 0 {
            
            return 0
        }
        return projectList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let projectCell = tableView.dequeueReusableCell(withIdentifier: storyBoardID().projectCell, for: indexPath) as! ProjectTableViewCell
        
        let projectObject = projectList?[indexPath.row]
        
        projectCell.projectTitleLabel.text = projectObject?.name
        
        return projectCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}

// MARK: - Search Bar Extension methods
extension ViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            searchBarActive = true
        }
        else{
            searchBarActive = false
        }
        projectTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarActive = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        projectTable.reloadData()
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

