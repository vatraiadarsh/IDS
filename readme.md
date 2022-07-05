# Runing an app




https://user-images.githubusercontent.com/33037244/177277032-7a8c2f45-5c77-450c-a15c-8f5c7ac893f5.mp4




clone the app using command 

```git
git clone https://github.com/vatraiadarsh/parallax-solution.git
```

# Installing dependencies

```node
cd parallax-solution
npm install  (installing dependencies for client)
cd server
npm install ((installing dependencies for server))
```
# Running Server
Make sure to update the .env.example file with the mongodb uri just on .env file

```node
DATABASE=mongodb+srv://dbuser:dbpassword@your_db_name.pbn7j.mongodb.net/myFirstDatabase?retryWrites=true&w=majority
JWT_SECRET=some_secret_letters_numbers
SENDGRID_KEY=SG.your.secret-key
EMAIL_FROM=yourname@gmail.com
```


```node
cd server
npm start
```

# Running Client/app (from root )
```node
npm start
```

