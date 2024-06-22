//
//  LikedPetsVC.swift
//  PetApp
//
//  Created by Umang Sahu on 22/06/24.
//

import UIKit

struct LikedPet {
    let imgUrl: String?
    let breed: String?
}

class LikedPetsVC: BaseVC {

    
    var likedList: [LikedPet] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print(likedPetList)
        if let strings = userDefaults.object(forKey: "myKey") as? [String:[String]] {
            print(strings.keys)
            print(strings.values)
            var count = 0
            strings.forEach { (key: String, value: [String]) in
                print(key)
                count = count + 1
                value.forEach { imageUrl in
                    likedList.append(LikedPet(imgUrl: imageUrl, breed: key))
                }
            }
            print(count)
        }
        likedPetTblView.dataSource = self
        likedPetTblView.delegate = self
        registerTableViewCells()
        likedPetTblView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "BreedWiseTblViewCell",
                                  bundle: nil)
        self.likedPetTblView.register(textFieldCell,
                                forCellReuseIdentifier: "BreedWiseTblViewCell")
    }
    @IBOutlet weak var likedPetTblView: UITableView!
}

extension LikedPetsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        likedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BreedWiseTblViewCell") as? BreedWiseTblViewCell {
            if let imgUrl = URL(string: (likedList[indexPath.row].imgUrl ?? "")) {
                cell.petImgView.load(url: imgUrl)
            }
            cell.indexPath = indexPath
           // cell.likeDelegate = self
            //if isLiked[indexPath.row] {
            cell.likeDelegate = self
                cell.likeBtn.backgroundColor = .green
            cell.breedLbl.text = likedList[indexPath.row].breed ?? ""
            //}
//            else {
//                cell.likeBtn.backgroundColor = .red
//            }
            return cell
        }
        
        return UITableViewCell()
    }
}

extension LikedPetsVC: TodoDelegate {
    func likeBtnTap(for cell: BreedWiseTblViewCell) {
        
        if let indexPath = cell.indexPath {
            
            var strings = userDefaults.object(forKey: "myKey") as? [String:[String]]
            print(strings?[likedList[cell.indexPath?.row ?? 0].breed ?? ""])
            //strings?[likedList[cell.indexPath?.row ?? 0].breed ?? ""]?.remove(at: 0)
            let fString = strings?[likedList[cell.indexPath?.row ?? 0].breed ?? ""]?.filter { $0 != likedList[cell.indexPath?.row ?? 0].imgUrl ?? "" }
            strings?[likedList[cell.indexPath?.row ?? 0].breed ?? ""] = fString
            userDefaults.set(strings, forKey: "myKey")
            likedList.remove(at: indexPath.row)
            likedPetTblView.reloadData()
        }
       
        
        print("hhhh")
    }
}
