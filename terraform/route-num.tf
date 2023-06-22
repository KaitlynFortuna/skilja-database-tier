resource "aws_route53_record" "exturl" {
  zone_id = data.aws_ssm_parameter.r53_id.value
  name    = "${local.build_id}.${data.aws_ssm_parameter.r53_name.value}"
  type    = "A"
  alias {
    name                   = aws_lb.nlb.dns_name
    zone_id                = aws_lb.nlb.zone_id
    evaluate_target_health = false
  }
}

module "route53" {

  source  = "terraform-aws-modules/route53/aws"
  version = "2.10.2"

}

resource "aws_internet_gateway" "gw" {

  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "main"
  }

  depends_on = [module.vpc, module.route53]

}
