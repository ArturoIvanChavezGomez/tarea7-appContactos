//
//  ViewController.swift
//  ContactosCoreData
//
//  Created by Arturo Iván Chávez Gómez on 15/05/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var sendName: String?
    
    var sendPhone: Int64?
    
    var sendAddress: String?
    
    var sendEmail: String?
    
    var sendIndex: Int?
    
    var contacts = [Contact]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var contactsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCoreData()
        contactsTable.reloadData()
        
        contactsTable.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        contactsTable.delegate = self
        contactsTable.dataSource = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contactsTable.reloadData()
    }
    
    @IBAction func addContactButtonItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add", message: "New Contact", preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Add", style: .default) { (_) in
            
            guard let nameAlert = alert.textFields?.first?.text else {return}
            
            guard let phoneAlert = Int64(alert.textFields?[1].text ?? "00000000") else {return}
            
            guard let addressAlert = alert.textFields?[2].text else {return}
            
            guard let emailAlert = alert.textFields?.last?.text else {return}
            
            let temporalImage = UIImageView(image: #imageLiteral(resourceName: "user"))
            
            let newContact = Contact(context: self.context)
            newContact.name = nameAlert
            newContact.phone = phoneAlert
            newContact.address = addressAlert
            newContact.email = emailAlert
            newContact.image = temporalImage.image?.pngData()
            
            self.contacts.append(newContact)
            
            self.saveContact()
            
            self.contactsTable.reloadData()
        }
        
        alert.addTextField { (nameTF) in
            nameTF.placeholder = "Name"
            nameTF.textAlignment = .center
            nameTF.autocapitalizationType = .words
        }
        
        alert.addTextField { (phoneTF) in
            phoneTF.placeholder = "Phone"
            phoneTF.textAlignment = .center
            phoneTF.keyboardType = .numberPad
        }
        
        alert.addTextField { (addressTF) in
            addressTF.placeholder = "Address"
            addressTF.textAlignment = .center
        }
        
        alert.addTextField { (emailTF) in
            emailTF.placeholder = "Email"
            emailTF.textAlignment = .center
        }
        
        alert.addAction(acceptAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveContact() {
        do {
            try context.save()
        } catch let error as NSError {
            
        }
    }
    
    func loadCoreData() {
        let fetchRequest : NSFetchRequest<Contact> = Contact.fetchRequest()
        do {
            contacts = try context.fetch(fetchRequest)
        } catch {
            
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactTableViewCell
        cell.nameLabel.text = contacts[indexPath.row].name
        cell.phoneLabel.text = "📞  \(contacts[indexPath.row].phone ?? 00000000)"
        cell.emailLabel.text = "📪  \(contacts[indexPath.row].email ?? "Email")"
        cell.contactImageView.image = UIImage(data: contacts[indexPath.row].image!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contactsTable.deselectRow(at: indexPath, animated: true)
        sendName = contacts[indexPath.row].name
        sendPhone = contacts[indexPath.row].phone
        sendAddress = contacts[indexPath.row].address
        sendEmail = contacts[indexPath.row].email
        sendIndex = indexPath.row
        performSegue(withIdentifier: "editContact", sender: self)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            self.context.delete(self.contacts[indexPath.row])
            self.contacts.remove(at: indexPath.row)
            self.saveContact()
            self.contactsTable.reloadData()
        }
        
        actionDelete.image = UIImage(named: "delete.png")
        actionDelete.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [actionDelete])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionCall = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            
        }
        
        actionCall.image = UIImage(named: "call.png")
        actionCall.backgroundColor = .systemGreen
        
        let actionMessage = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            
        }
        
        actionMessage.image = UIImage(named: "message.png")
        actionMessage.backgroundColor = .yellow
        
        return UISwipeActionsConfiguration(actions: [actionCall, actionMessage])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact" {
            let objEdit = segue.destination as! EditViewController
            objEdit.getName = sendName
            objEdit.getAddress = sendAddress
            objEdit.getPhone = sendPhone
            objEdit.getEmail = sendEmail
            objEdit.getIndex = sendIndex
        }
    }
    
}


