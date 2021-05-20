# Cloud Recording your iOS Agora Video Chat

Agora Cloud Recording makes it easy for a developer to record and store the videos from their real-time engagement application. We’ll look at how to add cloud recording to a React Native video chat app. By the end of this tutorial, you’ll be able to record and save video calls from your application to an Amazon S3 bucket for later access.

## Prerequisites

- An Agora developer account (see [How to Get Started](https://www.agora.io/en/blog/how-to-get-started-with-agora?utm_source=medium&utm_medium=blog&utm_campaign=cloud-recording-ios))
- An AWS account
- A Heroku account or another service to deploy the back end
- An iOS device with minimum iOS 13.0 + Xcode 12
- A basic understanding of iOS development
- CocoaPods

## Architecture

![Cloud Recording for React Native Video Chat Using Agora screenshot 1](https://www.agora.io/en/wp-content/uploads/2021/04/cloud-recording-for-react-native-video-chat-1.png)

We’ll be deploying a Golang server to handle requests from our React Native app using the REST API. The Golang server will internally manage calling the Agora Cloud Recording service, which stores the result in an Amazon S3 bucket.

If you haven’t deployed a back-end service or used Golang before, don’t worry. We’ll walk through the entire process together.

## Agora Setup

1. **Create a project**: Once you have an Agora account, click the [Project Management tab](https://console.agora.io/projects) in the console. Click the Create button. Enter a name for your project. Select Secured Mode while creating the project.
2. **Enable cloud recording**: Click the View usage button and select the option to enable cloud recording.
3. **Get app credentials**: Copy the App ID and the App Certificate from the same page to a text file. We’ll use these later.
4. **Get customer credentials**: Visit the [RESTful API page](https://console.agora.io/restfulApi?utm_source=medium&utm_medium=blog&utm_campaign=cloud-recording-ios) and click the Add Secret button. Copy the Customer ID and the Customer Secret to a text file.

## AWS Setup

Once you’ve created an AWS account, we need to create an Amazon S3 bucket to store our video recordings and an IAM user to access our bucket. If you already have this set up, feel free to skip this section.

1. Go to your [AWS IAM Console](https://console.aws.amazon.com/iam/home#/users) and create a user. Add the `AmazonS3FullAccess` policy with Programmatic Access.
2. Copy your AWS Access Key and Secret Key to the text file.
3. Create an Amazon [S3 bucket](https://s3.console.aws.amazon.com/s3/home) and copy the bucket name to your text file. To find your region number (for your AWS region), go to the [table](https://docs.agora.io/en/cloud-recording/cloud_recording_api_rest?platform=RESTful#a-namestorageconfigacloud-storage-configuration) and click the Amazon S3 tab. For example, if you’re using the `US_EAST_1` region, your bucket number is 0.

## Deploying Our Back End

Before deploying our back end, we need the following variables. (It’s time to use our text file.) We’ll be using the [Heroku](https://www.heroku.com/) one-click deploy to make it super simple to get our back end up and running. You can use any other service as well:

```
APP_ID=
APP_CERTIFICATE=
RECORDING_VENDOR=
RECORDING_REGION=
BUCKET_NAME=
BUCKET_ACCESS_KEY=
BUCKET_ACCESS_SECRET=
CUSTOMER_ID=
CUSTOMER_CERTIFICATE=
```

*Note:* *RECORDING_VENDOR=1 for AWS. Visit this* [link](https://docs.agora.io/en/cloud-recording/cloud_recording_api_rest?platform=RESTful#a-namestorageconfigacloud-storage-configuration) *for more information.*

1. Create an account on [Heroku](https://www.heroku.com/) if you haven’t done so already.
2. Click [this link](https://dashboard.heroku.com/new?button-url=https%3A%2F%2Frayanuthalas.medium.com%2Fca5d66bbb4e3&template=https%3A%2F%2Fgithub.com%2Fraysandeep%2FAgora-Cloud-Recording-Example%2F) to use the Heroku one-click deploy.
3. Enter your variables and click the Deploy App button at the bottom of the page.
4. Wait a few minutes. Once the deployment is complete, save your back-end URL in a text file, which we’ll use in the app.

## Building Our App

We’ll be using the [Agora UIKit for iOS](https://github.com/AgoraIO-Community/iOS-UIKit) to make the video calling implementation simpler. If you’re new to the Agora platform, I recommend reading through the blog to understand how to build a video chat app. We’ll take that as a basis and discuss how to add cloud recording to it.

If you just want the final app, you can go to this [repo](https://github.com/EkaanshArora/Agora-RN-Recording/blob/main/App.tsx).

### Getting the Boilerplate

Make sure you have satisfied the prerequisites for creating and building a React Native app. Git clone or download the ZIP file from the [main branch](https://github.com/EkaanshArora/Agora-RN-Quickstart). In the project directory, execute pod install to install the right CocoaPods.

### Adding Credentials

Open `ViewController.swift` and enter your back-end URL in the `urlBase` property, as well as your Agora App ID. The channel name will be set to `"test"`, but it can be any alphanumeric string.

### Joining The Channel

This project uses Agora UIKit for iOS, and we need to add some code for fetching the token using the endpoints used in this specific backend:

https://gist.github.com/maxxfrazer/7a8e7fc72e2ab420f9c0cd91034374ee

### Start Recording

Using the same service as the token server, we can start the recording using the endpoint `/api/start/call` with a `POST` call. We also need to store the rid, sid and recUid from the response:

https://gist.github.com/maxxfrazer/3d74ef5f90a57f14d102ac642b526114

### Stop Recording

To stop recording, we send a `POST` request to the `/api/stop/call` endpoint of the back end with the `channel`, `rid`, `sid`, and `recUid` in the body.

https://gist.github.com/maxxfrazer/8748d618e2ec8f9aad03e083698a4193

### Recording Status

Let’s create a function to check the status of our recording and log it to the console

https://gist.github.com/maxxfrazer/4f7ae5885d491d3fc7ee087d3d83f6b4

For information on what the status response shows, check out the [RESTful API documentation](https://docs.agora.io/en/cloud-recording/cloud_recording_api_rest?platform=RESTful#a-namequeryaquery-the-recording-status).

## Conclusion

That’s it, now you have an app that uses Agora Cloud Recording to store your videos. You can find out how to merge the resulting video fragments [here](https://docs.agora.io/en/cloud-recording/cloud_recording_merge_files?platform=RESTful). You can find more information about cloud recording [here](https://docs.agora.io/en/cloud-recording/landing-page?platform=RESTful).
