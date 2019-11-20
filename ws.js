const wsa = new window.WebSocket('ws://localhost:9000', 'wa-event');
wsa.onmessage = function(msg) {
  console.log('[wsa#msg]', msg.data);
};
wsa.onerror = function(msg) {
  console.error('wsa#err');
  console.debug(msg);
};
var Main = function() {
  Notification.requestPermission();
  WebSocket.prototype._send = WebSocket.prototype.send;

  WebSocket.prototype.send = function(data) {
    this._send(data);
    console.log('[WebSocket#send]', data);

    this.addEventListener('message', function(msg) {
      console.log('[WebSocket#msg]', data);
      wsa.send(data);
    }, false);

    this.send = function(data) {
      this._send(data);         
    };
  }
};

Main();
