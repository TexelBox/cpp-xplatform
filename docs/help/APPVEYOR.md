- AppVeyor is a service that we use for continuous integration (CI).
- An AppVeyor account must be linked to a GitHub repository in order to use the service.
- We use it to test building our project and run tests on Windows systems, configured to specific compiler versions.
- AppVeyor has internal build settings that can be modified on their web service, but the best practice is to create an `.appveyor.yml` config file in the project root directory which then gets automatically detected by AppVeyor.
- `.appveyor.yml` is a configuration file used to override any internal settings. You can configure platform/compiler versions of the systems that will try to build your project according to the rules outlined in the script.
- Depending on your settings, when GitHub receives a push in a branch or through a pull request, a webhook will trigger AppVeyor to build. The build will either succeed and you are good to continue working or merge the changes, or it will fail and you can inspect the errors by looking at the AppVeyor build output.

### SETUP
1. go to **https://www.appveyor.com/**
2. sign up for an account
3. link your GitHub account
4. create a new AppVeyor project and link your GitHub repository
