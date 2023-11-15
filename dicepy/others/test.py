import netifaces

gateways = netifaces.gateways()
gateway_padrao = gateways['default'][netifaces.AF_INET][0]
print(gateway_padrao)