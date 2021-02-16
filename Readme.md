# Stream Heroku logs to AWS Cloudwatch using an EC2 instance and Docker  

For more details: https://amlanscloud.com/herokulogsaws/    

One thing I wanted to mention here is that, the method I mention here is a very custom method of streaming the logs. With this you will have to launch your own resources and track the usage. I found this service very useful to stream your Heroku logs to AWS without worrying about managing your own resources. You can setup the stream from Heroku to AWS S3 or Cloudwatch easily without worrying about setting it up on your own. Logbox service is a 3rd party service which I have used in many of my side projects and it works well. You can explore and setup your own Heroku to AWS setup from here: <a href="https://logbox.io/?r=achakladar" target="_blank">Sign Up</a> 
