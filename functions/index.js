 /* eslint-disable */
const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotification = functions.https.onCall(async (data, context) => {
  await admin.messaging().sendMulticast({
  tokens: data.tokens,
  notification: {
    title: data.title,
    body: data.body,
    imageUrl: data.imageUrl,
  },
});