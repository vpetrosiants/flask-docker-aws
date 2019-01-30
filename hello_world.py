from flask import Flask, request, url_for
import datetime
import socket

app = Flask(__name__)

@app.route("/", methods=['GET'])
def hello_world():
    """
    List or create notes.
    """
    n = '<b>Today: </b>'+ str(datetime.datetime.now()) + "  <b>Hostname: </b>" + str(socket.gethostname())
    if request.method == 'GET':
        return 'Hello World!!!  %s' % n 

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=80)
