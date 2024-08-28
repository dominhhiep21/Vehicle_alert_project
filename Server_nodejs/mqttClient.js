const mqtt = require('mqtt');

const mqtt_broker = 'broker.emqx.io';
const mqtt_port = 1883;
const mqtt_topic_accChange = 'esp8266/device';

const mqtt_client = mqtt.connect(`mqtt://${mqtt_broker}:${mqtt_port}`);

mqtt_client.on('connect', () => {
    console.log('Connected to MQTT broker');
    mqtt_client.subscribe(mqtt_topic_accChange, (err) => {
        if (err) {
            console.error('Failed to subscribe:', err);
        }
    });
});

module.exports = mqtt_client;
