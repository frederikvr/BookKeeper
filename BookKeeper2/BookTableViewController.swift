//
//  BookTableViewController.swift
//  BookKeeper2
//
//  Created by Fred on 25/12/2019.
//  Copyright © 2019 Fred. All rights reserved.
//

import UIKit
import os.log

class BookTableViewController: UITableViewController {
    
    //Mark: Properties
    var books = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        // if loadBooks successfully returns an array, execute if statement (add loadedBooks to books)
        // else load sampledata
        if let savedBooks = loadBooks(){
            if (savedBooks.count != 0){
                books += savedBooks
            }
                // extra call needed because loadBooks can return an empty array
            else {
                loadSampleBooks()
            }
        }
        // called when there is no array returned at all (first time boot)
        else {
            // Load the sample data
            loadSampleBooks()
        }
        
       
    }

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
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            books.remove(at: indexPath.row)
            saveBooks()
            // delete the row from the tableView
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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


    // MARK: Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case "AddItem":
            os_log("Adding a new book.", log:OSLog.default, type:.debug)
        case "ShowDetail":
            guard let bookDetailViewController = segue.destination as? BookViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedBookCell = sender as? BookTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedBookCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedBook = books[indexPath.row]
            bookDetailViewController.book = selectedBook
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Actions
    @IBAction func unwindToBookList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? BookViewController, let book = sourceViewController.book{
            // this code checks whether a row in the table view is selected. if it is, that means a user tapped one of the table views cells to edit a book.
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                // Update an existing book.
                books[selectedIndexPath.row] = book
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new book.
                let newIndexPath = IndexPath(row: books.count, section:0)
                
                books.append(book)
                // .automatic adds the animation
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveBooks()
        }
    }
    
    //MARK: Private Methods
    private func loadSampleBooks(){
        let photo1 = UIImage(named: "book1")
        let photo2 = UIImage(named: "book2")
        let photo3 = UIImage(named: "book3")
        
        guard let book1 = Book(bookName: "For Whom the Bell Tolls", photo: photo1, rating: 5, pages: 480, genre: "War novel", author: "Ernest Hemingway") else {
            fatalError("Unable to instantiate book1")}
        guard let book2 = Book(bookName: "Gangreen 1", photo: photo2, rating: 3, pages: 211, genre: "Adventure novel", author: "Jef Geeraerts") else{
                fatalError("Unable to instantiate book2")
            }
        guard let book3 = Book(bookName: "The Outsider", photo: photo3, rating: 4, pages: 315, genre: "Existential Fiction", author: "Colin WIlson") else{
                fatalError("Unable to instantiate book3")
            }
            
        books+=[book1,book2,book3]
    }
    
    private func saveBooks(){
        // attempt to archive and return true if successful
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(books, toFile: Book.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Books successfully saved.", log:OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save books...", log:OSLog.default, type: .error)
        }
    }
    
    // might return an array of books, might return nil
    private func loadBooks() -> [Book]?{
        // if the downcast fails, return nil. mostly happens when there is no data in DB yet
        return NSKeyedUnarchiver.unarchiveObject(withFile: Book.ArchiveURL.path) as? [Book]
        
        
    }
}
