import boto3
def simulate_aws(cir):
    a = cir["resources"]["aws"]; return {"would_authorize_sg_ingress_for": a.get("sg_id",""), "port": a.get("port",22)}
def apply_aws(cir):
    a = cir["resources"]["aws"]; ec2 = boto3.client("ec2")
    return ec2.authorize_security_group_ingress(
        GroupId=a["sg_id"],
        IpPermissions=[{"IpProtocol":"tcp","FromPort":a.get("port",22),"ToPort":a.get("port",22),
                        "IpRanges":[{"CidrIp":a.get("cidr","10.0.0.0/8"),"Description":"cir-demo"}]}])
