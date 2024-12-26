# Movie Browser

A simple iOS app to browse and view movies, including their details, images, and more. The app pulls movie data from The Movie Database (TMDb) API, displays now playing movies, and allows users to explore images related to the movies.

## Instructions

### How to Run the App

1. **Clone the repository**:
   First, clone the repository using the following command:
   ```bash
   git clone https://github.com/edmundyoasobi/movieBrowser.git
   ```


2. **Install Dependencies**:
  After cloning the project, navigate to the project directory and install the necessary dependencies using CocoaPods:
```bash
cd movieBrowser
pod install
```

3. **Configure the API Key**:

Duplicate the TemplateApiKeys.plist file and rename it to ApiKeys.plist.
Open the ApiKeys.plist file and replace <string>YOUR_API_KEY_HERE</string> with your actual API key from [The Movie Database (TMDb)].(https://developers.themoviedb.org/3)
Example:

```xml
<key>APIKey</key>
<string>your_actual_api_key_here</string>
```

4. **open movieBrowser2.xcworkspace**

5. **Build and Run: Build and run the project using Xcode on a simulator or physical device.**


**Frameworks Used** 

**SDWebImage**
Why SDWebImage was chosen: SDWebImage is used to download and cache images efficiently in the app. It offers built-in functionality for handling image downloads asynchronously, with support for caching images locally, which improves performance by reducing network calls.

In contrast, if you were to use FileManager and URLSession, you would have to implement image caching and asynchronous image downloads manually, which would require extra code to handle memory management, cache invalidation, and background processing. SDWebImage abstracts all of these complexities, providing a more efficient and streamlined solution.


**Potential Improvements**
We might able to do image Compression where we can reduce the size of images before storing or displaying them to improve performance 
Beside documentation can be included in the code itself

**API Key COnfiguration**
I used a .plist file where this approach keeps the API key secure within the app, as it is not hardcoded into your code, and makes it easier to manage different API keys for various environments (e.g., development, staging, production).
