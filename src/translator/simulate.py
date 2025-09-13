from translator.gcp_codegen import simulate_gcp
from translator.aws_codegen import simulate_aws
def simulate(cir, target):
    return simulate_gcp(cir) if target=="gcp" else simulate_aws(cir)
