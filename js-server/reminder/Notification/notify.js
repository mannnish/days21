const firebase = require("firebase-admin");
const serviceAccount = require("./project_details.json");

// const firebaseToken =
//   "cl2CGMxjQr2u1J5C65qvJr:APA91bGnCHw41u3UjKoPAkYahlSLAkWHwGHv1zNjkMjRFkQn6dcwcew8PQwRHBp9B36lZZTzPe3yyoCHi-ZzfrQVsIgqvdRcFhykonXEHIi9bzitK-FaYHMXbKzgQ28aXeTPDqfLFIKD";

firebase.initializeApp({
  credential: firebase.credential.cert(serviceAccount),
});

const options = {
  priority: "high",
  timeToLive: 60 * 60 * 24,
};

const pushNotification = (titleStatus, bodyStatus, firebaseToken) => {

  console.log('titleStatus', titleStatus);
  console.log('bodyStatus', bodyStatus)

  const payload = {
    notification: {
      title: titleStatus,
      body: bodyStatus,
    },
  };

  firebase
  .messaging()
  .sendToDevice(firebaseToken, payload, options)
  .then((response) => {
  })
  .catch((error) => {
      console.log(error);
  });
    
};

module.exports = {
    pushNotification
}
