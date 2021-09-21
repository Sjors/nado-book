\newpage
## Taproot activation LOT=true vs FALSE

Listen to episode 29:

\qrcode{https://nadobtc.libsyn.com/explaining-taproot-activation-and-lottrue-vs-lotfalse-nado-29}

discuss activation of the Taproot soft fork upgrade, and more specifically, the lock-in on timeout (LOT) parameter. The LOT parameter can be set to either “true” (LOT=true) or “false” (LOT=false).

LOT=false resembles how several previous soft forks were activated. Miners would have one year to coordinate Taproot activation through hash power; if and when a supermajority (probably 90 percent) of miners signal readiness for the upgrade, the soft fork will activate. But if this doesn’t happen within (probably) a year, the upgrade will expire. (After which it could be redeployed.)LOT=true also lets miners activate the soft fork through hash power, but if they fail to do this within that year, nodes will activate the soft fork regardless.Aaron and Sjors discuss the benefits and detriments of each option. This also includes some possible scenarios of what could happen if some users set LOT to true, while other users set LOT to false, and the associated risks. Finally, Aaron and Sjors discuss what they think is most likely going to happen with Taproot activation.
