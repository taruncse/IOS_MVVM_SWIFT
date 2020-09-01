//
//  NewOrderViewController.swift
//  IOS_MVVM_SWIFT
//
//  Created by Tarun on 29/8/20.
//  Copyright © 2020 Tarun. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import CodableFirebase
import ProgressHUD

class NewOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var vm = NewOrderViewModel()
    @IBOutlet weak var coffeeVariationTableView : UITableView!
    @IBOutlet weak var nameTextField : UITextField!
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var bottomStackView : UIStackView!
    
    private var coffeeSizeSegmentedControll : UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        self.coffeeSizeSegmentedControll = UISegmentedControl(items: self.vm.sizes)
        self.coffeeSizeSegmentedControll.translatesAutoresizingMaskIntoConstraints = false
        self.bottomStackView.insertArrangedSubview(self.coffeeSizeSegmentedControll, at: 0)
        
        // Following lines are to add constraint respect to a certain view
        //self.coffeeSizeSegmentedControll.topAnchor.constraint(equalTo: self.coffeeVariationTableView.bottomAnchor, constant: 20).isActive = true
        
        //self.coffeeSizeSegmentedControll.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    @IBAction func save(_ sender: UIBarButtonItem) {
        ProgressHUD.show();
        
        let name = self.nameTextField.text
        let email = self.emailTextField.text
        let selectedSize = self.coffeeSizeSegmentedControll.titleForSegment(at: self.coffeeSizeSegmentedControll.selectedSegmentIndex)
        
        guard let indexPathForSelectedItemInTableView = self.coffeeVariationTableView.indexPathForSelectedRow else {
            fatalError("Error In selection Coffee")
        }
        
        vm.email = email
        vm.name = name
        vm.selectedSize = selectedSize
        vm.selectedType = self.vm.types[indexPathForSelectedItemInTableView.row]
        
        FirebaseService().loadData(resources: Order.create(vm: vm)){ result in
            switch result{
                case .success(let order):
                    print(order!)
                    ProgressHUD.dismiss()
                case .failure(let error):
                    print(error)
                    ProgressHUD.dismiss()
            }
        }
    }
}

extension NewOrderViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeVariationTableViewCell", for: indexPath)
        cell.textLabel?.text = self.vm.types[indexPath.row];
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
