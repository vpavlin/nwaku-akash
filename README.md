# Waku Node on Akash Network

This repository show how to run a [waku node](https://github.com/waku-org/nwaku) on [Akash Network](https://akash.network) - an open-source Supercloud that lets users buy and sell computing resources securely and efficiently. Purpose-built for public utility.

You can find multiple different deplyoment manifests in this repository - they all deploy a Waku node, but with different set of features enabled and thus different requirements and cost.

You can use [CLI](https://docs.akash.network/guides/cli) or [Cloudmos](https://docs.akash.network/guides/cloudmos-deploy) for deployment.

# Getting Started

Since introduction of Rate-Limiting Nullifiers (RLN) into The Waku Network, the `nwaku` node needs to verify membership of message publishers. For that it needs a Sepolia RPC Node. You need to provide the URL for such node in `ETH_CLIENT_ADDRESS` in the deployment YAML.

If you also plan to use the node to publish messages, you will need to obtain the membership yourself. For that you can use a helper script in [nwaku-compose](https://github.com/waku-org/nwaku-compose/blob/master/register_rln.sh) which allows you to register the membership and produces `keystore.json` file. You will need to encode the content of this file with `base64` encoding and pass it into the deployment fail as `RLN_RELAY_CRED_BASE64`.

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