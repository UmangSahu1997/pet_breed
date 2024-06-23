//
//  PetListView.swift
//  PetApp
//
//  Created by Umang Sahu on 21/06/24.
//

import UIKit

class PetListView: BaseVC {
    
    @IBOutlet weak var favBtnAction: UIButton!
    @IBAction func favBtnAction(_ sender: UIButton) {
        if let LikedPetsVC = storyboard?.instantiateViewController(withIdentifier: "LikedPetsVC") as? LikedPetsVC {
            navigationController?.pushViewController(LikedPetsVC, animated: true)
        } else {
            print("Failed to instantiate view controller with identifier 'BreedListVC'")
        }
    }
    
    var dogListData: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTblView()
        setupUI()
        getPetsBreedList()
        registerTableViewCells()
    }
    
    private func setupTblView() {
        dogListTblView.dataSource = self
        dogListTblView.delegate = self
        dogListTblView.separatorStyle = .none
    }
    
    private func setupUI() {
        favBtnAction.tintColor = .white
        favBtnAction.backgroundColor = .systemBlue
        favBtnAction.layer.cornerRadius = 4
        favBtnAction.layer.masksToBounds = true
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "PetListTblCell",
                                  bundle: nil)
        self.dogListTblView.register(textFieldCell,
                                     forCellReuseIdentifier: "PetListTblCell")
    }
    
    @IBOutlet weak var dogListTblView: UITableView!
    
    func getPetsBreedList() {
        let url = URL(string: ApiConstant.instance.breedListUrl)!
        httpUtils.getApiData(requestUrl: url, resultType: BreedListModel.self) { (result) in
            if result.status == "success" {
                self.dogListData = self.convertKeysToArray(result.message?.keys)
                DispatchQueue.main.async {
                    self.dogListTblView.reloadData()
                }
            }
        }
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
            cell.bindCell(data: dogListData?[indexPath.row] ?? "")
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let breedListVC = storyboard?.instantiateViewController(withIdentifier: "BreedDetailVC") as? BreedDetailVC {
            breedListVC.breed = dogListData?[indexPath.row] ?? ""
            navigationController?.pushViewController(breedListVC, animated: true)
        } else {
            print("Failed to instantiate view controller with identifier 'BreedListVC'")
        }
    }
}

