//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Yuichi Kuroda on 9/27/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
  optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {
  @IBOutlet weak var categoriesTableView: UITableView!
  @IBOutlet weak var dealsSwitch: UISwitch!
  @IBOutlet weak var distanceContainerView: UIView!
  @IBOutlet weak var distanceAutoButton: UIButton!
  @IBOutlet weak var distance1Button: UIButton!
  @IBOutlet weak var distance2Button: UIButton!
  @IBOutlet weak var sortBestMatchButton: UIButton!
  @IBOutlet weak var sortDistanceButton: UIButton!
  @IBOutlet weak var sortHighestRatedButton: UIButton!
  @IBOutlet weak var sortContainerView: UIView!
  
  var switchStates = [Int:Bool]()
  var distanceOptions = [0, 0.3, 1, 5, 20]
  var selectedDistance: Double = 0
  var selectedSort: Int?
  
  weak var delegate: FiltersViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    categoriesTableView.delegate = self
    categoriesTableView.dataSource = self
    categoriesTableView.layer.borderColor = UIColor.blackColor().CGColor
    categoriesTableView.layer.borderWidth = 0.3
    categoriesTableView.layer.cornerRadius = 5.0
    
    dealsSwitch.on = false
    
    distanceAutoButton.backgroundColor = UIColor.grayColor()
    distanceAutoButton.addTarget(self, action: "setDistance:", forControlEvents: UIControlEvents.TouchUpInside)
    distanceAutoButton.highlighted = true
    distanceAutoButton.layer.cornerRadius = 4
    
    distance1Button.addTarget(self, action: "setDistance:", forControlEvents: UIControlEvents.TouchUpInside)
    distance1Button.highlighted = false
    distance1Button.layer.cornerRadius = 4
    
    distance2Button.addTarget(self, action: "setDistance:", forControlEvents: UIControlEvents.TouchUpInside)
    distance2Button.highlighted = false
    distance2Button.layer.cornerRadius = 4
    

    sortBestMatchButton.addTarget(self, action: "setSortBy:", forControlEvents: UIControlEvents.TouchUpInside)
    sortBestMatchButton.highlighted = false
    sortBestMatchButton.layer.cornerRadius = 4
    
    sortDistanceButton.addTarget(self, action: "setSortBy:", forControlEvents: UIControlEvents.TouchUpInside)
    sortDistanceButton.highlighted = false
    sortDistanceButton.layer.cornerRadius = 4
    
    sortHighestRatedButton.addTarget(self, action: "setSortBy:", forControlEvents: UIControlEvents.TouchUpInside)
    sortHighestRatedButton.highlighted = false
    sortHighestRatedButton.layer.cornerRadius = 4
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setDistance(sender: UIButton!) {
    for view in distanceContainerView.subviews {
      if let button = view as? UIButton {
        if button == sender {
          button.backgroundColor = UIColor.grayColor()
          button.highlighted = true
          
          if let value = button.titleLabel?.text {
            selectedDistance = (value as NSString).doubleValue
          } else {
            selectedDistance = 0
          }
        } else {
          button.backgroundColor = UIColor.whiteColor()
          button.highlighted = false
        }
      }
    }
  }
  
  func setSortBy(sender: UIButton!) {
    for view in sortContainerView.subviews {
      if let button = view as? UIButton {
        if button == sender {
          button.backgroundColor = UIColor.grayColor()
          button.highlighted = true
          
          if button.titleLabel!.text == "Best Match" {
            selectedSort = YelpSortMode.BestMatched.rawValue
          } else if button.titleLabel!.text == "Distance" {
            selectedSort = YelpSortMode.Distance.rawValue
          } else if button.titleLabel!.text == "Highest Rated" {
            selectedSort = YelpSortMode.HighestRated.rawValue
          }
        } else {
          button.backgroundColor = UIColor.whiteColor()
          button.highlighted = false
        }
      }
    }
  }
  
  @IBAction func onCancelButton(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func onSearchButton(sender: AnyObject) {
    var filters = [String:AnyObject]()
    
    dismissViewControllerAnimated(true, completion: nil)
    
    var selectedCategories = [String]()
    for (row,isSelected) in switchStates {
      if isSelected {
        selectedCategories.append(categories[row]["code"]!)
      }
    }
    if selectedCategories.count > 0 {
      filters["categories"] = selectedCategories
    }
    
    filters["deals"] = dealsSwitch.on
    
    if selectedDistance > 0 {
      filters["radius"] = selectedDistance
    }
    
    if selectedSort != nil {
      filters["sort"] = selectedSort!
    }
    
    delegate?.filtersViewController?(self, didUpdateFilters: filters)
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell

    cell.switchLabel.text = categories[indexPath.row]["name"]
    cell.delegate = self
    
    cell.onSwitch.on = switchStates[indexPath.row] ?? false
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
  }
  
  func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {    
    let indexPath = categoriesTableView.indexPathForCell(switchCell)!
      
    switchStates[indexPath.row] = value
  }
  
  let categories = [["name" : "Afghan", "code": "afghani"],
    ["name" : "African", "code": "african"],
    ["name" : "American, New", "code": "newamerican"],
    ["name" : "American, Traditional", "code": "tradamerican"],
    ["name" : "Arabian", "code": "arabian"],
    ["name" : "Argentine", "code": "argentine"],
    ["name" : "Armenian", "code": "armenian"],
    ["name" : "Asian Fusion", "code": "asianfusion"],
    ["name" : "Asturian", "code": "asturian"],
    ["name" : "Australian", "code": "australian"],
    ["name" : "Austrian", "code": "austrian"],
    ["name" : "Baguettes", "code": "baguettes"],
    ["name" : "Bangladeshi", "code": "bangladeshi"],
    ["name" : "Barbeque", "code": "bbq"],
    ["name" : "Basque", "code": "basque"],
    ["name" : "Bavarian", "code": "bavarian"],
    ["name" : "Beer Garden", "code": "beergarden"],
    ["name" : "Beer Hall", "code": "beerhall"],
    ["name" : "Beisl", "code": "beisl"],
    ["name" : "Belgian", "code": "belgian"],
    ["name" : "Bistros", "code": "bistros"],
    ["name" : "Black Sea", "code": "blacksea"],
    ["name" : "Brasseries", "code": "brasseries"],
    ["name" : "Brazilian", "code": "brazilian"],
    ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
    ["name" : "British", "code": "british"],
    ["name" : "Buffets", "code": "buffets"],
    ["name" : "Bulgarian", "code": "bulgarian"],
    ["name" : "Burgers", "code": "burgers"],
    ["name" : "Burmese", "code": "burmese"],
    ["name" : "Cafes", "code": "cafes"],
    ["name" : "Cafeteria", "code": "cafeteria"],
    ["name" : "Cajun/Creole", "code": "cajun"],
    ["name" : "Cambodian", "code": "cambodian"],
    ["name" : "Canadian", "code": "New)"],
    ["name" : "Canteen", "code": "canteen"],
    ["name" : "Caribbean", "code": "caribbean"],
    ["name" : "Catalan", "code": "catalan"],
    ["name" : "Chech", "code": "chech"],
    ["name" : "Cheesesteaks", "code": "cheesesteaks"],
    ["name" : "Chicken Shop", "code": "chickenshop"],
    ["name" : "Chicken Wings", "code": "chicken_wings"],
    ["name" : "Chilean", "code": "chilean"],
    ["name" : "Chinese", "code": "chinese"],
    ["name" : "Comfort Food", "code": "comfortfood"],
    ["name" : "Corsican", "code": "corsican"],
    ["name" : "Creperies", "code": "creperies"],
    ["name" : "Cuban", "code": "cuban"],
    ["name" : "Curry Sausage", "code": "currysausage"],
    ["name" : "Cypriot", "code": "cypriot"],
    ["name" : "Czech", "code": "czech"],
    ["name" : "Czech/Slovakian", "code": "czechslovakian"],
    ["name" : "Danish", "code": "danish"],
    ["name" : "Delis", "code": "delis"],
    ["name" : "Diners", "code": "diners"],
    ["name" : "Dumplings", "code": "dumplings"],
    ["name" : "Eastern European", "code": "eastern_european"],
    ["name" : "Ethiopian", "code": "ethiopian"],
    ["name" : "Fast Food", "code": "hotdogs"],
    ["name" : "Filipino", "code": "filipino"],
    ["name" : "Fish & Chips", "code": "fishnchips"],
    ["name" : "Fondue", "code": "fondue"],
    ["name" : "Food Court", "code": "food_court"],
    ["name" : "Food Stands", "code": "foodstands"],
    ["name" : "French", "code": "french"],
    ["name" : "French Southwest", "code": "sud_ouest"],
    ["name" : "Galician", "code": "galician"],
    ["name" : "Gastropubs", "code": "gastropubs"],
    ["name" : "Georgian", "code": "georgian"],
    ["name" : "German", "code": "german"],
    ["name" : "Giblets", "code": "giblets"],
    ["name" : "Gluten-Free", "code": "gluten_free"],
    ["name" : "Greek", "code": "greek"],
    ["name" : "Halal", "code": "halal"],
    ["name" : "Hawaiian", "code": "hawaiian"],
    ["name" : "Heuriger", "code": "heuriger"],
    ["name" : "Himalayan/Nepalese", "code": "himalayan"],
    ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
    ["name" : "Hot Dogs", "code": "hotdog"],
    ["name" : "Hot Pot", "code": "hotpot"],
    ["name" : "Hungarian", "code": "hungarian"],
    ["name" : "Iberian", "code": "iberian"],
    ["name" : "Indian", "code": "indpak"],
    ["name" : "Indonesian", "code": "indonesian"],
    ["name" : "International", "code": "international"],
    ["name" : "Irish", "code": "irish"],
    ["name" : "Island Pub", "code": "island_pub"],
    ["name" : "Israeli", "code": "israeli"],
    ["name" : "Italian", "code": "italian"],
    ["name" : "Japanese", "code": "japanese"],
    ["name" : "Jewish", "code": "jewish"],
    ["name" : "Kebab", "code": "kebab"],
    ["name" : "Korean", "code": "korean"],
    ["name" : "Kosher", "code": "kosher"],
    ["name" : "Kurdish", "code": "kurdish"],
    ["name" : "Laos", "code": "laos"],
    ["name" : "Laotian", "code": "laotian"],
    ["name" : "Latin American", "code": "latin"],
    ["name" : "Live/Raw Food", "code": "raw_food"],
    ["name" : "Lyonnais", "code": "lyonnais"],
    ["name" : "Malaysian", "code": "malaysian"],
    ["name" : "Meatballs", "code": "meatballs"],
    ["name" : "Mediterranean", "code": "mediterranean"],
    ["name" : "Mexican", "code": "mexican"],
    ["name" : "Middle Eastern", "code": "mideastern"],
    ["name" : "Milk Bars", "code": "milkbars"],
    ["name" : "Modern Australian", "code": "modern_australian"],
    ["name" : "Modern European", "code": "modern_european"],
    ["name" : "Mongolian", "code": "mongolian"],
    ["name" : "Moroccan", "code": "moroccan"],
    ["name" : "New Zealand", "code": "newzealand"],
    ["name" : "Night Food", "code": "nightfood"],
    ["name" : "Norcinerie", "code": "norcinerie"],
    ["name" : "Open Sandwiches", "code": "opensandwiches"],
    ["name" : "Oriental", "code": "oriental"],
    ["name" : "Pakistani", "code": "pakistani"],
    ["name" : "Parent Cafes", "code": "eltern_cafes"],
    ["name" : "Parma", "code": "parma"],
    ["name" : "Persian/Iranian", "code": "persian"],
    ["name" : "Peruvian", "code": "peruvian"],
    ["name" : "Pita", "code": "pita"],
    ["name" : "Pizza", "code": "pizza"],
    ["name" : "Polish", "code": "polish"],
    ["name" : "Portuguese", "code": "portuguese"],
    ["name" : "Potatoes", "code": "potatoes"],
    ["name" : "Poutineries", "code": "poutineries"],
    ["name" : "Pub Food", "code": "pubfood"],
    ["name" : "Rice", "code": "riceshop"],
    ["name" : "Romanian", "code": "romanian"],
    ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
    ["name" : "Rumanian", "code": "rumanian"],
    ["name" : "Russian", "code": "russian"],
    ["name" : "Salad", "code": "salad"],
    ["name" : "Sandwiches", "code": "sandwiches"],
    ["name" : "Scandinavian", "code": "scandinavian"],
    ["name" : "Scottish", "code": "scottish"],
    ["name" : "Seafood", "code": "seafood"],
    ["name" : "Serbo Croatian", "code": "serbocroatian"],
    ["name" : "Signature Cuisine", "code": "signature_cuisine"],
    ["name" : "Singaporean", "code": "singaporean"],
    ["name" : "Slovakian", "code": "slovakian"],
    ["name" : "Soul Food", "code": "soulfood"],
    ["name" : "Soup", "code": "soup"],
    ["name" : "Southern", "code": "southern"],
    ["name" : "Spanish", "code": "spanish"],
    ["name" : "Steakhouses", "code": "steak"],
    ["name" : "Sushi Bars", "code": "sushi"],
    ["name" : "Swabian", "code": "swabian"],
    ["name" : "Swedish", "code": "swedish"],
    ["name" : "Swiss Food", "code": "swissfood"],
    ["name" : "Tabernas", "code": "tabernas"],
    ["name" : "Taiwanese", "code": "taiwanese"],
    ["name" : "Tapas Bars", "code": "tapas"],
    ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
    ["name" : "Tex-Mex", "code": "tex-mex"],
    ["name" : "Thai", "code": "thai"],
    ["name" : "Traditional Norwegian", "code": "norwegian"],
    ["name" : "Traditional Swedish", "code": "traditional_swedish"],
    ["name" : "Trattorie", "code": "trattorie"],
    ["name" : "Turkish", "code": "turkish"],
    ["name" : "Ukrainian", "code": "ukrainian"],
    ["name" : "Uzbek", "code": "uzbek"],
    ["name" : "Vegan", "code": "vegan"],
    ["name" : "Vegetarian", "code": "vegetarian"],
    ["name" : "Venison", "code": "venison"],
    ["name" : "Vietnamese", "code": "vietnamese"],
    ["name" : "Wok", "code": "wok"],
    ["name" : "Wraps", "code": "wraps"],
    ["name" : "Yugoslav", "code": "yugoslav"]]
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
