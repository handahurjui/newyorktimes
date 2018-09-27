//
//  SearchViewController.swift
//  NewYorkTimes
//
//  Created by andah on 27/09/2018.
//  Copyright © 2018 programmer. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate : class {
    func searchBtnDidClick(forType type: String, forSection section: String,forPeriod period: Int)
}
class SearchViewController: UIViewController {
    
    // MARK: - Injections
    fileprivate var networkClient = NetworkClient.shared
    @IBOutlet weak var sectionsPickerView: UIPickerView!
    @IBOutlet weak var postsTypeSecmentedController: UISegmentedControl!
    @IBOutlet weak var timePeriodSegmentedController: UISegmentedControl!
    
    
    var sectionSelected: String?
    var sections : [Section] = []
    weak var delegate: SearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionsPickerView.delegate = self
        sectionsPickerView.dataSource = self
        
        loadSectionsForPickerView()
        // Do any additional setup after loading the view.
    }
    @IBAction func postTypeSecgmentedControllerClicked(_ sender: Any) {
        
        
    }
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func loadSectionsForPickerView(){
        networkClient.getSections(forType: PostType.mostviewed,
                                  forSection: "all-sections",
                                  forTimePeriod: 30,
                                  success: { [weak self](sections) in
                                    guard let strongSelf = self else {return}
                                    strongSelf.sections = sections
                                    strongSelf.sectionSelected = sections[0].section
                                strongSelf.sectionsPickerView.reloadAllComponents()
                                    
        }) { [weak self] (errorString) in
            print("Sections download failed: \(errorString)")
        }
    }
    @IBAction func searchBtnTapped(_ sender : Any){
        self.delegate?.searchBtnDidClick(forType: postsTypeSecmentedController.titleForSegment(at: postsTypeSecmentedController.selectedSegmentIndex)!,
                                         forSection: sectionSelected!,
                                         forPeriod: Int(timePeriodSegmentedController.titleForSegment(at: timePeriodSegmentedController.selectedSegmentIndex)!)!)
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SearchViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         sectionSelected = sections[row].section as String
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections[row].section
    }
}
extension SearchViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sections.count
    }
    
    
}
