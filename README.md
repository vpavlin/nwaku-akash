# Waku Node on Akash Network

This repository show how to run a [waku node](https://github.com/waku-org/nwaku) on [Akash Network](https://akash.network) - an open-source Supercloud that lets users buy and sell computing resources securely and efficiently. Purpose-built for public utility.

You can find multiple different deplyoment manifests in this repository - they all deploy a Waku node, but with different set of features enabled and thus different requirements and cost.

# Minimal (`deployment.minimal.yaml`)

This is a minimal useful deployment of a Waku node. It only enables the `relay` protocol, which is a backbone of the whole peer-to-peer network. You can use [CLI](https://docs.akash.network/guides/cli) or [Cloudmos](https://docs.akash.network/guides/cloudmos-deploy) for deployment 

You may notice one line in the [YAML file](./deployment.minimal.yaml) is commented out 

```
#- --nat:extip:${MY_IP}
``` 

This is because we do not know our public IP address up front, so once the first deployment is done (i.e. you request a lease, accept a bid and the deployment succeeds), you'll need to get the IP (CLI: https://docs.akash.network/features/ip-leases/ip-leases-verification, or from Cloudmos web UI) and replace `{MY_IP}` with the actual value and update your deployment.

After it restarts, you can verify you can connect to your node using the `wakucanary` tools.

# Full (`deployment.full.yaml`)

This is a more complete deployment of a Waku node. It not only enables `relay` protocols, but also additional services - `lightpush`, `filter` and `store` protocols which are useful for adaptive or resource restricted devices (think apps running on mobile phones or laptops).

This deployment uses `sqlite` as an archive backend for `store` protocol, to avoid deploying an extra Postgres container.

It also enables secure websockets (WSS) and uses [Let's Encrypt](https://https://letsencrypt.org/) to produce SSL certificate and key. For this we need a `domain` to be provided to the node, which makes the deployment a tiny bit more complicated, so let's go through it.

First step is to get your domain ready (e.g. waku.myrandomdemos.online). You need to be able to set DNS A record on the domain for this deployment to work properly.

Same as with the `minimal` deployment, we need to get the IP address first, so we need to deploy the node using the [deployment.full.yaml](./deployment.full.yaml).

Once you accepted a provider bid and got the IP lease, configure your domain A record to point to that IP address. You can use tools like `dig` or `nslookup` to verify that it's configured properly 

```
$ nslookup waku.myrandomdemos.online
Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
Name:	waku.myrandomdemos.online
Address: 184.105.162.181
```

Next we need to update the deployment with the configured domain - set the domain name as a value for `DOMAIN` variable in the `env` section of your deployment manifest and deploy the update.

Once the container is running, you can review the logs and find the multiaddress of your node:

e.g.
```
[node]: INF 2023-08-11 15:51:40.700+00:00 Listening on                               topics="waku node" tid=1 file=waku_node.nim:803 full=[/dns4/waku.myrandomdemos.online/tcp/60000/p2p/16Uiu2HAm8LC9icGccYeNUre2mZ1GJpshVm6C3xKEpvcsXQPDga4o][/dns4/waku.myrandomdemos.online/tcp/8000/wss/p2p/16Uiu2HAm8LC9icGccYeNUre2mZ1GJpshVm6C3xKEpvcsXQPDga4o]
```

And use the `WSS` address with [light-js demo](https://examples.waku.org/light-js/) to try to communicate with your node.