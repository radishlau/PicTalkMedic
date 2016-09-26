//
//  UtterColelctionView.swift
//  PicTalkMedic
//
//  Created by Pak on 02/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

class MessageColelctionView:  PicTalkCollectionView  {
    var questionMarkItem:DataItem {
        get{
          
            switch sharedParams.selectedLang{
            case .swedish:
                return DataItem(swedish: "?", arabic: "⸮", picName: "questionMark", parent: nil, child: nil)
            case .arabic:
                return DataItem(swedish: "?", arabic: "⸮", picName: "questionMarkReversed", parent: nil, child: nil)
            default:
                  return DataItem(swedish: "?", arabic: "⸮", picName: "questionMark", parent: nil, child: nil)
            }
            
        }
    }
    
    var isQuestion = false {
        willSet(newValue) {
            if (newValue){
               
                dataItems.append(questionMarkItem)
            }else{
                //print("false")
                if (dataItems.count > 0){
                    dataItems.removeLast()
                }
                
            }
        }
        
    }
    
    weak var messageDataDelegate:  MessageDataDelegate?
   // var sharedParams: SharedParams!
    
    
    func didSwipe(_ recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.ended {
            //print("swipe ended msg")
        }
    }
    
   
    
    override var dataItems:[DataItem] {
        didSet{
            //print("In dataItems, getMessageText():",getMessageText())
            messageDataDelegate?.updateMessageDisplay(getMessageText(lang:sharedParams.selectedLang))
        }
    }
    
    func reverseDataItems(){
        dataItems = dataItems.reversed()
        //print("data is reversed")
    }
    
    func addItem(_ item:DataItem){
      
        if (isQuestion){
            // remove ?
            if (dataItems.count > 0){
                 dataItems.removeLast()
            }
            dataItems.append(item)
            dataItems.append(questionMarkItem)
        }else{
             dataItems.append(item)
        }
        
    }
    
    func getMessageText(lang:Language) -> String{
        var text = ""
        for item in dataItems {
            //print(" item is ", item.swedish )
            switch lang{
            case .swedish:
                text += item.swedish! + "   /   "
            case .arabic:
                 text += item.arabic! + "   /   "
            default:
                break
            }
        }
        //print("getMessageText: ",text)
        return text
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MsgCell", for: indexPath) as! MessageCollectionViewCell
        
        // Configure the cell
        
        switch sharedParams.selectedLang{
        case .arabic:
            // reverse the pic
            let maxIndex = dataItems.count - 1
            cell.imageView.image = dataItems[maxIndex - (indexPath as NSIndexPath).item].pic
            
            // handle question mark
            if ( indexPath.item == 0 && isQuestion ){
                print(" this is ?")
                cell.imageView.image = questionMarkItem.pic
            }
        case .swedish:
           cell.imageView.image = dataItems[(indexPath as NSIndexPath).item].pic
            
           // handle question mark
           if ( indexPath.item == dataItems.count-1 && isQuestion  ){
            print(" this is ?")
            cell.imageView.image = questionMarkItem.pic
            }
        default:
            break
        }
        
        
        
        return cell
    }
    
}
