//
//  MapViewController.swift
//  FastEat
//
//  Created by Danny LIP on 4/10/2018.
//  Copyright © 2018 Danny LIP. All rights reserved.
//

import UIKit
import GoogleMaps
import SnapKit
import GooglePlacesSearchController
import GooglePlaces

protocol SelectedLocationDelegate: class {
    func didTapUserAddress(userAddress: String)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var markerImageView: UIImageView!

    private var marker = GMSMarker()
    private var confirmLocation = ""

    weak var locationDelegate: SelectedLocationDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()

        LocationManager.shared.startUpdatingLocation()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateLocations), name: NotificationName.didUpdateLocations, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    @IBAction private func stopButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func confirmLocationButtonTapped(_ sender: Any) {
        locationDelegate.didTapUserAddress(userAddress: confirmLocation)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func autocompleteClicked(_ sender: Any) {

        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        
        let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.tracksViewChanges = true
        marker.position = position
        marker.iconView = markerImageView
        marker.map = mapView
        
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }

            self.confirmLocation = lines.joined(separator: "\n")
            print(lines.joined(separator: "\n"))
            
            self.marker.title = "\(self.confirmLocation)"
            self.mapView.selectedMarker = self.marker
        }
        
        let labelHeight = self.confirmButton.bounds.height + 15
        self.mapView.padding = UIEdgeInsetsMake(self.view.safeAreaInsets.top, 0, labelHeight, 0)
    }
    
    @objc private func didUpdateLocations(notification: Notification) {
        if let location = notification.userInfo?["location"] as? CLLocation {
            self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        }
        LocationManager.shared.stopUpdatingLocation()
    }
    
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        marker.tracksViewChanges = false
        reverseGeocodeCoordinate(position.target)
    }
    
}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        self.mapView.camera = camera
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
