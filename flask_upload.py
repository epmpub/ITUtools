import json
import aiofiles
from flask import Flask, request

app = Flask(__name__)

@app.route('/data', methods=['GET', 'POST'])
async def data():
    if request.method == 'POST':

        json_string = json.dumps(request.json)

        async with aiofiles.open('data.json', 'a') as outfile:
            await outfile.write(json_string)

        return "POST"
    else:
        return "GET"


if __name__ == '__main__':
    app.run(port=2020, host="127.0.0.1", debug=True)