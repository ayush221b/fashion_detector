# Fashion Detector

Fashion Detector is a mobile app, built for the Android and iOS platform using the Flutter SDK by Google.

# Features!

  - Capture a new image using the device's camera or pick one from the gallery.
  - Uploads image into a firebase storage bucket, and returns the download link.
  - Sends the image url to my Custom API and returns the predicted result.

> The intent of this app, is not to priortise prediction 
> accuracy. It is to create a fully functional Flutter Application
> which can interact with Firebase and a custom API 
> and handle all requests with efficient performance.

### Installation

Fashion Detector requires [Flutter](https://flutter.io/) to run.

Install the Flutter SDK on your OS and Setup the environments for Android and iOS respectively. Refer these [docs](https://flutter.io/docs/get-started/install) for help.

To run this code:

```sh
$ git clone https://github.com/ayush221b/fashion_detector.git
$ cd fashion_detector
$ flutter packages get
```

You can then use your preferred IDE to open and edit it.
Also, I would sincerely request you to setup and configure your own firebase project, as I may delete or discontinue the provided config at any point of time. 

### Plugins

Fashion Detector uses the following plugins. 

| Plugin 
| ------ 
| image_picker 
| http 
| firebase_storage 
| random_string 
| flutter_launcher_icons (dev)