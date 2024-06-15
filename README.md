# FlatHub

## Introduction
App that helps users book accommodations for travelers and helps hosts earn money from their accommodations.

## Features:
- Authorization and registration
- Search and book accommodation
- Adding accommodation to favorites
- Canceling booking
- Switch between user roles (traveller and host)
- Adding new accommodation
- Monitor of profits and bookings
- Editing accommodations
- Stoping booking
- Removing accommodation
- Rating accommodation and host
- Detailed information about the accommodation

## Technologies
- Swift
- SwiftUI
- TCA
- Firebase:
  - Auth
  - Firestore
  - Database

## Geting Started
There are a few steps to setup the project:
1. To run this app, make sure you have Xcode (v. 15.0+) installed and set the deployment target to iOS 14.0 or later.
2. Setup the firebase using https://firebase.google.com/. You need to enable the following modules: Auth, Firestore and Database
3. Create an account at https://www.geoapify.com/reverse-geocoding-api. Then create the `APIConstants.swift` file in `FHRepository` module. Here is what should you put in this file:
   ```
   enum APIConstants {
    static let geoapifyKey = YOUR_API_KEY
   }
   ```

And that's it.
