// Import the functions you need from the SDKs you need
// import { initializeApp } from "firebase/app";
// import { getAnalytics } from "firebase/analytics;
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

const initializeApp = require("firebase/app").initializeApp;
// const getAnalytics = require("firebase/analytics").getAnalytics;
const concurrently = require("concurrently");
const upath = require("upath");

const browserSyncPath = upath.resolve(
    upath.dirname(__filename),
    "../node_modules/.bin/browser-sync"
);

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
    apiKey: "AIzaSyDMjy-ED6azv1ynnvtBtfUkDS-fssC2SMk",
    authDomain: "the-spot-web.firebaseapp.com",
    projectId: "the-spot-web",
    storageBucket: "the-spot-web.appspot.com",
    messagingSenderId: "349860846797",
    appId: "1:349860846797:web:afe6f95084c7de0d4c5d84",
    measurementId: "G-XJ5L70SHGK",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
// const analytics = getAnalytics(app);

concurrently(
    [
        {
            command: "node scripts/sb-watch.js",
            name: "SB_WATCH",
            prefixColor: "bgBlue.bold",
        },
        {
            command: `"${browserSyncPath}" --reload-delay 2000 --reload-debounce 2000 dist -w --no-online`,
            name: "SB_BROWSER_SYNC",
            prefixColor: "bgGreen.bold",
        },
    ],
    {
        prefix: "name",
        killOthers: ["failure", "success"],
    }
).then(success, failure);

function success() {
    console.log("Success");
}

function failure() {
    console.log("Failure");
}
