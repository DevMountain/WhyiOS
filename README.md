# whyiOS

<a name= 'top'></a>

* [Project Summary](#description)
* [Implement Model](#model)
* [Controllers](#controllers)
* [Post Reason](#post)
* [View Hierarchy](#view)
* [Black Diamonds](#diamond)


## <a name='description'></a> Project Summary
Students will build an app to showcase why they choose to learn iOS and what cohort they’re in. The database is shared across all DevMountain iOS developers. This app showcases how to post data to a central database. Students will practice asynchronous network calls, working with JSON data, closures, and intermediate tableviews.

Students who complete this project independently are able to:

* Use URLSession to make asynchronous network calls.
* Parse JSON data and generate model objects from the data.
* Use closures to execute code when an asynchronous task is complete.
* Build custom table views.
* Showcase the HTTPMethod POST.

## <a name='model'></a> Step One - Implement Model

### Summary

Create a Post model struct that will hold the information of a post to display to the user.

### Instructions 

* Create a `Post.swift` file and define a new `Post` struct.
* Go to the [endpoint](https://whydidyouchooseios.firebaseio.com/reasons.json) of whyiOS firebase API and see what JSON (information) you'll get back.
* Using this information, add the required properties to `Post`.
* Make Post conform to the `Codable` protocol.

## <a name='controllers'></a> Step Two - Implement PostController

### Summary

Create a `PostController` class.
This class will use the URLSession to fetch data and deserialize the results into Post objects. This class will be used by the view controllers to fetch Post objects through completion closures.

### Instructions

* The PostController should have a static constant that represents the baseURL of the API.

  *  The URL for whyiOS is `https://whydidyouchooseios.firebaseio.com/reasons`

* Add a static function `fetchPosts(completion:….)` that allows the developer to create a dataTask to fetch the Posts data, and through a completion closure provide an array of Post objects.

  * Create a new variable named `unwrappedURL` and `guard` that it is assigned to the `baseURL`. Handle the closure appropriately.

  * Append `.json` to a `getterEndpoint` using your `unwrappedURL`

  * Build your `URLRequest` with the proper `httpMethod`

  * Create a `dataTask(with: request… )` from the URLSession singleton

  * Check for an error - handle the error and completion accordingly

  * Check for data -  handle the error and completion accordingly

  * If data is there write a `do catch` block

    * Create an instance of JSONDecoder
    * Create a dictionary with a key of String and a value of Post from the decoded data 
    * `compactMap` through the dictionary to create an array of posts
    * Ask your self what you are completing with *("What would you like this function to come back with")*. Then call completion with that.
    * Catch the error

## <a name='post'></a> Step Three - Post Reason

### Summary

Create a `postReason` method that will take in the required parameters and then send the `Post` to the API as a `POST` request

### Instructions

* Create your method with its three required parameters and a closure that completes with a `Bool`

* Guard your URL. If it fails, complete false.

* Append `.json` to the end of your URL

* Create your `Post` object

* Write a `do catch` block to encode your post object for the `URLRequest`

  * Encode it with an instance of JSONEncoder()
  * Create your request. Use the proper `HTTPMethod`, and set your encoded data to the `HTTPBody`
  * Create your `dataTask` with your request
  * Handle your error and completion accordingly
  * Handle the data and completion accordingly
    * Don't forget to resume the dataTask
  * Catch and handle your error


## <a name='view'></a> Step Four - PostViewController

### Summary

We will only need one view for this application:
ReasonTableViewController

You will build a story that will display the data we return from our endpoint. You will need a UIViewController with a Table View all embedded in a NavigationController, a custom UITableViewCell, three labels, and two bar button items.

Start by building a view that will list all the students with their name, cohort, and a why they choose to build iOS apps.

### Instructions

* Delete the basic `ViewController.swift` file in your project navigator

* Take your starting `UIViewController` in `Main.storyboard` and embed it in a `UINavigationController`

* Add a `Table View` to the view controller and constraint it `0` to all sides

* Create a `PostsViewController` file as a subclass of UIViewController and set the class of your root view controller scene.

* Have the `PostsViewController` conform to the two protocols related to table views that we will need for this project and add the protocol stubs

* Add a custom table view cell and set up your cell with three labels.

* Embed your labels in a stack view and pin it `8` from all sides.

* Create a `PostTableViewCell` file as a subclass of `UITableViewCell` and set the class of your cell.

* Add your cells reuse Identifier.

* Add a left bar button item and make it a system item `Refresh`

* Add a right bar button item, set it to an `Add` item

* Create all the outlets and actions you will need in their corresponding files.

* Set your table view's data source and delegate programmatically

## Step Five - Data Source

### Summary 

You will build out your table views data sources methods and the IBActions to perform the required function for each.

### Instructions

* Create your `fetchedPosts` source of truth in the view controller file. ***NOT THE MODEL CONTROLLER***

* Create your refresh method - This should use the post controllers fetched posts method to set the value of your source of truth and reload the tableView
  * Call this method in the refresh button IBAction

* Make sure all UI changes are performed on the main Queue

* Set up your tableView datasource methods, and set the text of the cells labels to the corresponding data

## Step Six - Add Post Alert Controller

### Summary

You will add an alert controller to display when the `Add` button is tapped and it will handle posting to Firebase

### Instructions

* Inside the add button IBAction, create your `addPost` alert and set the title

* Create your textfields for each label you made earlier

* Use the addTextField method to add your textfields to the alert

* Change the placeholders for each textfield to prompt the user to write in the correct data in each text field.

* Create your cancel action

* Create your post reason action

* Use the postControllers `.postReason` method to send your data to the endpoint.

* If successful, call your custom to refetch the posts and reload the table view. 
  * Make sure all UI changes are performed on the mainQueue — Talk to your mentor and make sure you are at least a 4 out of 5 before continuing. This is a very important concept to understand.

* Present the alert

* Run your app. Add your name, what cohort you’re in, and the reason you choose to learn iOS

* Party.

## <a name='diamond'></a> Black Diamonds

* Allow deleting of the cells
* Add mock students to test deleting the cells. DO NOT DELETE OTHER STUDENTS POSTS
* Have the reasons resize with the content

## Contributions

If you see a problem or a typo, please fork, make the necessary changes, and create a pull request so we can review your changes and merge them into the master repo and branch.

## Copyright

© DevMountain LLC, 2017. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.

<p align="center">
<img src="https://s3.amazonaws.com/devmountain/readme-logo.png" width="250">
</p>
