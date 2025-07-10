//
//  ProfileViewController.swift
//  Swara
//
//  Created by Varshitha VRaj on 23/06/25.
//

import UIKit

class ProfileViewController: UIViewController{

    private let tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var models = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Profile"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchProfile()
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    
    
    private func fetchProfile(){
        
        APICaller.shared.getCurrentUsrtProfile {[weak self] result in
            
            DispatchQueue.main.async{
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.failedToGetProfile()
                    break
                }
            }
        }
    }
    
    
    private func updateUI(with model: UserProfile){
        tableView.isHidden = false
        // configure table models
        models.append("Full Name: \(String(describing: model.display_name))")
        models.append("Full Name: \(String(describing: model.id))")
        models.append("Full Name: \(String(describing: model.country))")
        models.append("Full Name: \(String(describing: model.product))")
        tableView.reloadData()
        
    }
    
    
    private func failedToGetProfile(){
        
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
        
    }
 

}

//MARK: TABLE VIEW

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Dummy"
        
        cell.selectionStyle = .none
        return cell
    }
        
}
