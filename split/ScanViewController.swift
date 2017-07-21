//
//  ScanViewController.swift
//  split
//
//  Created by Brandon Taleisnik on 7/10/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import UIKit
import DSGradientProgressView
import Alamofire

class ScanViewController: UIViewController {
    
    
    var allBlocks: [Block] = []
    var prices: [Double] = []
    var total: Double?
    var receiptImage: UIImage?
    var totalIndex: Int?
    var foundDouble: Bool?
    var items: [Item] = []
    var nextPriceIndexToAdd: Int = 0
    var scanningComplete: Bool?
    var delegate: RescanDelegate?
    
    
    
    @IBOutlet weak var progressView: DSGradientProgressView!
    @IBOutlet weak var rescanUIButton: UIBarButtonItem!
    @IBOutlet weak var receiptImageView: UIImageView!
    

    
    override func viewWillAppear(_ animated: Bool) {
        progressView.barColor = UIColor.green
        
        if scanningComplete == false {
            progressView.wait()
            self.rescanUIButton.title = ""
            self.rescanUIButton.isEnabled = false
        } else if scanningComplete == true {
            progressView.signal()
            progressView.isHidden = true
            self.rescanUIButton.title = "Re-Scan"
            self.rescanUIButton.isEnabled = true
            self.navigationItem.title = "Tap: Prices > Total > Items"
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rescanUIButton.title = ""
        
        let viewSize = self.view.frame.size
        let imageLocation = receiptImageView.frame.origin
        print("\nVIEW SIZE:")
        print(viewSize)
        
        print("\nUIIMAGEVIEW SIZE:")
        print(receiptImageView.frame.size)
        
        if let currentReciept = receiptImage {
            receiptImageView.image = currentReciept
        }
        //print("\n\n\nNEW CONTROLLER")
        //print(allBlocks)
        print("\nIMAGE LOCATION")
        print(imageLocation)
        
        if allBlocks.count > 0 {
            
            //draw original blocks
            var counter: Int = 0
            for block in allBlocks {
                let button = calcButtonCoordinates(block: block)
                button.tag = counter
                button.addTarget(self, action: #selector(blockTapped), for: .touchUpInside)
                button.layer.borderColor = UIColor.green.cgColor
                button.layer.borderWidth = 2
                view.addSubview(button)
                
                counter += 1
            }
            
            //let newBlock: [Block] = rescaleBlock(viewSize: viewSize, imageSize: receiptImage?.size, allBlocks: allBlocks, imageLocation: imageLocation)
            
            //draw re-scaled blocks
            //counter = 0
            //for block in newBlock {
            //    let button = calcButtonCoordinates(block: block)
            //    button.tag = counter
            //    button.addTarget(self, action: #selector(blockTapped), for: .touchUpInside)
            //    button.layer.borderColor = UIColor.green.cgColor
            //    button.layer.borderWidth = 2
            //    //view.addSubview(button)
            //    receiptimageView.addSubview(button)
            
            
            
            //    counter += 1
            //}
        }
    }

    @IBAction func rescanButton(_ sender: Any) {
        self.delegate?.didClickRescan()

    }
    
    
    func blockTapped(sender: UIButton) {
        
        var currentBlock: Block = allBlocks[sender.tag]
        foundDouble = false
        
        var counter: Int = 0
        
        for i in 0..<currentBlock.paragraphs.count {
            //print(currentBlock.paragraphs[i])
            
            //for every line in paragraph, add price element if can be converted to double (i.e. a price)
            for k in 0..<currentBlock.paragraphs[i].count {
                if let priceDouble = currentBlock.paragraphs[i][k].doubleValue {
                    prices.append(priceDouble)
                    foundDouble = true
                    //sender.layer.borderColor = UIColor.cyan.cgColor
                    sender.backgroundColor = UIColor(red: 84/255, green: 136/255, blue: 138/255, alpha: 0.5)
                }
            }
        }
        
        //If prices have been selected, assume highest price is total
        if prices.isEmpty == false {
            
            //find current highest number in prices
            let currentTotal: Double = prices.max()!
            
            //if no total has been set yet, make currentTotal = total, remove it from pirce, and keep track of index
            if total == nil {
                total = currentTotal
                totalIndex = prices.index(of: prices.max()!)
                //prices = prices.filter{$0 != currentTotal}
                prices.remove(at: totalIndex!)
            }
            
            //if currentTotal is greater than total, insert total back into prices and replace with currentTotal
            if currentTotal > total! {
                //add back old total in correct index
                prices.insert(total!, at: totalIndex!)
                
                //store index of new total and filter out
                totalIndex = prices.index(of: currentTotal)
                total = currentTotal
                //prices = prices.filter{$0 != currentTotal}
                prices.remove(at: totalIndex!)
            }
            
        }
        
        //if prices existed in the block, we're done and our work was already done above
        if foundDouble == false {
            
            //sender.layer.borderColor = UIColor.cyan.cgColor
            sender.backgroundColor = UIColor(red: 84/255, green: 136/255, blue: 138/255, alpha: 0.5)
            
            //for each item, assign it a price, add to items dictionary, and update priceAdded tracker
            for i in 0..<currentBlock.paragraphs.count {
                for k in 0..<currentBlock.paragraphs[i].count {
                    
                    //make sure prices index is in scope, if not, exit
                    if nextPriceIndexToAdd < prices.count {
                        //if item is not free (discard/skip if it is), assign price to item
                        if prices[nextPriceIndexToAdd] != 0.0 {
                            items.append(Item(name: currentBlock.paragraphs[i][k], price: prices[nextPriceIndexToAdd], itemID: String(counter)))
                            counter += 1
                        }
                        nextPriceIndexToAdd += 1
                    }
                }
            }
        }
        
        //if all data seems complete (i.e. items.count = prices.count, sum(prices) = total, etc.)
        if checkItemCompletion(prices: prices, total: total, allItems: items) == true {
            
//            Alamofire.request("https://split2-62ca2.firebaseio.com/items.json", method: .delete)
//
//            for item in items {
//                Alamofire.request("https://split2-62ca2.firebaseio.com/items.json", method: .post, parameters: item.toJSON(), encoding: JSONEncoding.default).responseJSON(completionHandler: {response in
//    
//                    switch response.result {
//                    case .success:
//                        //                self.delegate?.didAddActivity(activity: activityDto!)
//                        //self.dismiss(animated: true, completion: nil)
//                        break
//                    case .failure:
//                        // TODO: Display an error dialog
//                        break
//                    }
//                    
//                })
//            }
            
            performSegue(withIdentifier: "navToGuests", sender: nil)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navToGuests" {
            let guestsVC = segue.destination as! GuestsTableViewController
            
            guestsVC.items = self.items
            
        }
    }
    
    func checkItemCompletion(prices: [Double], total: Double?, allItems: [Item]) -> Bool {
        
        //check item prices add up to total
        var itemSum: Double = 0.0
        for i in allItems {
            itemSum += i.price!
            
            //check all items have a name and price
            if i.name == nil || i.price == nil {
                return false
            }
        }
        
        if itemSum > total! {
            return false
        }
        
        let pricesWithoutZero = prices.filter{$0 != 0.0}.count
        
        //check if counts match up when removing 0
//        let zeroIndex = prices.index(of: 0.0)
//        var pricesWithoutZero = prices
        //pricesWithoutZero.remove(at: zeroIndex!)
        //check there are same # of items as prices
        if pricesWithoutZero != allItems.count {
            return false
        }
        
        //if total exists but no prices, return false bc that means block with 1 item was chosen and removed bc current highest total, so not done clicking price blocks
        if total != nil && prices.count == 0 {
            return false
        }
        
        return true
    }
    
    func calcButtonCoordinates(block: Block)->UIButton {
        let x = block.v1?.x
        let y = block.v1?.y
        let width = (block.v2?.x)! - (block.v1?.x)!
        let height = (block.v3?.y)! - (block.v2?.y)!
        
        return UIButton(frame: CGRect(x: x!, y: y!, width: width, height: height))
    }
    
    func rescaleBlock(viewSize: CGSize, imageSize: CGSize?, allBlocks: [Block], imageLocation: CGPoint) -> [Block] {
        
        let imageHeight = imageSize?.height
        let imageWidth = imageSize?.width
        let viewHeight = viewSize.height
        let viewWidth = viewSize.width
        
        var newBlock: [Block] = allBlocks
        
        //If view size > image size, xScaler and yScaler will be >1 and will expand block
        //If image size > view size, xScaler and yScaler will be <1 and will reduce block
        let xScaler = viewWidth/imageWidth!
        let yScaler = viewHeight/imageHeight!
        
        //Re-scale x coordinates using xScale multiplier and adjust for non 0,0 position
        
        var i = 0
        for block in allBlocks {
            
            //print old coordinates
            print("OLD COORDINATES:")
            print(block.v1?.x ?? CGFloat(0.0))
            print(block.v2?.x ?? CGFloat(0.0))
            print(block.v3?.x ?? CGFloat(0.0))
            print(block.v4?.x ?? CGFloat(0.0))
            
            newBlock[i].v1?.x = (CGFloat((block.v1?.x)!) * (xScaler)) //+ imageLocation.x
            newBlock[i].v2?.x = (CGFloat((block.v2?.x)!) * (xScaler)) //+ imageLocation.x
            newBlock[i].v3?.x = (CGFloat((block.v3?.x)!) * (xScaler)) //+ imageLocation.x
            newBlock[i].v4?.x = (CGFloat((block.v4?.x)!) * (xScaler)) //+ imageLocation.x
            
            //print new coordinates
            print("\nNEW COORDINATES:")
            print(newBlock[i].v1?.x ?? CGFloat(0.0))
            print(newBlock[i].v2?.x ?? CGFloat(0.0))
            print(newBlock[i].v3?.x ?? CGFloat(0.0))
            print(newBlock[i].v4?.x ?? CGFloat(0.0))
            
            i += 1
            
        }
        
        
        
        //Re-scale y coordinates using yScaler multiplier, and adjust for non 0,0 position
        
        i = 0
        for block in allBlocks {
            
            newBlock[i].v1?.y = (CGFloat((block.v1?.y)!) * (yScaler)) //+ imageLocation.y
            newBlock[i].v2?.y = (CGFloat((block.v2?.y)!) * (yScaler)) //+ imageLocation.y
            newBlock[i].v3?.y = (CGFloat((block.v3?.y)!) * (yScaler)) //+ imageLocation.y
            newBlock[i].v4?.y = (CGFloat((block.v4?.y)!) * (yScaler)) //+ imageLocation.y
            
            i += 1
        }
        
        
        
        return newBlock
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}























//
//import UIKit
//import Alamofire
//
//class ScanViewController: UIViewController {
//
//    @IBOutlet weak var receiptRaw: UIImageView!
//    @IBOutlet weak var scanButton: UIButton!
//    @IBOutlet weak var receiptScanned: UIImageView!
//
//    
//    var items: [Item] = []
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //Will delete this once real OCR is implemented
//        receiptRaw.isHidden = false
//        receiptScanned.isHidden = true
//        scanButton.isHidden = false
//        
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    @IBAction func scanReceipt(_ sender: Any) {
//        
//        receiptRaw.isHidden = true
//        receiptScanned.isHidden = false
//        scanButton.isHidden = true
//        self.navigationItem.title = "Select Items"
//    }
//    
//    @IBAction func scanFinished(_ sender: Any) {
//        
////        var items: [Item] = []
//        
//        
//        // HARD CODED FOR SAKE OF EXAMPLE - DELETE
//        
//        //Clears Items data to reset
//        Alamofire.request("https://split2-62ca2.firebaseio.com/items.json", method: .delete)
//        
//        
//        var singleItem = Item(name: "Cappuccino 355mL", price: 2.99)
//        
//        items.append(singleItem)
//        
//        singleItem = Item(name: "Black Label 340mL", price: 2.49)
//        items.append(singleItem)
//        
//        singleItem = Item(name: "Black Label Beer 340ML", price: 2.49)
//        items.append(singleItem)
//        
//        singleItem = Item(name: "Castle Lite 500mL", price: 2.49)
//        items.append(singleItem)
//        
//        singleItem = Item(name: "Bottle Water 1L", price: 1.25)
//        items.append(singleItem)
//        
//        singleItem = Item(name: "Chicken Malay Wrap", price: 5.75)
//        items.append(singleItem)
//        
//        singleItem = Item(name: "Dim Sum", price: 9.99)
//        items.append(singleItem)
//        
//        singleItem = Item(name: "Primi Breakfast Burrito", price: 8.00)
//        items.append(singleItem)
//        
//        singleItem = Item(name: "Wild Springbok Filet", price: 14.99)
//        items.append(singleItem)
//        
//        singleItem = Item(name: "Hot Pot Special", price: 12.49)
//        items.append(singleItem)
//        
//        singleItem = Item(name: "Roxy's Happy Hour Bucket", price: 4.61)
//        items.append(singleItem)
//        
//        singleItem = Item(name: "Roxy's Happy Hour Bucket", price: 4.61)
//        items.append(singleItem)
//        
//        singleItem = Item(name: "Roxy's Happy Hour Bucket", price: 4.61)
//        items.append(singleItem)
//        
//        
//        
//        // DELETE THE ENCAPSULATED CODE LATER
//        
//        
//        //Add all receipt items to firebase
//        for item in items {
//            Alamofire.request("https://split2-62ca2.firebaseio.com/items.json", method: .post, parameters: item.toJSON(), encoding: JSONEncoding.default).responseJSON(completionHandler: {response in
//                
//                switch response.result {
//                case .success:
//                    //                self.delegate?.didAddActivity(activity: activityDto!)
//                    //self.dismiss(animated: true, completion: nil)
//                    break
//                case .failure:
//                    // TODO: Display an error dialog
//                    break
//                }
//                
//            })
//        }
//        
//        
//        
//        
//        performSegue(withIdentifier: "navToGuests", sender: nil)
//    }
//    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

//}
