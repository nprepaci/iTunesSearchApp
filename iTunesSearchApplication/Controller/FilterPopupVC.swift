//
//  FilterPopupVC.swift
//  iTunesSearchApplication
//
//  Created by Nicholas Repaci on 8/28/21.
//

import UIKit

//passes selected category, whether to apply a filter or not (e.g. did user select a category to filter by), and the selected row (to keep track of which row the checkmark should be applied to
protocol PassDataToMainViewDelegate {
  func passDataToMainView(category: String, filterDataYN: Bool, selectedRow: Int)
}

class FilterPopupVC: UIViewController {
  
  @IBOutlet weak var popupContainer: UIView!
  @IBOutlet weak var genreTableView: UITableView!
  @IBOutlet weak var buttonBackgroundLayer: UIView!
  var passDataToMainViewDelegate: PassDataToMainViewDelegate?
  var selectedRow = 0
  var selectedCategory: String = String()
  var filterDataYN: Bool = Bool()
  var pickerData: [String] = ["All", "Apple Watch Apps", "Books", "Business", "Developer Tools", "Education", "Entertainment", "Finance", "Food & Drink", "Games", "Graphic & Design", "Health & Fitness", "Kids", "Lifestyle", "Magazine & Newspaper", "Medical", "Music", "Navigation", "News", "Photo & Video", "Productivity", "Reference", "Shopping", "Social Networking", "Sports", "Travel", "Utilities", "Weather"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //adds rouned corners, but will be tied to specific edges in next line of code
    buttonBackgroundLayer.layer.cornerRadius = 15
    //rounds only specific corners of the view
    buttonBackgroundLayer.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    self.genreTableView.delegate = self
    self.genreTableView.dataSource = self
    popupContainer.layer.cornerRadius = 15
    genreTableView.layer.cornerRadius = 10
  }
  // MARK: - Navigation
  
  //Dismisses view when cancel is clicked
  @IBAction func cancelButtonClicked(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func applyButtonClicked(_ sender: Any) {
    // let mainView = storyboard?.instantiateViewController(identifier: "MainVC") as! ViewController
    //mainView.passDataToFilterScreenDelegate = self
    
    passDataToMainViewDelegate?.passDataToMainView(category: selectedCategory, filterDataYN: filterDataYN, selectedRow: selectedRow)
    
    //run filter function if user applies a filter
    if (filterDataYN == true) {
      DataManager.shared.viewController.performFilterOfResults(searchCriteria: selectedCategory)
    }
    DataManager.shared.viewController.tableView.reloadData()
    //present(mainView, animated: true, completion: nil)
    dismiss(animated: true, completion: nil)
  }
}

extension FilterPopupVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedRow = indexPath.row
    for cell in tableView.visibleCells {
      cell.accessoryType = .none
    }
    //adds checkmark to selected row
    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    
    //if the user selects category of "All", changes filter data to false
    //doing this removes filter on table view, therefore displaying all search results
    if (indexPath.row == 0) {
      filterDataYN = false
      //saves selected category so it is redisplayed when user comes back to this VC
      selectedCategory = ""
      //if a filter category is selected, filter criteria is then assigned to variables to pass via delegate method
    } else {
      filterDataYN = true
      //saves selected category so it is redisplayed when user comes back to this VC
      selectedCategory = pickerData[indexPath.row]
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.accessoryType = indexPath.row == selectedRow ? .checkmark : .none
  }
}

extension FilterPopupVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pickerData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = genreTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    cell.textLabel?.text = pickerData[indexPath.row]
    
    return cell
  }
}
