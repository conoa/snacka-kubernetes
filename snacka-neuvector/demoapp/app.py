"""An unsafe demo application."""

import flask

app = flask.Flask(__name__)

@app.route("/calc", methods=["POST"])
def unsafe_demo():
    data = flask.request.get_json()
    expression = f"result = {data.get('expression', '')}"
    local_values = {}
    exec(expression, globals(), local_values)
    return flask.jsonify({"response": local_values["result"]})
