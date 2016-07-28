//
//  ChatViewController.swift
//  ServiceChat
//
//  Created by Owner on 2016. 7. 24..
//  Copyright © 2016년 TwistWorld. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import FirebaseDatabase

class ChatViewController: JSQMessagesViewController {

    var messages = [JSQMessage]()
    
    @IBAction func logoutDidTapped(sender: AnyObject) {
        // Create a main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // From main storyboard instantiate a View controller
        let logInVC = storyboard.instantiateViewControllerWithIdentifier("LogInVC") as! LogInViewController
        
        // Get the app delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Set Navigation Controller as root view controller
        appDelegate.window?.rootViewController = logInVC
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        collectionView.reloadData()
        print(messages)
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        self.presentViewController(imagePicker, animated: true, completion: nil)
        print("Did press accessory Button")
        let sheet = UIAlertController(title: "Media Messages", message: "Please select a media", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert:UIAlertAction) in
            
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (alert:UIAlertAction) in
            self.getMediaFrom(kUTTypeImage)
        }
        let videoLibrary = UIAlertAction(title: "Video Library", style: UIAlertActionStyle.Default) { (alert:UIAlertAction) in
            self.getMediaFrom(kUTTypeMovie)
        }
        sheet.addAction(photoLibrary)
        sheet.addAction(videoLibrary)
        sheet.addAction(cancel)
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    
    func getMediaFrom(type: CFString) {
        print(type)
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.mediaTypes = [type as String]
        self.presentViewController(mediaPicker, animated: true, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(messages.count)
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        return bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.blueColor())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        print("didTapMessageBubble")
        let message = messages[indexPath.item]
        if message.isMediaMessage {
            if let mediaItem = message.media as? JSQVideoMediaItem {
                let player = AVPlayer(URL: mediaItem.fileURL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.presentViewController(playerViewController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = "I"
        self.senderDisplayName = "Nerd"
        
        let roofRef = FIRDatabase.database().reference()
        let messageRef = roofRef.child("messages")
        print(roofRef)
        print(messageRef)
//        messageRef.childByAutoId().setValue("first message")
//        messageRef.childByAutoId().setValue("second meesage")
        
//        messageRef.observeEventType(FIRDataEventType.Value) { (snapshot: FIRDataSnapshot) in
//            print("test")
//            if let dict = snapshot.value as? NSDictionary {
//                print(dict)
//            }
//        }
    }
    
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let photo = JSQPhotoMediaItem(image: picture)
            messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photo))

        } else {
            if let video = info[UIImagePickerControllerMediaURL] as? NSURL {
                let videoItem = JSQVideoMediaItem(fileURL: video, isReadyToPlay: true)
                messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: videoItem))
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        collectionView.reloadData()
    }
}
