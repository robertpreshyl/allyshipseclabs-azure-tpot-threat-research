{
    "name": "AllyshipGlobalLtd-NEU-nsg",
    "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg",
    "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
    "type": "Microsoft.Network/networkSecurityGroups",
    "location": "northeurope",
    "properties": {
        "provisioningState": "Succeeded",
        "resourceGuid": "b06b3527-4b76-4b4b-acd6-ac26d7b50cec",
        "securityRules": [
            {
                "name": "AllowCidrBlockCustom64295Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowCidrBlockCustom64295Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "protocol": "TCP",
                    "sourcePortRange": "*",
                    "destinationPortRange": "64295",
                    "sourceAddressPrefix": "<YOUR_PUBLIC_IP>",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 310,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowMyIpAddressCustom64297Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowMyIpAddressCustom64297Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "protocol": "TCP",
                    "sourcePortRange": "*",
                    "destinationPortRange": "64297",
                    "sourceAddressPrefix": "<YOUR_PUBLIC_IP>",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 320,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAnyCustom22Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowAnyCustom22Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "AllowSSHInbound",
                    "protocol": "TCP",
                    "sourcePortRange": "*",
                    "destinationPortRange": "22",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 330,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAnyCustom80Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowAnyCustom80Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Honeypot: Snare, Heralding (HTTP emulation)",
                    "protocol": "TCP",
                    "sourcePortRange": "*",
                    "destinationPortRange": "80",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 340,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAnyCustom443Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowAnyCustom443Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Honeypot: Heralding (HTTPS emulation)",
                    "protocol": "TCP",
                    "sourcePortRange": "*",
                    "destinationPortRange": "443",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 350,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAnyCustom53Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowAnyCustom53Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Honeypot: Ddospot (DNS amplification)",
                    "protocol": "UDP",
                    "sourcePortRange": "*",
                    "destinationPortRange": "53",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 360,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAnyCustom23Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowAnyCustom23Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Honeypot: Cowrie, Heralding (Telnet emulation)",
                    "protocol": "TCP",
                    "sourcePortRange": "*",
                    "destinationPortRange": "23",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 370,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAnyCustom110_143_993_995Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowAnyCustom110_143_993_995Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Honeypot: Heralding, qHoneypots",
                    "protocol": "TCP",
                    "sourcePortRange": "*",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 380,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [
                        "110",
                        "143",
                        "993",
                        "995"
                    ],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAnyCustom3389Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowAnyCustom3389Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Honeypot: qHoneypots (Windows RDP attacks)",
                    "protocol": "TCP",
                    "sourcePortRange": "*",
                    "destinationPortRange": "3389",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 390,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAnyCustom502_102_2404_47808Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowAnyCustom502_102_2404_47808Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Honeypot: Conpot (Industrial Control Systems - ICS)",
                    "protocol": "TCP",
                    "sourcePortRange": "*",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 400,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [
                        "502",
                        "102",
                        "2404",
                        "47808"
                    ],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAnyCustom161Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowAnyCustom161Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Honeypot: Conpot, qHoneypots (SNMP scanning)",
                    "protocol": "UDP",
                    "sourcePortRange": "*",
                    "destinationPortRange": "161",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 410,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAnyCustom3306Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowAnyCustom3306Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Honeypot: Dionaea, qHoneypots",
                    "protocol": "TCP",
                    "sourcePortRange": "*",
                    "destinationPortRange": "3306",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 420,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAnyCustom1433Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowAnyCustom1433Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Honeypot: Dionaea, qHoneypots",
                    "protocol": "TCP",
                    "sourcePortRange": "*",
                    "destinationPortRange": "1433",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 430,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAnyCustom1521Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowAnyCustom1521Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Honeypot: qHoneypots",
                    "protocol": "TCP",
                    "sourcePortRange": "*",
                    "destinationPortRange": "1521",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 440,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAnyCustom6379Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowAnyCustom6379Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Honeypot: Redishoneypot, qHoneypots",
                    "protocol": "TCP",
                    "sourcePortRange": "*",
                    "destinationPortRange": "6379",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 450,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAnyCustom5060Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowAnyCustom5060Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Honeypot: SentryPeer, qHoneypots (VoIP attacks)",
                    "protocol": "UDP",
                    "sourcePortRange": "*",
                    "destinationPortRange": "5060",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 460,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAnyCustom42_135_1723Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowAnyCustom42_135_1723Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Honeypot: Dionaea, qHoneypots",
                    "protocol": "*",
                    "sourcePortRange": "*",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 470,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [
                        "42",
                        "135",
                        "1723"
                    ],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAnyCustom8080_8443Inbound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/securityRules/AllowAnyCustom8080_8443Inbound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Honeypot: Go-pot, Galah, qHoneypots, CiscoASA",
                    "protocol": "*",
                    "sourcePortRange": "*",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 480,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [
                        "8080",
                        "8443"
                    ],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            }
        ],
        "defaultSecurityRules": [
            {
                "name": "AllowVnetInBound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/defaultSecurityRules/AllowVnetInBound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/defaultSecurityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Allow inbound traffic from all VMs in VNET",
                    "protocol": "*",
                    "sourcePortRange": "*",
                    "destinationPortRange": "*",
                    "sourceAddressPrefix": "VirtualNetwork",
                    "destinationAddressPrefix": "VirtualNetwork",
                    "access": "Allow",
                    "priority": 65000,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowAzureLoadBalancerInBound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/defaultSecurityRules/AllowAzureLoadBalancerInBound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/defaultSecurityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Allow inbound traffic from azure load balancer",
                    "protocol": "*",
                    "sourcePortRange": "*",
                    "destinationPortRange": "*",
                    "sourceAddressPrefix": "AzureLoadBalancer",
                    "destinationAddressPrefix": "*",
                    "access": "Allow",
                    "priority": 65001,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "DenyAllInBound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/defaultSecurityRules/DenyAllInBound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/defaultSecurityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Deny all inbound traffic",
                    "protocol": "*",
                    "sourcePortRange": "*",
                    "destinationPortRange": "*",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Deny",
                    "priority": 65500,
                    "direction": "Inbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowVnetOutBound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/defaultSecurityRules/AllowVnetOutBound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/defaultSecurityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Allow outbound traffic from all VMs to all VMs in VNET",
                    "protocol": "*",
                    "sourcePortRange": "*",
                    "destinationPortRange": "*",
                    "sourceAddressPrefix": "VirtualNetwork",
                    "destinationAddressPrefix": "VirtualNetwork",
                    "access": "Allow",
                    "priority": 65000,
                    "direction": "Outbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "AllowInternetOutBound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/defaultSecurityRules/AllowInternetOutBound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/defaultSecurityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Allow outbound traffic from all VMs to Internet",
                    "protocol": "*",
                    "sourcePortRange": "*",
                    "destinationPortRange": "*",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "Internet",
                    "access": "Allow",
                    "priority": 65001,
                    "direction": "Outbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            },
            {
                "name": "DenyAllOutBound",
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/AllyshipSecurityLabs/providers/Microsoft.Network/networkSecurityGroups/AllyshipGlobalLtd-NEU-nsg/defaultSecurityRules/DenyAllOutBound",
                "etag": "W/\"5f77bed3-232b-4720-8acf-9c88ea0f26e3\"",
                "type": "Microsoft.Network/networkSecurityGroups/defaultSecurityRules",
                "properties": {
                    "provisioningState": "Succeeded",
                    "description": "Deny all outbound traffic",
                    "protocol": "*",
                    "sourcePortRange": "*",
                    "destinationPortRange": "*",
                    "sourceAddressPrefix": "*",
                    "destinationAddressPrefix": "*",
                    "access": "Deny",
                    "priority": 65500,
                    "direction": "Outbound",
                    "sourcePortRanges": [],
                    "destinationPortRanges": [],
                    "sourceAddressPrefixes": [],
                    "destinationAddressPrefixes": []
                }
            }
        ],
        "networkInterfaces": [
            {
                "id": "/subscriptions/bd32dde4-b1e1-4a61-9101-55c588672f9d/resourceGroups/ALLYSHIPSECURITYLABS/providers/Microsoft.Network/networkInterfaces/ALLYSHIPGLOBALLTD-NEU812-635D3EDC"
            }
        ]
    },
    "apiVersion": "2023-09-01"
}