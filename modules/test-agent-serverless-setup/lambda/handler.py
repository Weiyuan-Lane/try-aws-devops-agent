import json
import os
import time
import urllib.error
import urllib.request


def _query_params(event):
    params = event.get("queryStringParameters") or {}
    return {k: str(v).lower() for k, v in params.items() if v is not None}


def _response(status_code, body):
    return {
        "statusCode": status_code,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body) if not isinstance(body, str) else body,
    }


def handler(event, context):
    params = _query_params(event)
    fail = params.get("fail") == "true"
    proxy = params.get("proxy") == "true"

    if fail:
        time.sleep(1)
        return _response(500, {"ok": False, "error": "fail requested"})

    if proxy:
        base_url = os.environ["FARGATE_INTERNAL_URL"].rstrip("/")
        request = urllib.request.Request(base_url, method="GET")
        try:
            with urllib.request.urlopen(request, timeout=15) as response:
                body = response.read().decode("utf-8")
                try:
                    payload = json.loads(body)
                except json.JSONDecodeError:
                    payload = body
                return _response(response.status, payload)
        except urllib.error.HTTPError as exc:
            body = exc.read().decode("utf-8")
            try:
                payload = json.loads(body)
            except json.JSONDecodeError:
                payload = {"error": body or str(exc)}
            return _response(exc.code, payload)
        except Exception as exc:
            return _response(502, {"ok": False, "error": str(exc)})

    time.sleep(0.5)
    return _response(200, True)
