- Travis CI is a service that we use for continuous integration (CI).
- A Travis CI account must be linked to a GitHub repository in order to use the service.
- We use it to test building our project and run tests on Linux/macOS systems, configured to specific compiler versions.
- Travis CI has internal build settings that can be modified on their web service, but the best practice is to create a `.travis.yml` config file in the project root directory which then gets automatically detected by Travis CI.
- `.travis.yml` is a configuration file used to override any internal settings. You can configure platform/compiler versions of the systems that will try to build your project according to the rules outlined in the script.
- Depending on your settings, when GitHub receives a push in a branch or through a pull request, a webhook will trigger Travis CI to build. The build will either succeed and you are good to continue working or merge the changes, or it will fail and you can inspect the errors by looking at the Travis CI build output.

### SETUP
1. go to **https://travis-ci.org/**
2. sign up for an account
3. link your GitHub account
4. enable/link your GitHub repository

**NOTE: in "More options -> Settings", I recommend disabling "Auto Cancellation" if you want to guarantee all changes to build.**
