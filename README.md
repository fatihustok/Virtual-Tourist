# Virtual-Tourist
Built an app with Swift 2.2 that allows users to tour the world without leaving the comforts of their couch. This app allows you to drop pins on a map and pull up Flickr images associated with that location. Locations and images are stored using Core Data. 

### First Screen
The app opens with a map view which shows all the pins added before. if there is no pin, the user can add a new pin by tapping a point on the map for a few seconds and then the app downloads all the images related to that location as core data

### Second Screen
The second screen shows all the images related to that location in a collection view. The user can upload new photos, or delete photos from the collection. As the user deletes the photo, the photo is also removed from the core data.
