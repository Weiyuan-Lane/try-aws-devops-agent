import json
import os
import random
import sys
import time
from http.server import BaseHTTPRequestHandler, HTTPServer


class HealthHandler(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        return

    def do_GET(self):
        path = self.path.split("?", 1)[0]
        if path != "/healthcheck" and random.random() < float(os.environ.get("FAIL_RATE", "0.2")):
            print("Simulated failure: restarting task", flush=True)
            sys.stderr.flush()
            sys.stdout.flush()
            os._exit(1)

        time.sleep(0.1)
        body = json.dumps(True).encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


def main():
    port = int(os.environ.get("PORT", "8080"))
    server = HTTPServer(("0.0.0.0", port), HealthHandler)
    print(f"Listening on :{port}", flush=True)
    server.serve_forever()


if __name__ == "__main__":
    main()
