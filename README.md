# Zemoga-ios-test

### Requirements
- Swift 5
- iOS 14

### Run application
- Clone this repository with XCode
- This application does not use third party libraries, so you should be able to run the application once you have the code from the repository.


### Solution
The application fetches the list of posts from an API and stores them in cache through Core Data. The second time the posts are loaded the information will be read through Core data obtaining better performance.

We can refresh the list of posts by swiping down. This will delete the posts we had stored and replace them with the results from the external API.

We can filter our favorite posts by selecting the 'Favorites' tab.

We can see the detail of each post when we select one and we can mark it as a favorite.

From the main view we can delete all the posts we have stored in our phone.

### Architecture
The code was separated into service classes to read the data through the core data (SQLite) or through the API and let the ViewControllers have only the responsibility of capturing the data and events from the user interface.

We also have separate classes for creating UI components that can be used in different ViewControllers such as creating alerts and loading spinners.

<img width="997" alt="Architecture" src="https://user-images.githubusercontent.com/35070041/169827348-e530f4cb-74a9-47cc-9264-d69b97e645b8.png">

### Testing
Unit tests were implemented to verify the functionalities. Additionally a few UI tests were added.

**Covergae**

<img width="898" alt="Coverage" src="https://user-images.githubusercontent.com/35070041/169828479-a710f996-6f82-4c06-87f2-403175ac06ef.png">

