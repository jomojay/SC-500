# Day 6 - Hub-spoke network foundation

**Time:** 90 minutes  
**Mode:** Hands-on  
**SC-500:** secure network architecture, segmentation, IaC

## Business request

The public portal, internal application, AKS, and data services must not share one flat network. NCES also needs a central path for inspection services without paying for them all month.

## Build

Create the address spaces from [architecture](../docs/architecture.md):

- hub `10.20.0.0/16`;
- app spoke `10.21.0.0/16`;
- AKS spoke `10.22.0.0/16`.

Create the named subnets, reserving the exact `AzureFirewallSubnet` and `AzureBastionSubnet` names. Do not attach an NSG to the private-endpoint subnet until you deliberately enable private-endpoint network policies.

The template creates these NSGs with no custom rules (Azure's default NSG rules still apply) and attaches them to the indicated subnets:

| NSG | Subnet |
|---|---|
| `nsg-app` | `snet-app` |
| `nsg-shared` | `snet-shared` |
| `nsg-aks` | `snet-aks` |

Peer hub to both spokes. Do not enable gateway transit because no gateway exists. Create route tables that document the future inspection path but do not point production traffic to a nonexistent firewall. The template creates `rt-future-inspection-app` and `rt-future-inspection-aks` with gateway-route propagation disabled; neither table is associated with a subnet.

Deploy the networking foundation into the existing `rg-sc500-core-cc` resource group. The parameter file sets both the target resource group and the resource location; the subscription deployment `--location` is the location for Azure's deployment record:

```bash
az deployment sub create \
  --location canadacentral \
  --template-file IaC/networking-foundations/main.bicep \
  --parameters @IaC/networking-foundations/main.parameters.json
```

The target resource group must already exist (create it with `scripts/bootstrap.sh` if needed). Running the deployment again updates the resources declared by the template; it does not delete unrelated resources in the group. The template sets the NSGs' custom security rule lists to empty, so add/manage custom rules separately only after considering that a later template deployment will reconcile those lists.

Create a network flow table:

| Source | Destination | Port | Decision | Reason |
|---|---|---:|---|---|
| Partner internet | WAF ingress | 443 | Allow | public service |
| App subnet | SQL private endpoint | 1433 | Allow | application data |
| App subnet | Key Vault private endpoint | 443 | Allow | secret retrieval |
| AKS subnet | Foundry/API Gateway | 443 | Allow | AI inference |
| Any workload | Management subnet | Any | Deny | prevent reverse administration |
| Internet | Data subnet/endpoints | Any | Deny | no public data plane |

## Verification

```bash
az network vnet list --query "[].{name:name,address:addressSpace.addressPrefixes,rg:resourceGroup}" --output table
az network vnet peering list --resource-group rg-sc500-core-cc --vnet-name vnet-sc500-hub --output table
```

Use Network Watcher topology to confirm intended relationships. Explain that peering is nontransitive.

## Cost and cleanup

VNets, subnets, NSGs, route tables, and peering have no hourly gateway charge. Keep them through day 30. Do not deploy Firewall, Bastion, NAT Gateway, VPN Gateway, or Virtual WAN today.

## Sources

- [Hub-spoke topology](https://learn.microsoft.com/azure/architecture/networking/architecture/hub-spoke)
- [Virtual network peering](https://learn.microsoft.com/azure/virtual-network/virtual-network-peering-overview)
- [Private endpoint network policies](https://learn.microsoft.com/azure/private-link/disable-private-endpoint-network-policy)
