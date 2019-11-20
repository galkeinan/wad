var wsa = new window.WebSocket('ws://localhost:9000', 'wa-event');
wsa.onmessage = function(msg) {
  console.log('[wsa#msg]', msg.data);
};
wsa.onerror = function(msg) {
  console.error('[wsa#err]');
  console.debug(msg);
};

(function() {
  WebSocket.prototype._send = WebSocket.prototype.send;
  WebSocket.prototype.send = function(data) {
    this._send(data);

    this.addEventListener('message', function(msg) {
      console.log('>> ' + msg.data);
      if (msg.data && msg.data.includes('Presence')) {
        wsa.send(msg.data);    
      }
    }, false);

    this.send = function(data) {
      this._send(data);
      console.log("<< " + data);
    };
  }
})();
