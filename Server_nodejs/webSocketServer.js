const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 8080 });

wss.on('connection', ws => {
    console.log('New WebSocket connection');
    ws.send(JSON.stringify({ message: 'WebSocket connected' }));
});

wss.on('close', () => {
    console.log('WebSocket connection closed');
});

function sendToClients(data) {
    wss.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(JSON.stringify(data));
        }
    });
}

module.exports = { wss, sendToClients };
