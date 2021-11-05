\newpage
## Erebus attack

![Ep. 18 {l0pt}](qr/18.png)

discuss the Erebus Attack. The episode is a follow-up from last week’s episode on Eclipse Attacks, a type of attack that isolates a Bitcoin node by occupying all of its connection slots to block the node from receiving any transactions. Erebus Attacks are Eclipse Attacks where an attacker essentially spoofs a whole part of the internet.

The internet is made up of Autonomous Systems, basically clusters of IP-addresses owned by the same entity, like an ISP. Last week, the hosts explained how Bitcoin Core nodes can counter Eclipse Attacks by ensuring that they are connected to a variety of IP addresses from different Autonomous Systems. As it turns out, however, some Autonomous Systems can effectively act as bottlenecks when trying to reach other Autonomous Systems.

This allows an attacker controlling such a bottleneck to launch a successful Eclipse Attack even against nodes that connect with multiple Autonomous Systems.

Since its most recent release, Bitcoin Core includes an optional feature — ASMAP — to counter these types of Eclipse Attacks. The hosts explain how mapping of the internet has allowed Bitcoin Core contributors to create a tool which ensures that Bitcoin nodes not only connect to various Autonomous Systems, but also ensures that they avoid being trapped behind said bottlenecks.
