//
//  PetListView.swift
//  PetApp
//
//  Created by Umang Sahu on 21/06/24.
//

import UIKit

struct Post: Codable {
// The names of the variables should match with the keys used in the link. Also, the data types should match with the values of the URL link.
    let message: [String: [String]]?
        let status: String
}

class PetListView: UIViewController {
    
    var dogListData: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        dogListTblView.dataSource = self
        dogListTblView.delegate = self
        dd()
        registerTableViewCells()
        // Do any additional setup after loading the view.
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "PetListTblCell",
                                  bundle: nil)
        self.dogListTblView.register(textFieldCell,
                                forCellReuseIdentifier: "PetListTblCell")
    }
    
    @IBOutlet weak var dogListTblView: UITableView!
    
    func dd() {
        let url = URL(string: "https://dog.ceo/api/breeds/list/all")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"  // optional
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error {
                print("Error while fetching data:", error)
                return
            }

            guard let data = data else {
                return
            }

        do {
            let posts = try JSONDecoder().decode(Post.self, from: data)
            self.dogListData = self.convertKeysToArray(posts.message?.keys)
            DispatchQueue.main.async {
                self.dogListTblView.reloadData()
            }
            print("User ID:", posts)
            //print("Id:", jj.status)
            } catch let jsonError {
                print("Failed to decode json", jsonError)
            }

        }
        task.resume()
    }
    
    func convertKeysToArray(_ keys: Dictionary<String, [String]>.Keys?) -> [String] {
        guard let keys = keys else {
            return []
        }
        return Array(keys)
    }
}

extension PetListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogListData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PetListTblCell") as? PetListTblCell {
            cell.breedLbl.text = dogListData?[indexPath.row] ?? ""
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Instantiate BreedListVC from storyboard
        if let breedListVC = storyboard?.instantiateViewController(withIdentifier: "BreedListVC") as? BreedDetailVC {
            // Assign data to BreedListVC's property
            breedListVC.gg = dogListData?[indexPath.row] ?? ""
            
            // Push BreedListVC onto the navigation stack
            navigationController?.pushViewController(breedListVC, animated: true)
        } else {
            print("Failed to instantiate view controller with identifier 'BreedListVC'")
        }
    }
}

