const mqtt_client = require('./mqttClient');
const { wss, sendToClients } = require('./webSocketServer');
const { sendNotificationAccident, sendNotificationStart } = require('./firebaseNotifications');

let isStatus = true;

mqtt_client.on('message', (topic, message) => {
    console.log(`Received message on ${topic}: ${message.toString()}`);

    let data;
    try {
        data = JSON.parse(message.toString());
    } catch (error) {
        console.error('Failed to parse message as JSON:', error);
        return;
    }

    if (data && data.hasOwnProperty('status')) {
        const status = data.status;
        const accChange = data.accchange;
        const longitude = data.longitude;
        const latitude = data.latitude;

        console.log('Status device:', status);
        console.log('Acceleration:', accChange);
        console.log('Longitude:', longitude);
        console.log('Latitude:', latitude);

        if (status && isStatus) {
            sendNotificationStart();
            isStatus = false;
        }

        if (accChange > 80) {
            sendNotificationAccident(accChange);
        }

        const wsData = {
            status: status,
            accChange: accChange,
            longitude: longitude,
            latitude: latitude
        };

        sendToClients(wsData);
    } else {
        console.error('Message does not contain required fields:', data);
    }
});
