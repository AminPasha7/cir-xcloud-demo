import google.auth
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

def _rule_name(cir):
    port = cir["resources"]["gcp"].get("port", 22)
    return f"cir-{cir['id']}-{port}"

def simulate_gcp(cir):
    # Project from ADC (Cloud Run SA)
    _, project = google.auth.default()
    return {"would_create_rule": _rule_name(cir), "project": project}

def apply_gcp(cir):
    creds, project = google.auth.default()
    g = cir["resources"]["gcp"]
    name = _rule_name(cir)

    body = {
        "name": name,
        "network": f"projects/{project}/global/networks/{g.get('vpc','default')}",
        "allowed": [{"IPProtocol": "tcp", "ports": [str(g.get('port',22))]}],
        "sourceRanges": [g.get("cidr","10.0.0.0/8")],
        "targetTags": [g.get("tag","cir-demo")]
    }

    try:
        compute = build("compute", "v1", credentials=creds, cache_discovery=False)
        op = compute.firewalls().insert(project=project, body=body).execute()
        return {"operation": op.get("name"), "project": project, "rule": name}
    except HttpError as e:
        # If it already exists, surface a friendly message
        return {"error": getattr(e, "reason", "HttpError"), "status": getattr(e, "resp", {}).status if hasattr(e, "resp") else None, "message": getattr(e, "_get_reason", lambda: str(e))()}
