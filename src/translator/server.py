from fastapi import FastAPI, Request
from translator.gcp_codegen import apply_gcp, simulate_gcp
app = FastAPI()
@app.post("/apply")
async def apply(req: Request):
    cir = await req.json()
    if cir.get("mode","enforce")=="dry-run":
        return {"ok": True, "dry_run": simulate_gcp(cir)}
    return {"ok": True, "result": apply_gcp(cir)}
@app.post("/simulate")
async def simulate(req: Request):
    cir = await req.json()
    return {"ok": True, "plan": simulate_gcp(cir)}
