//
//  TabViewController.swift
//  NameWiz
//
//  Created by Alex Yang on 2019-02-01.
//  Copyright © 2019 Alex Yang. All rights reserved.
//

import Tabman
import Pageboy

class TabViewController: TabmanViewController {

    
    var viewControllers: [EventVC] = [EventVC]()
    var initialPage: Int?
    
    private let eventsInstance = EventsData.instance
    
    override func viewDidLoad() {
        
        self.isScrollEnabled = false
        
        self.dataSource = self
        
        // Create bar
        let bar = TMBar.ButtonBar()
        bar.tintColor = UIColor.lightGray
        bar.backgroundColor = UIColor.lightGray
        bar.backgroundView.style = .clear
        
        
        bar.buttons.customize({ (button) in
            let defaultFont = button.font
            button.font = Customisation.Font.MarkerFelt_Thin ?? defaultFont
            button.selectedTintColor = UIColor.black
            button.tintColor = UIColor.darkGray
        })
        
        bar.indicator.tintColor = UIColor.white
        // Add to view
        addBar(bar, dataSource: self, at: .bottom)
        
        loadEventVCs()
        
        super.viewDidLoad()
        
    }
    
    func loadEventVCs() {
        viewControllers = [EventVC]()
        for index in 0..<eventsInstance.eventsCount {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let eventVC = storyboard.instantiateViewController(withIdentifier: "Event") as! EventVC
            
            eventVC.eventID = index
            eventVC.TabVC = self
            viewControllers.append(eventVC)
        }
        reloadData()
    }

}


extension TabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = eventsInstance.getEventTitle(for: index)
        return TMBarItem(title: title)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.at(index: initialPage ?? 0)
    }
    
    

}
