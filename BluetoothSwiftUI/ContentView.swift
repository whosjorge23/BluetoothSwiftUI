//
//  ContentView.swift
//  BluetoothSwiftUI
//
//  Created by Giorgio Giannotta on 04/02/23.
//

import SwiftUI
import CoreBluetooth

class BluetoothScanner: NSObject, ObservableObject{
    private var centralManager: CBCentralManager?
    private var peripherals: [CBPeripheral] = []
    @Published var peripharalNames: [String] = []
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
}

extension BluetoothScanner : CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            self.peripherals.append(peripheral)
            self.peripharalNames.append(peripheral.name ?? "Unnamed Device")
        }
    }
    
}

struct ContentView: View {
    @ObservedObject private var scanner = BluetoothScanner()
    
    var body: some View {
        VStack {
            Text("Bluetooth Devices")
                .font(.largeTitle)
                .padding()
            NavigationView {
                List(scanner.peripharalNames, id: \.self) { device in
                    Text(device)
                }
                .navigationTitle("Devices")
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
