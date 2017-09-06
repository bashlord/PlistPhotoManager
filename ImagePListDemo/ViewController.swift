//
//  ViewController.swift
//  ImagePListDemo
//
//  Created by John Jin Woong Kim on 9/3/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,  UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    var imageView0: UIImageView!
    var subview: UILabel!
    var deleteButton: UIButton!
    
    var addButton: UIButton!
    
    var subHeight:CGFloat = 0
    var subLimit:CGFloat = 0
    
    var recognizer:UIGestureRecognizer!
    var recognizer1:UIGestureRecognizer!

    var keyFrame:CGRect!
    //var imageView1: UIImageView!
    
    var imageUploaded:UIImage!
    
    var createdPhotos = CreatedPhotosManager()
    
    // views for adding key/values to an image
    var valView:UIView!
    var pickerView: UIPickerView!
    var pathTextView:UITextView!
    var textView: UITextView!
    var valTextView:UITextView!
    var cancelButton: UIButton!
    var checkButton:UIButton!
    var plusButton:UIButton!
    var dictCache:NSMutableDictionary!
    var pickerNames = ["String", "Int"]
    
    var tempString:String = ""
    var tempPathStringString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.automaticallyAdjustsScrollViewInsets = false
        keyFrame = UIApplication.shared.keyWindow?.frame
        setupImageViews()
        setupCollectionView()

        setupDictViews()
        collectionView?.reloadData()
        print(collectionView?.numberOfItems(inSection: 0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("ViewdidAppear() collectionviewcells", collectionView?.numberOfItems(inSection: 0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func onAddButton(sender:UIButton){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageUploaded = image
        dismiss(animated:true, completion: {
            print("imagePicker finished")
            if self.imageUploaded == nil{
                print("  no image cached")
                // if nil, dismiss and continue where you left off
            }else{
                print("  image cached")
                //  From here, need to make an editor for the cached image
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                self.valView.frame.origin.x = 0
                self.resetTextViews()
                self.dictCache = NSMutableDictionary()
                    }) { (completed: Bool) in }
            }
        })
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func onImageViewTapped(sender: UIGestureRecognizer){
        
        if imageView0.image != nil{
            
            
                if sender == self.recognizer{
                    

                    UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                        self.subview.text = self.tempString
                    //self.subview.frame.size.height = self.subLimit
                    
                    }) { (completed: Bool) in
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                        self.subview.frame.size.height = self.subLimit
                        self.deleteButton.frame.origin.x = self.keyFrame.width-60
                        }) { (completed: Bool) in}
                    }


                }else{
                        UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                    self.subview.frame.size.height = 0
                    self.deleteButton.frame.origin.x = self.keyFrame.width
                    self.subview.text = ""
                        }) { (completed: Bool) in }

                    
                }
        }
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.subview.text = ""
        self.subview.frame.size.height = 0
        self.deleteButton.frame.origin.x = self.keyFrame.width
        
        print("Cell at indexPath ", indexPath.item, " selected!")
        print("cell's dict", createdPhotos.photos[indexPath.item].dictionary.description)
        imageView0.image = createdPhotos.photos[indexPath.item].orgImage
        tempPathStringString = createdPhotos.photos[indexPath.item].path
        tempString = tempPathStringString + "\n" + createdPhotos.photos[indexPath.item].dictionary.description
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return createdPhotos.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cell being returned")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AnnotatedPhotoCell
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 30
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.white.cgColor
        cell.imageView.contentMode = .scaleAspectFill
        cell.image = createdPhotos.photos[indexPath.item].orgImage
 
        
        //cell.imageView.image = createdPhotos.photos[indexPath.item].orgImage
        //cell.setupViews()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    
    ///////////////////////////////////////////////////////////////
    // PICKERVIEW FOR CHOOSING THE VALUE TYPE FOR THESE DAMN KEY-VAL PAIRINGS
    //     WHY IS THERE SO MUCH TO CODE FOR A SIMPLE DEMO OMG
    ////////////////////////////////////////////////////////////////////
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0{
            print("String picked in pickerview")
        }else{
            print("Int picked in pickeview")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.text = pickerNames[row]
        return label
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /////////////////////////////////////////
    // textView delegate stuffs
    ///////////////////////////////////
    func textViewDidBeginEditing(_ textView: UITextView) {
        plusButton.isUserInteractionEnabled = false
        if textView == self.pathTextView{
            if textView.text == "Pathname"{
                textView.textColor = UIColor.black
                textView.text = ""
            }
        }else if textView == self.textView{
            if textView.text == "Key"{
                textView.textColor = UIColor.black
                textView.text = ""
            }
        }else{
            if self.valTextView.text == "Value"{
                textView.textColor = UIColor.black
                textView.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.pathTextView{
            if textView.text == ""{
                textView.textColor = UIColor.lightGray
                textView.text = "Pathname"
            }
        }else if textView == self.textView{
            if textView.text == ""{
                textView.textColor = UIColor.lightGray
                textView.text = "Key"
            }
        }else{
            if self.valTextView.text == ""{
                textView.textColor = UIColor.lightGray
                textView.text = "Value"
            }
        }
        
        plusButton.isUserInteractionEnabled = true
    }
    
    /////////////
    
    
    func onValButtonPressed(sender:UIButton){
    
        if sender == plusButton{
            if textView.text != "" && self.valTextView.text != "" && textViewsEmpty(){
                if pickerView.selectedRow(inComponent: 0) == 0{
                    dictCache[textView.text] = self.valTextView.text
                }else{
                    dictCache[textView.text] = Int(self.valTextView.text)
                }
                
                textView.textColor = UIColor.lightGray
                textView.text = "Key"
                valTextView.textColor = UIColor.lightGray
                valTextView.text = "Value"
                
            }
        }else if sender == cancelButton{
            textView.text = ""
            dictCache = NSMutableDictionary()
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.valView.frame.origin.x = self.keyFrame.width
                 }) { (completed: Bool) in }
            
        }else if sender == checkButton{
            if pathTextView.textColor != UIColor.lightGray && pathTextView.text != "Pathname"{
            
                createdPhotos.addNewCreated(path: pathTextView.text, image: imageUploaded, dic: dictCache)
                collectionView?.reloadData()

                dictCache = NSMutableDictionary()
                resetTextViews()
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                    self.valView.frame.origin.x = self.keyFrame.width
                }) { (completed: Bool) in }
            }

        }
    }
    
    func textViewsEmpty()->Bool{
        if textView.textColor != UIColor.lightGray && valTextView.textColor != UIColor.lightGray && pathTextView.textColor != UIColor.lightGray &&
            textView.text != "Key" && valTextView.text != "Value" && pathTextView.text != "Pathname"{
            return true
        }else{
            return false
        }
    }
    
    func resetTextViews(){
            pathTextView.textColor = UIColor.lightGray
            pathTextView.text = "Pathname"

            textView.textColor = UIColor.lightGray
            textView.text = "Key"

            valTextView.textColor = UIColor.lightGray
            valTextView.text = "Value"
    }
    
    func onDelet(sender: UIButton){
        
        createdPhotos.removeCreated(path: tempPathStringString)
        tempPathStringString = ""
        tempString = ""
        self.subview.frame.size.height = 0
        self.deleteButton.frame.origin.x = self.keyFrame.width
        self.subview.text = ""
        self.imageView0.image = nil
        self.collectionView?.reloadData()
    }
    
    ////////////////////////////////////////
    //// SET UP VIEW STUFF SDIGNVWEOFNQEWL
    ///////////////////////////////////////
    
    
    
    func setupDictViews(){
        valView = UIView()
        valView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor.white
        pickerView.layer.cornerRadius = 10
        pickerView.layer.borderWidth = 1
        pickerView.layer.borderColor = UIColor.black.cgColor
        pickerView.dataSource = self
        pickerView.delegate = self
        pathTextView = UITextView()
        pathTextView.layer.cornerRadius = 10
        pathTextView.layer.borderWidth = 1
        pathTextView.layer.borderColor = UIColor.black.cgColor
        pathTextView.textAlignment = .center
        
        textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.textAlignment = .center
        valTextView = UITextView()
        valTextView.layer.cornerRadius = 10
        valTextView.layer.borderWidth = 1
        valTextView.layer.borderColor = UIColor.black.cgColor
        valTextView.textAlignment = .center
        cancelButton = UIButton()
        checkButton = UIButton()
        plusButton = UIButton()
        plusButton.imageView?.contentMode = .scaleAspectFit
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.black.cgColor
        checkButton.layer.cornerRadius = 10
        checkButton.layer.borderWidth = 1
        checkButton.layer.borderColor = UIColor.black.cgColor
        
        plusButton.layer.cornerRadius = 10
        plusButton.layer.borderWidth = 1
        plusButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.imageView?.contentMode = .scaleAspectFit
        checkButton.imageView?.contentMode = .scaleAspectFit
        cancelButton.setImage(UIImage(imageLiteralResourceName: "delete-trans"), for: .normal)
        checkButton.setImage(UIImage(imageLiteralResourceName: "save-trans1"), for: .normal)
        plusButton.setImage(UIImage(imageLiteralResourceName: "plus"), for: .normal)
        plusButton.backgroundColor = UIColor.white
        cancelButton.backgroundColor = UIColor.white
        checkButton.backgroundColor = UIColor.white
        valView.frame = CGRect(x: keyFrame.width, y: keyFrame.origin.y, width: keyFrame.width, height:keyFrame.height)
        view.addSubview(valView)
        
        valView.addSubview(pathTextView)
        valView.addSubview(pickerView)
        valView.addSubview(textView)
        valView.addSubview(valTextView)
        valView.addSubview(checkButton)
        valView.addSubview(cancelButton)
        valView.addSubview(plusButton)
        
        textView.delegate = self
        valTextView.delegate = self
        pathTextView.delegate = self
        
        plusButton.addTarget(self, action: #selector(onValButtonPressed(sender:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(onValButtonPressed(sender:)), for: .touchUpInside)
        checkButton.addTarget(self, action: #selector(onValButtonPressed(sender:)), for: .touchUpInside)
        
        valView.addConstraintsWithFormat("H:|-50-[v0]-50-|", views: pickerView)
        valView.addConstraintsWithFormat("H:|-50-[v0]-50-|", views: textView)
        valView.addConstraintsWithFormat("H:|-50-[v0]-50-|", views: pathTextView)
        valView.addConstraintsWithFormat("H:|-50-[v0]-50-|", views: valTextView)
        valView.addConstraintsWithFormat("H:|-100-[v0]-100-|", views: plusButton)
        valView.addConstraintsWithFormat("V:|-50-[v0(\(50))]-10-[v1(\(50))]-10-[v2(\(50))]-20-[v3(\(75))]-10-[v4(\(50))]", views: pathTextView, textView,valTextView, pickerView, plusButton)
        
        valView.addConstraintsWithFormat("H:|[v0][v1]|", views: cancelButton,checkButton)
        valView.addConstraintsWithFormat("V:[v0(\(60))]|", views: cancelButton )
        valView.addConstraintsWithFormat("V:[v0(\(60))]|", views: checkButton )
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.valView.addGestureRecognizer(tap)
        
    }
    
    func setupImageViews(){
        
        imageView0 = UIImageView()
        subview = UILabel()
        subview.numberOfLines = 0
        subview.font = UIFont.boldSystemFont(ofSize: 20)
        subview.textColor = UIColor.white
        subview.textAlignment = .center
        deleteButton = UIButton()
        deleteButton.addTarget(self, action: #selector(onDelet(sender:)), for: .touchUpInside)
        imageView0.backgroundColor = UIColor.white
        subview.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        view.addSubview(imageView0)
        view.addConstraintsWithFormat("H:|[v0]|", views: imageView0)
        view.addConstraintsWithFormat("V:|[v0]-60-|", views: imageView0)
        view.addSubview(subview)
        view.addConstraintsWithFormat("H:|[v0]|", views: subview)
        view.addConstraintsWithFormat("V:|[v0]", views: subview)
        
        imageView0.contentMode = .scaleAspectFit
        imageView0.isUserInteractionEnabled = true
        subview.isUserInteractionEnabled = true
        recognizer = UITapGestureRecognizer.init(target: self, action: #selector(onImageViewTapped(sender: )))
        recognizer.delegate = self
        imageView0.addGestureRecognizer(recognizer)
        recognizer1 = UITapGestureRecognizer.init(target: self, action: #selector(onImageViewTapped(sender: )))
        recognizer1.delegate = self
        subview.addGestureRecognizer(recognizer1)
        
        deleteButton.setImage(UIImage(imageLiteralResourceName: "delete-trans").withRenderingMode(.alwaysTemplate), for: .normal)
        deleteButton.tintColor = UIColor.black
        //deleteButton.frame.size = CGSize(width: 0, height: 0)
        deleteButton.frame = CGRect(x: keyFrame.width, y: 20, width: 60, height: 60)
        view.addSubview(deleteButton)
        
        //imageView1 = UIImageView()
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            print("FLOW LAYOUT")
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }else{
            print("NO FLOW LAYOUT FOR YOU")
        }
        
        
        collectionView?.layer.cornerRadius = 1
        collectionView?.layer.borderWidth = 2
        collectionView?.layer.borderColor = UIColor.gray.cgColor
        collectionView?.backgroundColor = UIColor.black
        // Register PinCell, which is technically a UICollectionViewCell that is
        //  the size of the screen (or in this case, the size of the screen minus the
        //  top navigation bar height).  In this big a** cell contains a UIView which then
        //  contains another UICollectionView, which in this case follows the PinterestLayout
        //  look and has all the meme blank templates
        
        collectionView?.register(AnnotatedPhotoCell.self, forCellWithReuseIdentifier: "cell")
        
        subLimit = (keyFrame?.height)!-60
        //collectionView?.contentInset = UIEdgeInsetsMake(keyFrame.height-60, 0, 0, 0)
        //collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(keyFrame.height-60, 0, 0, 0)
        
        collectionView?.isPagingEnabled = true

        
        addButton = UIButton()
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.lightGray.cgColor
        addButton.setImage(UIImage(imageLiteralResourceName: "plus"), for: .normal)
        addButton.backgroundColor = UIColor.white
        addButton.addTarget(self, action: #selector(onAddButton(sender:)), for: .touchUpInside)
        view.addSubview(addButton)
        //view.addConstraintsWithFormat("H:|[v0(\(keyFrame.width-60))][v1(\(60))]|", views: collectionView!,addButton)
        view.addConstraintsWithFormat("H:[v0(\(60))]|", views:addButton)
        view.addConstraintsWithFormat("V:[v0(\(60))]|", views: addButton)
        collectionView?.frame = CGRect(x: 0, y: keyFrame.height-60, width: keyFrame.width-60, height: 60)
        //view.addConstraintsWithFormat("V:[v0(\(60))]|", views: collectionView!)
    }
}

