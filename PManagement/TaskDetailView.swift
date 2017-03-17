//
//  TaskDetailView.swift
//  PManagement
//
//  Created by Prateek Kansara on 17/03/17.
//  Copyright © 2017 prateek. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class TaskDetailView: UIViewController {
    
    @IBOutlet var taskData : UITextView!
    @IBOutlet var commentTable : UITableView!
    let realm = try! Realm()
    
    public var taskObject : Tasks!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        setTaskData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        commentTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /// Stting up UI when loading view
    func setupUI(){
        
        let lPgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        commentTable.addGestureRecognizer(lPgr)
        
        view.layer.insertSublayer(UtilityMethods().appBackground(), at: 0)
        commentTable.tableFooterView = UIView.init(frame: .zero)
        commentTable.estimatedRowHeight = 44
        commentTable.rowHeight = UITableViewAutomaticDimension
        
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
        navigationController?.topViewController?.title = taskObject.title
        
        //        navigationItem.rightBarButtonItem?.target = self
        //        navigationItem.rightBarButtonItem?.action = #selector(self.addButtonPressed)
        
    }
    
    func setTaskData()  {
        
        let titleString : NSMutableAttributedString = NSMutableAttributedString.init(string: String(format: "Title: %@", taskObject.title!), attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName:UIFont.init(name: PMFonts().AvenirNextMedium, size: 18.0)!])
        
        let paragraphStyle = NSMutableParagraphStyle()
        let statusString = NSAttributedString.init(string: String(format: "\nStatus: %@", taskObject.status!), attributes: [NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName:UIFont.init(name: PMFonts().AvenirNextMedium, size: 14.0)!])
        
        titleString.append(statusString)
        
        
        if let taskDescription = taskObject.taskDescription{
            
            let statusString = NSAttributedString.init(string: String(format: "\nDescription: %@", taskDescription), attributes: [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName:UIFont.init(name: PMFonts().AvenirNextMedium, size: 14.0)!])
            
            titleString.append(statusString)
            
        }
        
        taskData.attributedText = titleString
    }
    
    func handleLongPress(_ getsureRecognizer : UILongPressGestureRecognizer) {
        
        let touchPoint : CGPoint = getsureRecognizer.location(in: commentTable)
        
        
        if let indexPath = commentTable.indexPathForRow(at: touchPoint){
            if getsureRecognizer.state == .began {
                
                let documentSheet : PMActionSheet = PMActionSheet()
                let cell = commentTable.cellForRow(at: indexPath)
                documentSheet.showActionSheet("Choose option to perform on Comment", data: ["Delete Comment", "Edit Comment"], fromRect: cell?.frame, inView: view, selection: {
                    (selectedValue : String, selectedIndex : Int) in
                    
                    var commentObject : Comments = Comments()
                    commentObject = self.taskObject.comments[indexPath.row]
                    
                    
                    if selectedIndex == 0 {
                        try! self.realm.write({
                            self.realm.delete(commentObject)
                        })
                        self.commentTable.reloadData()
                    }
                    else if selectedIndex == 1 {
                        self.editComment(commentObject)
                    }
                    
                }, dismiss: {
                    (buttonIndex : Int) in
                    
                })
            }
        }
    }
    
    func editComment(_ commentObject : Comments) {
        
        let editComment = self.storyboard?.instantiateViewController(withIdentifier: storyBoardID().addEditComment) as! AddEditComment
        editComment.GlobalCommentObject = commentObject
        editComment.taskObject = taskObject
        navigationController?.pushViewController(editComment, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AddEditComment
        destination.taskObject = taskObject
    }
    
}

extension TaskDetailView : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskObject.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: storyBoardID().commentCell, for: indexPath)
        let commentObject = taskObject.comments[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.attributedText = cellData().getCommentCellData(commentObject: commentObject)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Comments"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
