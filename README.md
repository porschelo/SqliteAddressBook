---
title: 'Project documentation template'
disqus: hackmd
---

# Address Book


## Table of Contents

[TOC]

## Brief Introduction

This is a address book app, you can add, remove, edit contact person on your own.

## How to implement

- ### First Stage
    -  Set up contact person model
    -  Use UITableView make the contact person list, which must has add, remove, edit function.

- ### Second Stage

    -  Add **`SQLite.swift`** in your project and use it to store person information in local. Your can refer appendix **`How to operate SQLite`** to learn more method about **`SQLite.swift`**.
        -  Make sure CocoaPods is installed.
		    ```swift
		    [sudo] gem install cocoapods
		    ```
        -  Update your Podfile to include the following:
	    	```swift
	    	use_frameworks!
	    	
	    	target 'YourAppTargetName' do
	    	    pod 'SQLite.swift', '~> 0.13.1'
	    	end
	    	```
        -  Run `pod install --repo-update`.
        
    -  Write a interface which make the contact person model adapt SQLite method.
    
- ### Third Stage
    
    -  Add **`OHMySQL`** in your project and use it to store person information in remote. Your can refer appendix **`How to operate SQLite`** to learn more method about **`OHMySQL`**.
        -  Make sure CocoaPods is installed.
		    ```swift
		    [sudo] gem install cocoapods
		    ```
        -  Update your Podfile to include the following:
	    	```swift
	    	use_frameworks!
		
	    	target 'YourAppTargetName' do
		        pod 'OHMySQL'
		    end
		    ```
        -  Run `pod install`.
    -  Write a interface which make the contact person model adapt SQL method.
    -  Judge the connection and determine how to store and update the database between local and remote database.
    



Project Timeline
---
```mermaid
gantt
    title A Gantt Diagram

    section Section
    First Stage      :a1, 2020-01-03, 1d
    Second Stage     :a2, after a1  , 2d
    Third Stage      :after a2  , 5d
```

## Appendix and FAQ

- [How to operate SQLite.swift](https://github.com/stephencelis/SQLite.swift)
- [How to operate OHMySQL](https://github.com/oleghnidets/OHMySQL)
###### tags: `Address book` `SQLite` `MySQL`
