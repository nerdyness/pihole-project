# Pihole-project
I started this project to get hands-on with AWS Analytics services such as [AWS Glue](https://aws.amazon.com/glue/), [Amazon Athena ](https://aws.amazon.com/athena/), and [Amazon QuickSight](https://aws.amazon.com/quicksight/).

I find it's always better to have a real project to work with instead of just clicking through the services so I went and bought myself a [Raspberry Pi4](https://www.amazon.de/-/en/Raspberry-ARM-Cortex-A72-WLAN-ac-Bluetooth-Micro-HDMI-Single/dp/B07TC2BK1X/) with the intention to run [Pi-Hole](https://pi-hole.net/) on it.

[Pi-Hole](https://pi-hole.net/) is this amazing open-source project which you can install on a Raspberry Pi and then route all your DNS requests to. It will subscribe to community maintained deny lists and block all add requests at the DNS level, basically acting as a DNS black-hole service.

I chose to install this [as a container](./docker-compose.yml#L5-L22) using [docker-compose](https://docs.docker.com/compose/). My idea was from the beginning to get the data from Pi-hole and run some analytics on it, so I made sure the project had an [API](https://discourse.pi-hole.net/t/api-question/29982) and wrote myself an [API Client (in Ruby)](./upload/app.rb) and packaged it up as a container using [this Dockerfile](./upload/Dockerfile) and also added it to [docker-compose as "upload"](./docker-compose.yml#L24-L31). This container connects to the API and uploads the data into an S3 bucket in my AWS account. I've made sure to keep the data in the incredibly hard to work-with format that it comes in, a JSON structure with one key called "data" and then a nested array in it. i.e.:
```
{"data":[["1613433600","PTR","27.22.22.172.in-addr.arpa","localhost","3","0","0","0","N/A","-1","N/A"],["1613433600","PTR","3.22.22.172.in-addr.arpa","localhost","3","0","0","0","N/A","-1","N/A"],["1613433600","PTR","32.22.22.172.in-addr.arpa","localhost","3","0","0","0","N/A","-1","N/A"],["1613433600","PTR","28.22.22.172.in-addr.arpa","localhost","3","0","0","0","N/A","-1","N/A"],["1613433600","PTR","22.22.22.172.in-addr.arpa","localhost","3","0","0","0","N/A","-1","N/A"],["1613433600","PTR","24.22.22.172.in-addr.arpa","localhost","3","0","0","0","N/A","-1","N/A"],["1613433600","PTR","29.22.22.172.in-addr.arpa","localhost","3","0","0","0","N/A","-1","N/A"],["1613433600","PTR","1.22.22.172.in-addr.arpa","localhost","3","0","0","0","N/A","-1","N/A"],["1613433608","AAAA","cdn-0.nflximg.com","firetv.sk.lan","2","0","0","0","N/A","-1","router.sk.lan#53"],["1613433612","A","cdn-0.nflximg.com","firetv.sk.lan","2","0","0","0","N/A","-1","router.sk.lan#53"]]}
```

The reason I kept the data in this challenging format is because I wanted to learn more about PySpark, one of the supported languages on AWS Glue (among plain old Python and Scala). This gave me the chance to really dive into [PySpark](https://spark.apache.org/docs/latest/api/python/index.html) as a solution and come up with [this AWS Glue PySpark Job](./aws-glue/pi-hole-process.pyspark). It wasn't straight forward and it took me some time to get my head around how this works but eventually I got this working, [AWS Glue Bookmarks](https://docs.aws.amazon.com/glue/latest/dg/monitor-continuations.html) and all! In short, this job reads all the data from my source S3 bucket that hasn't been read yet, applies some transformations to it, and then dumps it in [Parquet format](https://parquet.apache.org/) using [snappy compression](http://google.github.io/snappy/) into my target S3 bucket.

From there I can use [Amazon Athena ](https://aws.amazon.com/athena/) for ad-hoc analysis of the data, or use [Amazon QuickSight](https://aws.amazon.com/quicksight/) to build beautiful dashboards or analyse the data further.

---
**NOTE:** Since I have the raspberry Pi and it's always on, I've started adding other projects to it like using [openVPN](./docker-compose.yml#L33-L42) and a [DynDNS](./docker-compose.yml#L44-L49) service.
