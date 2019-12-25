//
//  BookTableViewController.swift
//  BookKeeper2
//
//  Created by Fred on 25/12/2019.
//  Copyright © 2019 Fred. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController {
    
    //Mark: Properties
    
    var books = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the sample data
        loadSampleBooks()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BookTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BookTableViewCell else {
            fatalError("The dequeued cell is not an instance of BookTableViewCell")
        }
        // Fetches the appropriate book for the data source layout
        let book = books[indexPath.row]
        
        cell.bookNameLabel.text = book.bookName
        cell.photoImageView.image = book.photo
        cell.ratingControl.rating = book.rating

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
    
    //MARK: Private Methods
    
    private func loadSampleBooks(){
        let photo1 = UIImage(named: "book1")
        let photo2 = UIImage(named: "book2")
        let photo3 = UIImage(named: "book3")
        
        guard let book1 = Book(bookName: "For Whom the Bell Tolls", photo: photo1, rating: 5, amountOfPages: 480, genre: "War novel", author: "Ernest Hemingway") else {
            fatalError("Unable to instantiate book1")}
        guard let book2 = Book(bookName: "Gangreen 1", photo: photo2, rating: 3, amountOfPages: 211, genre: "Adventure novel", author: "Jef Geeraerts") else{
                fatalError("Unable to instantiate book2")
            }
        guard let book3 = Book(bookName: "The Outsider", photo: photo3, rating: 4, amountOfPages: 315, genre: "Existential Fiction", author: "Colin WIlson") else{
                fatalError("Unable to instantiate book3")
            }
            
        books+=[book1,book2,book3]
    }

}
