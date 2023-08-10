# Waku Node on Akash Network

This repository show how to run a [waku node](https://github.com/waku-org/nwaku) on [Akash Network](https://akash.network) - an open-source Supercloud that lets users buy and sell computing resources securely and efficiently. Purpose-built for public utility.

You can find multiple different deplyoment manifests in this repository - they all deploy a Waku node, but with different set of features enabled and thus different requirements and cost.

# Minimal (`deployment.minimal.yaml`)

This is a minimal useful deployment of Waku node. It only enables the `relay` protocol, which is a backbone of the whole peer-to-peer network. You can use [CLI](https://docs.akash.network/guides/cli) or [Cloudmos](https://docs.akash.network/guides/cloudmos-deploy) for deployment 

You may notice one line in the [YAML file](./deployment.minimal.yaml) is commented out 

```
#- --nat:extip:${MY_IP}
``` 

This is because we do not know our public IP address up front, so once the first deployment is done (i.e. you request a lease, accept a bid and the deployment succeeds), you'll need to get the IP (CLI: https://docs.akash.network/features/ip-leases/ip-leases-verification, or from Cloudmos web UI) and replace `{MY_IP}` with the actual value and update your deployment.

After it restarts, you can verify you can connect to your node using the `wakucanary` tools.