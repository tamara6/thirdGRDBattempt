//
//  AppDelegate.swift
//  firstGRDBattempt
//
//  Created by Tamara Snyder on 1/3/20.
//  Copyright © 2020 Tamara Snyder. All rights reserved.
//

import Cocoa
import GRDB

// The shared database queue
   var dbQueue: DatabaseQueue!
   //this ! seems to mean that it is an implicitly unwrapped optional
   //Sometimes you’ve created a struct or a class, and some of its properties are nil before initializing the class, but will never be nil after.
var dbRows: [Row] = []




@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

   


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        print("in AppDelegate: try to set up database")
        try! setupDatabase()
    }
    
   /*
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        try! setupDatabase(application)
        return true
    }
    */
    
    

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private func setupDatabase() throws {
        /*
        let databaseURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")
        */
        let path = NSHomeDirectory()
        let databaseURL = "\(path)/railsLite.db"
        dbQueue = try AppDatabase.openDatabase(atPath: databaseURL)
        print("in AppDelegate: back from AppDatabase")
        
        if dbQueue != nil {
            print("in AppDelegate: it isnt nil")
        } else {
            print("in AppDelegate: it is nil")
        }
        
        
        //dbQueue = try AppDatabase.openDatabase(atPath: databaseURL.path)
        
        // Be a nice iOS citizen, and don't consume too much memory
        // See https://github.com/groue/GRDB.swift/blob/master/README.md#memory-management
    }

    func appDelegate() -> AppDelegate {
        let appDelegate = NSApp.delegate as! AppDelegate
        return appDelegate
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender:
    NSApplication) -> Bool {
    return true }

}


