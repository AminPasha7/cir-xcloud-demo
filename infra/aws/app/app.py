import json, os, urllib.request

GCP_URL = os.environ["GCP_TRANSLATOR_URL"]

def lambda_handler(event, context):
    # translate event -> CIR (demo CIR pulled from event or default)
    cir = event.get("detail", {
        "version": "0.1",
        "id": "demo-allow-ssh",
        "mode": "enforce",
        "conditions": { "event.type": "demo.trigger" },
        "action": "allow_ingress",
        "resources": {
            "gcp": { "vpc": "default", "tag": "cir-demo", "cidr": "10.10.0.0/16", "port": 22 }
        }
    })
    data = json.dumps(cir).encode("utf-8")
    req = urllib.request.Request(GCP_URL.rstrip("/") + "/apply", data=data, headers={"Content-Type":"application/json"})
    with urllib.request.urlopen(req) as resp:
        body = resp.read().decode("utf-8")
    return {"ok": True, "upstream": body}
