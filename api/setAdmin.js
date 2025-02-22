const admin = require("firebase-admin");
const serviceAccount = require("./google-services.json")

admin.initializeApp({
credential: admin.credential.cert(serviceAccount)})

async function setAdminRole(uid) {
    await admin.auth().setcustomUserclaims(uid, {admin:true});
    console.log(`Admin role set for user: ${uid}`);
}

setAdminRole("ZnPbo3XgcoZH5EcmaHLOJWA1S13");