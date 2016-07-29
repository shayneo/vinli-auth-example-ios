# Vinli OAuth Example App

This is a super basic example app that leverages the Vinli SDK and Authorizes a MyVinli user.

# Resources
- [Vinli iOS SDK](https://github.com/vinli/ios-net)
- [Vinli Developer Portal](https://dev.vin.li)
- [My Vinli](https://my.vin.li)
- [API Docs](http://docs.vin.li)
- [Virtual Vinli / Vinli CLI](http://bit.ly/virtual-vinli) for testing and data simulation

# Tutorial
The first thing that any iOS app needs to to when building with Vinli is install the SDK, and then set up OAuth... so that your app can actually access a Vinli user's data.
Thankfully, this is super easy... so just sit back, open up Xcode, and follow along as we walk you through the process.

## Installing the SDK
The Vinli SDK is easily deployed through [CocoaPods](https://cocoapods.org/). cd into your project directory and run `pod init` to create a podfile.
If you already have a file, you can skip `pod init`.

Open the pod file in a text editor and add `pod VinliNet`. The result should look something like...
```
target 'Vinli-Auth-Example' do
pod 'VinliNet'
end

target 'Vinli-Auth-ExampleTests' do

end

target 'Vinli-Auth-ExampleUITests' do

end
```

Now go back to your terminal and run `pod install` and wait for the Pod intallation to complete.

Make sure to close out of your Xcode project. Once the pod installs, a new Project.xcworkspace file will appear in your directory. Open that bad boy up in Xcode.

Congrats! You've installed the Vinli SDK!

## OAuth
Before we build any flashy, cool features, we first need to ask the user if it's okay for our app to access their Vinli data. We use the industry standard OAuth2 Protocol
and bake Authentication into the SDK so you don't have to worry about it.

### Create a Client
Login to the [developer portal](dev.vin.li) and create a Client for your app.
Make sure it's an iOS client (duh) and enter in a redirect URI. The redirect URI can be whatever you want as long as it follows the `http://something.something` format.

### Header File
Let's start with the header file that corresponds with your ViewController. First, we'll add `#import <VinliSDK.h>`

Also, we'll add `@property (strong, nonatomic) VLService *vlService;`

### View Controller
Now let's head over to the View Controller that's handling Vinli Login. Add this to the `viewWillAppear`

```objectivec
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    // If we are already logged in, we can create a VLService and continue with the app.
    if([VLSessionManager loggedIn]){
        _vlService = [[VLService alloc] initWithSession:[VLSessionManager currentSession]];

    } else {
        [self loginWithVinli];
    }
}
```
`VLSessionManager` is looking to see if the user is already logged in with Vinli, if they are... yay! If not, we call `loginWithVinli` (which we'll add now).

```objectivec
- (void) loginWithVinli{
    // Clear cookies before calling loginWithClientId
    [self clearCookies];

    // This will launch the Vinli login flow.
    [VLSessionManager loginWithClientId:@"CLIENT_ID" // Get your app client id at dev.vin.li
                            redirectUri:@"REDIRECT_URI" // Get your app redirect uri at dev.vin.li
                             completion:^(VLSession * _Nullable session, NSError * _Nullable error) { // Called if the user successfully logs in, or if there is an error
        if(!error){
            NSLog(@"Logged in successfully");
        }else{
            NSLog(@"Error logging in: %@", [error localizedDescription]);
        }
    } onCancel:^{ // Called if the user presses the 'Cancel' button
        NSLog(@"Canceled login");
    }];
}
```
Make sure to replace `CLIENT_ID` and `REDIRECT_URI` with your own.

To clear cookies, add this:
```objectivec
- (void) clearCookies{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}
```

Lastly, to log out of Vinli just call something like this:
```objectivec
- (void) logOutWithVinli{
    [VLSessionManager logOut];
}
```

### My Vinli (SUPER IMPORTANT)
You should be good to go! Now, all you need is a [My Vinli](https://my.vin.li/#/sign-up/create-account) account to try it out with. **REMEMBER** your Vinli developer credentials are **NOT** the same as My Vinli consumer credentials.
No worries though, just head over to my.vin.li to spin up an account.
