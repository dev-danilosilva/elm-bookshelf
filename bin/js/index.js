// app and appSelector are defined in config.js
const application = initialize(app, appSelector); // initialize is defined at lib.js

application.ports.sendData.subscribe((data) => console.log("Data from Elm: ", data))
