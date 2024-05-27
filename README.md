<a href="![Github (2)](https://github.com/memphisdev/memphis.js/assets/107035359/731a59be-0f46-4a94-84c3-c0b2a07fe01c)">![Github (2)](https://github.com/memphisdev/memphis.js/assets/107035359/281222f9-8f93-4a20-9de8-7c26541bded7)</a>
<p align="center">
<a href="https://memphis.dev/discord"><img src="https://img.shields.io/discord/963333392844328961?color=6557ff&label=discord" alt="Discord"></a>
<a href="https://github.com/memphisdev/memphis/issues?q=is%3Aissue+is%3Aclosed"><img src="https://img.shields.io/github/issues-closed/memphisdev/memphis?color=6557ff"></a> 
  <img src="https://img.shields.io/npm/dw/memphis-dev?color=ffc633&label=installations">
<a href="https://github.com/memphisdev/memphis/blob/master/CODE_OF_CONDUCT.md"><img src="https://img.shields.io/badge/Code%20of%20Conduct-v1.0-ff69b4.svg?color=ffc633" alt="Code Of Conduct"></a> 
<img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/memphisdev/memphis?color=61dfc6">
<img src="https://img.shields.io/github/last-commit/memphisdev/memphis?color=61dfc6&label=last%20commit">
</p>

<div align="center">
  
  <img width="200" alt="CNCF Silver Member" src="https://github.com/cncf/artwork/raw/master/other/cncf-member/silver/color/cncf-member-silver-color.svg#gh-light-mode-only">
  <img width="200" alt="CNCF Silver Member" src="https://github.com/cncf/artwork/raw/master/other/cncf-member/silver/white/cncf-member-silver-white.svg#gh-dark-mode-only">
  
</div>
 <b><p align="center">
  <a href="https://memphis.dev/pricing/">Cloud</a> - <a href="https://memphis.dev/docs/">Docs</a> - <a href="https://twitter.com/Memphis_Dev">X</a> - <a href="https://www.youtube.com/channel/UCVdMDLCSxXOqtgrBaRUHKKg">YouTube</a>
</p></b>

<div align="center">

  <h4>

**[Memphis.dev](https://memphis.dev)** is a highly scalable, painless, and effortless data streaming platform.<br>
Made to enable developers and data teams to collaborate and build<br>
real-time and streaming apps fast.

  </h4>
  
</div>

# Memphis docker deployment

---
description: Deploy Memphis over Docker using Docker compose
---


## Requirements

**Requirements (No HA)**

| Resource | Quantity               |
| -------- | ---------------------- |
| OS       | Mac / Windows / Linux  |
| CPU      | 1 CPU                  |
| Memory   | 4GB                    |
| Storage  | 6GB                    |

**Please make sure you have** [**docker-compose**](https://docs.docker.com/compose/) **installed.**

## Getting started

### Step 1: Download compose.yaml file

```
curl -s https://superstreamlabs.github.io/memphis-docker/docker-compose.yml -o docker-compose.yml
```

### Step 2: Run the compose

```
docker compose -f docker-compose.yml -p memphis up
```

Output:

```
[+] Running 3/3
 ⠿ Container memphis-memphis-1        Creating                                                      0.2s                                                      0.2s                                                  0.2s
 ⠿ Container memphis-memphis-metadata-1          Creating                                                      0.2s
 ⠿ memphis-memphis-rest-gateway-1
 
```

#### Deployed Containers

* **memphis-1:** The broker itself which acts as the data storage layer. That is the component that stores and controls the ingested messages and their entire lifecycle management.
* **memphis-metadata-1:** Responsible for storing the platform metadata only, such as general information, monitoring, GUI state, and pointers to dead-letter messages. The metadata store uses Postgres.
* **memphis-rest-gateway-1:** Responsible for exposing Memphis management and data ingestion through REST requests.

### Step 3: Access via UI / SDK

The default port of the UI is 9000:

```
http://localhost:9000
```

**Default Username:** root

**Default Password**: memphis

####

#### Memphis Node.JS SDK can be used to demonstrate the required parameters.

```
await memphis.connect({
            host: "MEMPHIS_BROKER_HOSTNAME",
            port: PORT, // Can be removed if using the default 6666
            username: "APPLICATION_TYPE_USERNAME",
            connectionToken: "<connection_token>" || password: "PASSWORD"
});
```

* **host:** Usually the control plane or through the UI URL. For example "https://memphis-ui.test.com/api".
* **username:** Usually "root". Head to the users' section via the UI or CLI to add more.
* **connectionToken:** Each app that produces and/or consumer data with Memphis uses token authentication. <mark style="color:green;">**The default value is "memphis".**</mark>

## How to upgrade?

### Step 1: shutdown Memphis containers

```bash
docker rm -f $(docker ps -a | grep -i memphis | awk '{print $1}')
```

### Step 2: remove memphis docker images

```bash
docker image rm -f $(docker image ls | grep -i memphis)
```

### Step 3: Reinstall memphis

```bash
curl -s https://memphisdev.github.io/memphis-docker/docker-compose.yml -o docker-compose.yml && docker compose -f docker-compose.yml -p memphis up
```
