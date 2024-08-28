const admin = require('firebase-admin');

const serviceAccount = require('./personal-project-39fa9-firebase-adminsdk-7qp8l-197871a7c9.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

function sendNotificationAccident(accChange) {
    const message = {
        notification: {
            title: 'Cảnh báo gia tốc',
            body: `Gia tốc hiện tại là ${accChange}m/s^2, vượt ngưỡng an toàn.`
        },
        data: {
            iconPath: 'assets/images/sos.png'
        },
        topic: 'high-accChange'
    };
    admin.messaging().send(message)
        .then(response => {
            console.log('Notification sent successfully:', response);
        })
        .catch(error => {
            console.error('Error sending notification:', error);
        });
}

function sendNotificationStart() {
    const message = {
        notification: {
            title: 'START DEVICE',
            body: 'Thiết bị đã được khởi động'
        },
        data: {
            iconPath: 'assets/images/on.png'
        },
        topic: 'start-device'
    };
    admin.messaging().send(message)
        .then(response => {
            console.log('Notification sent successfully:', response);
        })
        .catch(error => {
            console.error('Error sending notification:', error);
        });
}

module.exports = { sendNotificationAccident, sendNotificationStart };
