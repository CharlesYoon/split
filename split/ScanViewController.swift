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
    var quantity: Int? = 0
    var nextQuantityFound: Bool = false
    var anyQuantityFound: Bool?
    var nextQuantity: Int?
    var currentItemName: String = ""
    var concatItemName: String = ""
    
    
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
                    
                //check if first letter is R (for Rand), and if so, try to remove then convert to double. If success, add price, otherwise add R back and continue
                } else {
                    //If first character is R (for rand), try to remove then convert to double.
                    let firstChar = currentBlock.paragraphs[i][k][0]
                    if firstChar == "R" {
                        
                        //remove R character from string
                        currentBlock.paragraphs[i][k].remove(at: currentItemName.startIndex) //remove quantity
                        
                        //try to convert new string to double, add as price if successful
                        if let priceDouble = currentBlock.paragraphs[i][k].doubleValue {
                            prices.append(priceDouble)
                            foundDouble = true
                            //sender.layer.borderColor = UIColor.cyan.cgColor
                            sender.backgroundColor = UIColor(red: 84/255, green: 136/255, blue: 138/255, alpha: 0.5)
                            
                        //if fails, then must not be a price, so add letter back in and continue
                        } else {
                            currentBlock.paragraphs[i][k].insert(firstChar, at: currentBlock.paragraphs[i][k].startIndex)
                        }
                        

                    }
                    
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
        //if not, it's likely a block that contains Items that the user tapped
        if foundDouble == false {
            
            //sender.layer.borderColor = UIColor.cyan.cgColor
            sender.backgroundColor = UIColor(red: 84/255, green: 136/255, blue: 138/255, alpha: 0.5)
            
            //loop through block to see if any quantities exist; even if a non-item got blocked with quantitied items
            for i in 0..<currentBlock.paragraphs.count {
                for k in 0..<currentBlock.paragraphs[i].count {
                    
                    if anyQuantityFound == nil {
                        let firstChar = String(currentBlock.paragraphs[i][k][0])
                        if firstChar.isInt == true {
                            
                            anyQuantityFound = true
                            
                            
                        }
                        
                    }
                    
                }
            }
            
            //for each item, assign it a price, add to items dictionary, and update priceAdded tracker
            for i in 0..<currentBlock.paragraphs.count {
                for k in 0..<currentBlock.paragraphs[i].count {
                    
                    currentItemName = currentBlock.paragraphs[i][k]
                    
                    
                    
                    //if the receipt has quantities, enter different logic to divide quantity and check for multi-line items
                    if anyQuantityFound == true {
                        let firstChar = String(currentItemName[0])
                        if firstChar.isInt == true {
                            
                            //If concatItemName has text, that means we found next item if first char is integer
                            if concatItemName != "" {
                                
                                nextQuantityFound = true
                                
                                nextQuantity = Int(firstChar)!
                                
                                //remove quantity character and space from string
                                currentItemName.remove(at: currentItemName.startIndex) //remove quantity
                                currentItemName.remove(at: currentItemName.startIndex) //remove space
                                
                                

                            //concatItemName string is empty, so add start new Item string
                            } else {
                                quantity = Int(firstChar)!
                                
                                // Integer found means start of new item so clear concat string
                                concatItemName = ""
                                
                                //If quantity is first char, start of new item, so reset nextQuantityFound
                                nextQuantityFound = false
                                
                                //remove quantity character and space from string
                                currentItemName.remove(at: currentItemName.startIndex) //remove quantity
                                currentItemName.remove(at: currentItemName.startIndex) //remove space
                                
                                
                                concatItemName = currentItemName
                            }
                            
                        //if line doesn't have quantity, either non-item or multi-line item
                        } else {
                            
                            //if the items have quantities, and items[] is empty, but this line doesn't have a quantity, assume it's a non-item that's blocked in with the items so skip until you find the first line with a quantity which is likely first true item
                            if items.count == 0 {
                                continue
                            } else {
                                concatItemName += " \(currentItemName)"
                            }
                        }
                        
                        //if next quantity has been found, add current item, and reset variables
                        if nextQuantityFound == true {
                            
                            //make sure prices index is in scope, if not, exit
                            if nextPriceIndexToAdd < prices.count {
                                //if item is not free (discard/skip if it is), assign price to item
                                if prices[nextPriceIndexToAdd] != 0.0 {
                                    
                                    //Calculate unit price depending on quantity count
                                    let priceToAdd = prices[nextPriceIndexToAdd]/Double(quantity!)
                                    
                                    //Add as many items as quantity is set to. If quantity=2, add 2 items with price = price/2
                                    for _ in 0..<quantity! {
                                        items.append(Item(name: concatItemName, price: priceToAdd, itemID: String(counter)))
                                        counter += 1
                                    }
                                    
                                    //if no quantities are listed on receipt, just add it
                                    
                                }
                                nextPriceIndexToAdd += 1
                                
                                quantity = nextQuantity
                                concatItemName = currentItemName
                                nextQuantityFound = false
                            }

                        }
                        
                        
                    //if no quantity found, add items one line at a time normally
                    } else {
                        
                        //make sure prices index is in scope, if not, exit
                        if nextPriceIndexToAdd < prices.count {
                            //if item is not free (discard/skip if it is), assign price to item
                            if prices[nextPriceIndexToAdd] != 0.0 {
                                    
                                    let priceToAdd = prices[nextPriceIndexToAdd]
                                
                                    items.append(Item(name: currentBlock.paragraphs[i][k], price: priceToAdd, itemID: String(counter)))
                                
                                    counter += 1
                                
                                    //if no quantities are listed on receipt, just add it
                            }
                            nextPriceIndexToAdd += 1
                        }

                    }
                }
            }
        }
        
        //Add last item since loop ends before last item is added bc items are added once the next new item is found so since there's no next item for the last, loop exits without adding
        if anyQuantityFound == true {
            
            //make sure prices index is in scope, if not, exit
            if nextPriceIndexToAdd < prices.count {
                //if item is not free (discard/skip if it is), assign price to item
                if prices[nextPriceIndexToAdd] != 0.0 {
                    
                    //Calculate unit price depending on quantity count
                    let priceToAdd = prices[nextPriceIndexToAdd]/Double(quantity!)
                    
                    //Add as many items as quantity is set to. If quantity=2, add 2 items with price = price/2
                    for _ in 0..<quantity! {
                        items.append(Item(name: concatItemName, price: priceToAdd, itemID: String(counter)))
                        counter += 1
                    }
                }
                nextPriceIndexToAdd += 1
                
                quantity = nextQuantity
                concatItemName = currentItemName
                nextQuantityFound = false
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
        
        //let pricesWithoutZero = prices.filter{$0 != 0.0}.count
        
        let pricesSum = prices.reduce(0, +)
        
        //check if all prices are accounted for in items[]
        if itemSum != pricesSum {
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
