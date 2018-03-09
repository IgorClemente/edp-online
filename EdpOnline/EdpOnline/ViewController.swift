//
//  ViewController.swift
//  EdpOnline
//
//  Created by MACBOOK AIR on 22/09/17.
//  Copyright © 2017 MACBOOK AIR. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
import UserNotifications

class ViewController: UIViewController,UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate {
    
    @IBOutlet weak var uiProfilePhoto: UIImageView?
    @IBOutlet weak var uiPoints: UILabel?
    @IBOutlet weak var uiLocality: UILabel?
    @IBOutlet weak var uiFullName: UILabel?
    @IBOutlet weak var tableSubMenuArvores: UITableView?
    @IBOutlet weak var uiSubMenuMap: UIView?
    @IBOutlet weak var uiProgressBarUpload: UIProgressView?
    @IBOutlet weak var uiMapRegionMain: MKMapView?
    
    @IBOutlet var uiButtonsSubMenu: [UIBarButtonItem]?
    @IBOutlet var uiStarsBarBottom: [UIImageView]?
    
    // MARK: managerLocation - geocoder
    let locationManagerUser = CLLocationManager()
    let geocoder            = CLGeocoder()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let progress = self.uiProgressBarUpload else {
              return
        }
        
        progress.setProgress(0.0, animated: true)
        progress.isHidden = true
        
        if let stars = self.uiStarsBarBottom {
           for s in 0..<stars.count {
               let star = stars[s]
               if (0..<App.shared.amountOfStars).contains(s) {
                  star.image = UIImage(named:"star")
               }else{
                  star.image = UIImage(named:"star-disabled")
               }
           }
        }
        
        App.shared.getUserLogged { (user) in
           guard let u = user else {
               return
           }
           self.loadInformation(forUser: u)
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name("update-map"),
            object: nil, queue: OperationQueue.main) { _ in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
                self.saveUserInfo()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let buttons = uiButtonsSubMenu,
              let treesTable = tableSubMenuArvores,
              let treesMap = uiSubMenuMap
            else {
            return
        }
        
        for button in buttons {
            guard let titleButton = button.title
                else {
                return
            }
            
            if titleButton == "submenuMapa" {
               button.tintColor = UIColor.gray
               treesTable.isHidden = false
               treesMap.isHidden = true
            }
        }
        self.saveUserInfo()
    }
    
    func saveUserInfo() -> Void {
        App.shared.saveUser { (save) in
           if save {
            App.shared.getUserLogged({ (user) in
               guard let u = user else {
                   return
               }
               self.loadInformation(forUser: u)
            })
            
            self.searchLocation()
            DispatchQueue.main.async {
                self.tableSubMenuArvores?.reloadData()
            }
           }else{
              let alertError = UIAlertController(title: "Error ao salvar", message: "Ocorreu um erro ao salvar as informações do usuário", preferredStyle: .alert)
              let alertErrorAction = UIAlertAction(title: "OK", style: .default, handler: nil)
              alertError.addAction(alertErrorAction)
              self.present(alertError, animated: true, completion: nil)
           }
        }
    }
    
    func loadInformation(forUser u:User) -> Void {
        DispatchQueue.main.async {
           self.uiFullName?.text = "\(u.first_name) \(u.last_name)"
           self.uiLocality?.text = "\(u.locality),\(u.uf)"
           self.uiPoints?.text   = "\(u.points)"
        }
    }
    
    @IBAction func uiTapAbreMenuPrincipal() {
        ControllerSideMenu.controller.createMainMenu(self)
    }
    
    @IBAction func tapSubMenu(_ sender: UIBarButtonItem) {
        guard let botoes  = uiButtonsSubMenu,
              let viewSubMapa   = uiSubMenuMap,
              let viewSubArvore = tableSubMenuArvores
            else {
            return
        }
        
        if let titulo = sender.title {
           switch titulo {
             case "submenuMapa":
               UIView.animate(withDuration: 0.1,animations: {
                     viewSubMapa.alpha    = 1.0
               }){ _ in viewSubMapa.isHidden = false }

                 for botao in botoes {
                    if botao.title == "submenuArvores" {
                       UIView.animate(withDuration: 0.2, animations: {
                             viewSubArvore.alpha = 0.0
                       }){ _ in botao.tintColor = UIColor.gray
                                viewSubArvore.isHidden = true }
                    }else{
                       botao.tintColor = UIColor.white
                    }
                 }
            
             case "submenuArvores":
               UIView.animate(withDuration: 0.1, animations: {
                     viewSubArvore.alpha    = 1.0
               }){ _ in viewSubArvore.isHidden = false }
             
                 for botao in botoes {
                    if botao.title == "submenuMapa" {
                       UIView.animate(withDuration: 0.2, animations: {
                             viewSubMapa.alpha = 0.0
                       }){ _ in botao.tintColor = UIColor.gray
                                viewSubMapa.isHidden = true }
                    }else{
                       botao.tintColor = UIColor.white
                    }
                 }
             default:
                 break
           }
        }
    }
    
    @IBAction func tapTiraFoto() {
        self.tirarFoto()
    }
    
    func tirarFoto() -> Void {
        if UIImagePickerController.isSourceTypeAvailable(
           UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        DispatchQueue.global().async {
            guard let imagePicked = info[UIImagePickerControllerOriginalImage]
                as? UIImage else {
                return
            }
            UIImageWriteToSavedPhotosAlbum(imagePicked, nil, nil, nil)
            
            let sucessAlert = UIAlertController(
                title:"Enviar imagem", message:"Digite um título para essa imagem", preferredStyle: .alert)

            let cancelSucessAlert  = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            let confirmSucessAlert = UIAlertAction(title: "Enviar", style: .default, handler:
                { (_) in
                  guard let fields = sucessAlert.textFields,
                        let confirmField  = fields[0].text
                        else {
                        return
                  }
    
                  let titleForImage = confirmField
                  self.uploadImage(imagePicked,and: titleForImage)
            })
            
            sucessAlert.addTextField(configurationHandler: { (field) in
                field.placeholder   = "Título da imagem"
                field.textAlignment = .center
                field.returnKeyType = .send
                field.autocorrectionType = .yes
                field.spellCheckingType  = .yes
                field.autocapitalizationType = .words
                field.enablesReturnKeyAutomatically = true
            })
            
            sucessAlert.addAction(cancelSucessAlert)
            sucessAlert.addAction(confirmSucessAlert)
            DispatchQueue.main.async {
               self.present(sucessAlert, animated: true, completion: nil)
            }
        }
    }
    
    func uploadImage(_ image:UIImage, and title:String) {
        guard let remote = URL(string:"https://inovatend.mybluemix.net/upload"),
              let imageData   = UIImagePNGRepresentation(image),
              let progressBar = self.uiProgressBarUpload,
              let photoLocation = App.shared.photoLocation?.addressDictionary
            else {
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy:MM:dd'T'HH:mm:ss'Z'"
        
        let currentLocation = App.shared.currentLocation
        let datePicturePhoto = formatter.string(from: Date ())
        
        guard let longitude = currentLocation?.longitude.description,
              let latitude  = currentLocation?.latitude.description,
              let longitudeData = longitude.data(using: String.Encoding.utf8),
              let latitudeData  = latitude.data(using: String.Encoding.utf8),
              let location  = PhotoLocation(forInformation: photoLocation),
              let titleData = title.data(using: String.Encoding.utf8),
              let locationStreetData = location.street.data(using: String.Encoding.utf8),
              let locationStateData  = location.state.data(using: String.Encoding.utf8),
              let locationCityData   = location.city.data(using: String.Encoding.utf8),
              let locationSubLocData = location.subLocality.data(using: String.Encoding.utf8),
              let datePicturePhotoData = datePicturePhoto.data(using: String.Encoding.utf8)
            else {
            return
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "sampleFile",fileName: "sampleFile.png", mimeType: "image/png")
            multipartFormData.append(longitudeData, withName: "longitude")
            multipartFormData.append(latitudeData, withName: "latitude")
            multipartFormData.append(titleData, withName: "title")
            multipartFormData.append(locationStreetData, withName: "street")
            multipartFormData.append(locationStateData, withName: "state")
            multipartFormData.append(locationCityData, withName: "city")
            multipartFormData.append(locationSubLocData, withName: "sublocality")
            multipartFormData.append(datePicturePhotoData, withName: "datePhoto")
        },
        to: remote)
        { (result) in
           switch result {
            case .success(let upload, _, _):
              progressBar.isHidden = false
              upload.uploadProgress(closure: { (progress) in
                 print("Upload Progress: \(progress.fractionCompleted)")
                 progressBar.setProgress(Float(progress.fractionCompleted), animated: true)
              })
                
              upload.responseJSON { response in
                 progressBar.isHidden = true
                 progressBar.setProgress(0.0, animated: false)
                 UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                 // MARK: Notification End Progress - BackgroundMode
                 DispatchQueue.main.async {
                   if UIApplication.shared.applicationState == .background {
                      let contentNotification   = UNMutableNotificationContent()
                      contentNotification.body  = "Imagem enviada com sucesso"
                      contentNotification.title = "Envio de Imagem"
                            
                      let notificationProgress = UNNotificationRequest(identifier: "upload", content: contentNotification, trigger: nil)
                      UNUserNotificationCenter.current().add(notificationProgress, withCompletionHandler: nil)
                   }
                 }
                 NotificationCenter.default.post(name: NSNotification.Name("update-map") , object: nil)
              }
            case .failure(let encodingError):
                print(encodingError)
           }
        }
    }
}


extension ViewController : CLLocationManagerDelegate {
    
    func preparePinsUpdate() -> Void {
        self.uiMapRegionMain?.removeAnnotations(uiMapRegionMain?.annotations ?? [])
        if let locationUser = App.shared.currentLocation {
           let pinUser  = TreeAnnotation(forLocation: locationUser)
           self.uiMapRegionMain?.addAnnotation(pinUser)
        }
        
        if let trees = App.shared.retrieveInformationTrees() {
           trees.forEach({ (tree) in
              if let locationTree = tree.location {
                 let pinTree = TreeAnnotation(forLocation: locationTree)
                 self.uiMapRegionMain?.addAnnotation(pinTree)
              }
           })
        }
    }
    
    func updateMap(infoPlaceMark info:CLPlacemark) -> Void {
        guard let location = info.location else {
            return
        }
        
        let regionSize = MKCoordinateSpanMake(0.001,0.001)
        let region     = MKCoordinateRegionMake(location.coordinate, regionSize)
        
        self.preparePinsUpdate()
        self.uiMapRegionMain?.setRegion(region, animated: true)
    }
    
    func searchLocation() {
        switch CLLocationManager.authorizationStatus() {
          case .authorizedAlways, .authorizedWhenInUse:
            locationManagerUser.delegate        = self
            locationManagerUser.desiredAccuracy = kCLLocationAccuracyBest
            locationManagerUser.startUpdatingLocation()
          case .notDetermined:
            requestLocationPermission()
          default:
            break
        }
    }
    
    func requestLocationPermission() -> Void {
        if CLLocationManager.locationServicesEnabled() {
            locationManagerUser.delegate = self
            locationManagerUser.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                        didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        
        locationManagerUser.stopUpdatingLocation()
        geocoder.reverseGeocodeLocation(lastLocation) {
            (locations, error) in
            if let locationFirst = locations?.first,
               let location = locationFirst.location {
               App.shared.currentLocation = location.coordinate
               App.shared.photoLocation   = locationFirst
               self.updateMap(infoPlaceMark: locationFirst)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
          case .authorizedAlways, .authorizedWhenInUse:
            self.searchLocation()
          default:
            break
        }
    }
}

extension ViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let location = annotation as? TreeAnnotation {
           return self.uiMapRegionMain?.dequeueReusableAnnotationView(
           withIdentifier: location.identifier) ?? location.viewTreeAnnotation()
        }else{
           return nil
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return App.shared.amountOfTrees
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let treesIdentifiers = App.shared.trees_numbers
        
        guard let cellTree = tableView.dequeueReusableCell(withIdentifier: "tree")  as? TreeTableViewCell,
              let identifiers = treesIdentifiers else {
              return UITableViewCell()
        }
        
        let identifier   = identifiers[indexPath.row]
        let cellInfoURL  = "https://inovatend.mybluemix.net/imagens/arvore/\(identifier)"
        let cellImageURL = "https://inovatend.mybluemix.net/imagens/\(identifier)"
           
        cellTree.useCell = true
        cellTree.treeImage?.url = URL(string: cellImageURL)
        cellTree.url     = URL(string: cellInfoURL)
         
        return cellTree
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->  CGFloat {
       return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sender = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "tree", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? TreeDetailsControllerView,
              let sender = sender as? TreeTableViewCell
            else {
            return
        }
        controller.information = sender
    }
    
    @IBAction func exit(segue:UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
    }
}

