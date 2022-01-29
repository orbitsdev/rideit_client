const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().functions);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
// exports.hellowWorld = functions.https.onRequest((request,response)=>{
//    response.send("test from firebase function");
// });

// exports.hello = functions.https.onCall((data, context)=>{
//     return {
//         response :  "hello " +  data.message,
//     }
// });

// exports.testFunction = functions.https.onCall((data,contex)=>{
//     return ['a,','b','c'];
// });

// exports.functionWithParameter =  functions.https.onCall( async (data, context)=>{

//     const holders= data.text;

//     return "this is the passdata " + holders;


// });


exports.sendNotification =  functions.https.onCall(async(data, context)=>{

    const payload = {  
        notification: {
            title: "triograp",
            body: data.mydata,
            android_channel_id: "triograb",


        },
        data: {
            data_to_send: "msg_from_the_cloud",
        }
    };
 
   admin.messaging().sendToTopic("alldrivers", payload).then(value=>{
    console.info("function executed succesfully");
    return { msg: "function executed succesfully" };
   }).catch(error=>{
    return { msg: "error in execution" };
   });

   

});