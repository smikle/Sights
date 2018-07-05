## iOS Documentation

* MacOS HighSierra or later
* Xcode >= 9.4
* iOS >= 10.0
* Swift 4.1
* SwiftLint    
* Device (iPhone, iPad)

#Overview.

Application uses MapKit.
All user data is stored in CoreData.

After the first launch, we try to get default locations by link, if we couldn’t get it, locations will be filled from json in application bundle.
Then ask the user about access to the geodata.

The main screen is a list of all locations, sorted by a distance of you.
* Delete/Edit by standard swipe. Default locations can't be deleted, only edit name and description. The user points can be completely edited including the coordinates.
* by tapping on a row, a map will be shown with the selected location
* by tapping on right bar button, a map will be shown with the last viewed coordinates

The edit screen allows you to edit location (name, description, latitude, longitude). Data validation is temporarily missing.
* Default locations can't be deleted, only edit name and description.
* The user points can be completely edited including the coordinates.

The map screen shows the default apple map with user points.
* Default points – dark gray, User points - red, Searched Place - blue.
* New point can be added by long tap.
* User points can be dragged to the new location.
* Searched Place can be saved and converted to the user point
* by tapping on right bar button, a map menu will be shown
    * Map type - changing map type
    * Show traffic
    * Search – context search by address, sights name etc.

The project contains some unit test, but unfortunately not all test was written.

Demo video
![](sights.mp4)
