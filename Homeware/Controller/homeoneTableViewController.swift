//
//  homeoneTableViewController.swift
//  Homeware
//
//  Created by Han-Pin on 2020/8/25.
//  Copyright © 2020 Han-Pin. All rights reserved.
//

import UIKit
import CoreData


class homeoneTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    
    var stocks: [StockMO] = []
    var fetchstock: NSFetchedResultsController<StockMO>!
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeSend" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let vc1 = segue.destination as! vcViewController
                vc1.stock = stocks[indexPath.row]
                
                
            }
        }
    }
    //    關閉介面
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        取消分隔線
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
//        讀取資料
        let fetchRequest: NSFetchRequest<StockMO> = StockMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchstock = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchstock.delegate = self
            
            do {
                try fetchstock.performFetch()
                if let fetchedObjects = fetchstock.fetchedObjects {
                    stocks = fetchedObjects
                }
            } catch {
                print(error)
            }
            
            
        }
        
        
        
        
    }
    // MARK: - func
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            stocks = fetchedObjects as! [StockMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    // MARK: - override func

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stocks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! homeoneTableViewCell

        // 設定表格
        cell.namelabel.text = stocks[indexPath.row].name
        cell.quantitylabel.text = String(stocks[indexPath.row].quantity)
        if let stockimage = self.stocks[indexPath.row].image {
            cell.homeimage.image = UIImage(data: stockimage as Data)
        }
        
        cell.starImageView.isHidden = self.stocks[indexPath.row].star ? false : true
        

        return cell
    }
    
//    向左滑動
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        刪除列
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, competionHandler) in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let stockToDelete = self.fetchstock.object(at: indexPath)
                context.delete(stockToDelete)
                
                appDelegate.saveContext()
                
                
            }
            
            
            competionHandler(true)
        }
        
//        標記
        let starAction = UIContextualAction(style: .normal, title: "標記") { (action, sourceView, competionHandler) in
            let cell = tableView.cellForRow(at: indexPath) as! homeoneTableViewCell
            self.stocks[indexPath.row].star = self.stocks[indexPath.row].star ? false : true
            cell.starImageView.isHidden = self.stocks[indexPath.row].star ? false : true
            
            competionHandler(true)
            
            
        }
        
        deleteAction.backgroundColor = UIColor(red: 231, green: 76, blue: 60)
        deleteAction.image = UIImage(systemName: "trash")
        starAction.backgroundColor = UIColor(red: 1, green: 1, blue: 200)
        starAction.image = UIImage(systemName: "star")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, starAction])
        
        return swipeConfiguration
        
        
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
