# Unbiased
A Multi-perspective Covid-19-related International News App

## Video Demo
https://youtu.be/oCnLdIDYHfg

## UI

<img src="https://github.com/rubychen0611/Unbiased/blob/master/images/overview.png" width = "500"/>

## Overview

<img src="https://github.com/rubychen0611/Unbiased/blob/master/images/%E4%B8%BB%E9%A1%B5.png" width = "200"/><img src="https://github.com/rubychen0611/Unbiased/blob/master/images/%E6%96%B0%E9%97%BB%E9%A1%B5.png" width = "200"/><img src="https://github.com/rubychen0611/Unbiased/blob/master/images/%E6%B3%A8%E5%86%8C.png" width = "200"/>

## Final Design Document
https://drive.google.com/file/d/1dr0EPRQCG4lW_C1QAvIUQ315qPz4xAGz/view?usp=sharing

## Directory Structure
- /unbiased-backend
 - Analyzer.py
 - Cleaner.py
 - Cluster.py
 - Crawler.py
 - MySQLConnector.py
 - Uploader.py
 - main.py
 - media_list.py
- /unbiased-flutter:
 - /lib
     - /Common
         - Global.dart
         - MyIcons.dart
         - State.dart
     - /DataModel
         - NewsGroup.dart
         - Profile.dart
     - /UI
        - ArticlePage.dart
        - HomePage.dart
        - IndexPage.dart
        - LoginPage.dart
        - MinePage.dart
        - SignInPage.dart
        - SignUpPage.dart
        - SplashPage.dart
    - main.dart
    - …

## Run
### Run App
Open "unbiased-flutter" directory in Android Studio. Run 
```sh
$ flutter packages get
```
to configure the environment. Then run the file "main.dart" to install the apk on an Android emulator.

### Update news groups
Open "unbiased-backend" directory, modify MySQL configurations in "MySQLConnector.py". Run:
```sh
$ python main.py
```
## Maintainers
Team 10100011 from NJU

    


  [1]: https://github.com/rubychen0611/Unbiased/blob/master/images/overview.png?raw=true