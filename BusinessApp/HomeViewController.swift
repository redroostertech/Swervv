//
//  HomeViewController.swift
//  BusinessApp
//
//  Created by Michael Westbrooks II on 12/2/17.
//  Copyright © 2017 RedRooster Technologies Inc. All rights reserved.
//

import UIKit
import FoldingCell
import BTNavigationDropdownMenu
import BarcodeScanner
import Charts

class HomeTableViewCell: FoldingCell  {
    @IBOutlet weak var metricslabel: UILabel!
    @IBOutlet weak var mainchart: UIView!
    @IBOutlet weak var mainbutton: UIButton!
    @IBOutlet weak var snapshotone: UILabel!
    @IBOutlet weak var snapshottwo: UILabel!
    @IBOutlet weak var snapshotonetitle: UILabel!
    @IBOutlet weak var snapshottwotitle: UILabel!
    @IBOutlet weak var snapshotthree: UILabel!
    
    var metricstitle: String? {
        didSet {
            metricslabel.text = metricstitle
        }
    }
    
    var snapshotonetext: String? {
        didSet {
            snapshotone.text = snapshotonetext
        }
    }
    
    var snapshottwotext: String? {
        didSet {
            snapshottwo.text = snapshottwotext
        }
    }
    
    var snapshotthreetext: String? {
        didSet {
            snapshotthree.text = snapshotthreetext
        }
    }
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        mainbutton.layer.cornerRadius = mainbutton.frame.height / 2
        mainbutton.layer.masksToBounds = true
        
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
}

class HomeViewTableDataSource: NSObject, UITableViewDataSource {
    var dataTitles = ["Sales", "Inventory"]
    var dataPoints = [
        [
            "count": "$1.5k",
            "change": "+45%",
            "cpu" : "$120.00"
        ], [
            "count": "400 units",
            "change": "+25%",
            "cpu": "32"
        ]
    ]
    override init(){
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeTableViewCell.self)) as! HomeTableViewCell
        let durations = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        switch indexPath.row {
        case 0:
            cell.metricstitle = self.dataTitles[indexPath.row]
            cell.snapshotonetext = "Today's Sales"
            cell.snapshotone.text = (self.dataPoints[indexPath.row] as [String: String])["count"]
            cell.snapshottwotext = "% Change last Wk"
            cell.snapshottwo.text = (self.dataPoints[indexPath.row] as [String:String])["change"]
            cell.snapshotthreetext = "Your average cost per unit this week is \((self.dataPoints[indexPath.row] as [String:String])["cpu"]!)"
        case 1:
            cell.metricstitle = self.dataTitles[indexPath.row]
            cell.snapshotthreetext = "Your average unit sold this week is 145"
        default:
            break
        }
        return cell
    }

}

class HomeViewController: UIViewController, UITableViewDelegate, BarcodeScannerDismissalDelegate, BarcodeScannerErrorDelegate, BarcodeScannerCodeDelegate, ChartViewDelegate {

    @IBOutlet weak var maintable: UITableView!
    @IBOutlet weak var chartView: LineChartView!
    
    let datasource: HomeViewTableDataSource
    
    let menuitems = ["My Inventory","Marketplace", "Profile", "Inbox"]
    let closeheight: CGFloat = 100
    let openheight: CGFloat = 210
    var cellheights: [CGFloat] = []
    
    var months: [String]!
    var unitssold: [Double]!    //  Dummy Data
    var dataentries = [ChartDataEntry]()
    
    required init?(coder aDecoder: NSCoder) {
        self.datasource = HomeViewTableDataSource()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellheights = Array(repeating: closeheight, count: 5)
        maintable.estimatedRowHeight = closeheight
        maintable.rowHeight = UITableViewAutomaticDimension
        maintable.delegate = self
        maintable.dataSource = datasource
        
        //  MARK:- Setup Chart
        self.chartView.delegate = self
        self.chartView.chartDescription?.enabled = false
        self.chartView.dragEnabled = true
        self.chartView.setScaleEnabled(true)
        self.chartView.pinchZoomEnabled = true
        
        /*let leftxaxislim = ChartLimitLine(limit: 10, label: "Index 10")
        leftxaxislim.lineWidth = 4
        leftxaxislim.lineDashLengths = [ 10, 10, 0 ]
        
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        
        let upper = ChartLimitLine(limit: 150, label: "Max")
        upper.lineWidth = 4
        upper.lineDashLengths = [ 5 , 5 ]
        
        let lower = ChartLimitLine(limit: -30, label: "Min")
        lower.lineWidth = 4
        lower.lineDashLengths = [ 5, 5 ]
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(upper)
        leftAxis.addLimitLine(lower)
        leftAxis.axisMaximum = 200
        leftAxis.axisMinimum = -50
        leftAxis.gridLineDashLengths = [ 5, 5 ]
        leftAxis.drawLimitLinesBehindDataEnabled = true*/
        
        chartView.rightAxis.enabled = false
        
        chartView.animate(xAxisDuration: 2.5)
        
        //  MARK:- Setup menu
        let menuview = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: (self.navigationController?.view)!, title: BTTitle.title("Welcome to Swerv"), items: menuitems)
        self.navigationItem.titleView = menuview
        
        menuview.didSelectItemAtIndexHandler = {
            [weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            switch indexPath {
            case 0:
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "InventoryList")
                self?.navigationController?.pushViewController(vc, animated: true)
            case 1:
                print("Profile Marketplace")
            case 2:
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "Profile")
                self?.navigationController?.pushViewController(vc, animated: true)
            case 3:
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "Inbox")
                self?.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
        
        self.months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        self.unitssold = [10, 4, 7, 9, 3, 0, 5, 6, 6, 10, 17, 20]
        setchart(self.months, values: self.unitssold)
    }
    
    func setchart(_ dataPoints: [String], values: [Double]) {
        self.chartView.noDataText = "No data available for chart."
        var count: Int = 0
        for i in self.months {
            let dataentry = ChartDataEntry(x: Double(count), y: values[count])
            self.dataentries.append(dataentry)
            count += 1
        }
        
        let line1 = LineChartDataSet(values: self.dataentries, label: "Units Sold")
        line1.colors = [NSUIColor.blue]
        let chartData = LineChartData()
        chartData.addDataSet(line1)
        
        self.chartView.data = chartData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as HomeTableViewCell = cell else {
            return
        }
        
        if cellheights[indexPath.row] == closeheight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellheights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        if cell.isAnimating() {
            return
        }
        var duration = 0.0
        let celliscollapsed = cellheights[indexPath.row] == closeheight
        if celliscollapsed {
            cellheights[indexPath.row] = openheight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellheights[indexPath.row] = closeheight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    @IBAction func quickscan(_ sender: UIButton) {
        let controller = BarcodeScannerController()
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print(code)
        print(type)
    }
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        controller.resetWithError(message: "Error Message")
    }
}
