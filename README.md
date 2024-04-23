# brain_train_app

BrainTrain - A system to improve language skill for mild cognitive impairment patients.

Hello, my name is Nguyen Quoc Bảo - ITITIU19081. This is my theis for International University.

The purpose of this study is providing the overview of technology selections which help Alzheimer’s patients improve language skill and diagnose those who run the risk of MCI throughout data from games. It is the first time games have been designed by Vietnamese, so that they easily approach to the elderly in Vietnam. In addition, patients’ conditions are followed by specialist doctors based on data from the games which will be stored on server and the website for doctors. Specialist doctor can give many types of exercises for each patient, and then send notification to reminder patients.

## Getting Started

This project is a starting point for a Flutter application. So, you need to download the flutter SDK firstly at https://docs.flutter.dev/get-started/install (this it all tutorial for mac, window adn linux ).And you should install Android Studio it's better if you run with a virtual machine because it provides you with an environment to create a virtual Android machine to run the application, if you have installed vs code then it's okay you can download the extension flutter and dart in vs code and run code with real android phone. Because, my application have api so it not run on web browser.

After install all requirement, open your terminal run "flutter doctor" to check it work clearly. 


## Import code

- Import the source code by using vsCode or AndroidStudio (IntelliJ).
- Open the file pubspec.yaml and click the "pub get" on right above:
  <img width="1662" alt="Screenshot 2024-04-18 at 12 24 53" src="https://github.com/KIddoKg/brain_train_app/assets/73632319/242e924c-80f1-4346-9fb5-acd20bb4511b">
  Or you can open the terminal on this project location and run "flutter pub get" to down all library before run code

## Install the virtual device

- With run Android virtual device
  + Open the AndroidStudio at the first page to open project, click "tool" choose Device Manager:
  + <img width="297" alt="Screenshot 2024-04-23 at 10 02 29" src="https://github.com/KIddoKg/thesis_braintrainApp/assets/73632319/32dea05f-00ee-40de-b81f-0072a786d95c">
    Click the plus icon ("Create Vitural device"), the window to open click next to all , in this section system Image to choose "Tiramisu".
  You can flow the video:
  + [![Watch the video](https://cdn.pixabay.com/photo/2020/08/12/20/11/video-5483595_960_720.png)](https://youtu.be/aBTNUpp72ik?si=fmN_qZYZRIMyZLdA&t=77)
  
  
- With run Android real physics
  + If mobile has Android below version 11, you should connect your mobile to your laptop through wire usb, the mobile should unlock development mode and turn on debug. You can following the video:
    [![Watch the video](https://cdn.pixabay.com/photo/2020/08/12/20/11/video-5483595_960_720.png)](https://youtu.be/aohkII1C4JY?si=xnowsXNGVUO3Unpg&t=8)
  + If If mobile has Android version 11 +, In "Device Manager" choose Wifi icon and pairing with your mobile

- With run iOS Simulator
  + On your macbook open Simulator, and choose iphone model you want.
  
## Run Code

- Firstly, run your virtual device or unlock screen your mobile 

- After open the source code and run "flutter pub get", you  can choose the mobile you want to install the application 
<img width="392" alt="Screenshot 2024-04-23 at 12 08 02" src="https://github.com/KIddoKg/thesis_braintrainApp/assets/73632319/fd9be1ae-6cc1-4038-a21e-5d91ef16e7bb">

Note!!!! don't run it with Chorme or Edge because application have api, so run on it the code with errors.
- You can click run button play icon or open terminal run "flutter run" .Await about some minutes the BrainTrain will be install on your mobile

Video:
[![Watch the video](https://cdn.pixabay.com/photo/2020/08/12/20/11/video-5483595_960_720.png)](https://github.com/KIddoKg/lotocall/assets/73632319/d88654b7-79c2-4dca-9f61-6f8607c6b69c)



## Website doctor manager

The same with run code application Brain train but when choose device run code, choose Chrome or Edge to run code.

<img width="1575" alt="Screenshot 2024-04-23 at 12 22 53" src="https://github.com/KIddoKg/thesis_braintrainApp/assets/73632319/eb2d0c1b-ec84-4248-aa85-fc47ae5befd5">


## Edit code

If you want to run code with local:
* With application:
- When you run code BE and have your ip local BE. (http://localhost:8080)
- Open file api in lib/service
- Disable 2 line code above and open 2 line code below
  <img width="857" alt="Screenshot 2024-04-23 at 12 27 51" src="https://github.com/KIddoKg/thesis_braintrainApp/assets/73632319/35486ced-a470-466d-add8-1cea9457d8c2">

* With website:
- Open file api in lib/service
- Disable 2 line code above and open 2 line code below
  <img width="1098" alt="Screenshot 2024-04-23 at 12 30 37" src="https://github.com/KIddoKg/thesis_braintrainApp/assets/73632319/4180cc0f-0c27-4418-888b-42eb8940621c">


If you want to run and using app and web in server: Open code and run it 


