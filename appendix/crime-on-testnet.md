## A crime on Testnet {#sec:crime_on_testnet}

_This dystopian fiction, which explains the basics of blockchain
analytics, was originally published as a blog post._^[<https://sprovoost.nl/2018/12/28/a-crime-on-testnet-6d95ede8da03/>]
\

On a warm summer day I crave a frappuccino. Unfortunately drugs such as caffeine, sugar and cacao were declared illegal decades ago. This happened because young unemployed college graduates often felt triggered by loud caffeinated rich people. Sugar was causing mass obesity and was also a carcinogen. Cacao was too clearly associated with oppression. These days hardly anyone remembers the reasons, they’re just shown pictures of cocaine addicts and are told cacao is a gateway drug to that.

Fortunately I know a guy, and he charges 0.002,000,-- bitcoin. I spin up my Bitcoin Core wallet, because I like the retro look. It doesn’t even use comma’s after the decimal separator, something we all got used to during the hyper-deflation era. Some people would just say 2,000 Bitcoin, but don’t say that anywhere near a Core church!

\newpage
First I need to buy some Bitcoin. Bitcoin in Europe is a bit like guns in the USA. A lot of people don’t like it, others love it, but it’s perfectly legal. So I surf to bitonic.nl to buy a little more than I need:

![](appendix/buy.png){ width=40% }

I pay with iDEAL, which is used for all online (fiat) shopping. They need a Bitcoin address to send it to, which I obtain from my Bitcoin Core wallet:

![](appendix/core-2.png){ width=100% }
\newpage
I click Request payment and get an address:

![[tb1q9jdtpsqxaqd8am70a7g67xn05y9x6dzremuydk](https://blockstream.info/testnet/address/tb1q9jdtpsqxaqd8am70a7g67xn05y9x6dzremuydk)](appendix/core-3.png){ width=30% }

I copy the address into the Bitonic form under “Your bitcoinaddress”, ignore all the warnings my banking app gives, and finish the €10 payment. A few moments later Bitcoin Core tells me that I received 0.003,247,40 BTC on the address that I labeled “Buy Bitcoin” and that I gave to Bitonic (tb1q9jdtps…):

![](appendix/core-4.png){ width=100% }

While I wait for the transaction to confirm on the blockchain, I walk to my guy, let’s call him Dmitry even though that’s racist. He opens his own wallet and gives me an address (tb1qnm…), which I enter into my wallet in order to send him 0.0002,000,-- BTC.

![](appendix/core-5.png){ width=100% }

Dmitry knows where I live, so he doesn’t wait for confirmation and just gives me the frap. We could have used Lightning to make the payment go through instantly without having to wait for confirmation. Lightning also doesn’t leave the same traces on the blockchain, so it could have prevented the pain soon to come. But we didn’t.

So now my wallet looks like this and that should be where the story ends for me:

![](appendix/core-6.png){ width=100% }

Dmitry in the mean time sells a bunch of fraps to different customers, giving each one a unique address. Their wallets will look exactly the same as mine. At the end of the day, Dmitry’s wallet looks like this:

![](appendix/core-7.png){ width=100% }
\newpage
Dmitry wants to buy some alcohol, the only drug that’s still legal, despite the violence, broken families, destroyed careers, crime, disease and mass road casualties it caused, especially after AI cars were banned. This was partially because AI cars enriched the big corporations that leased them out to the poor - who previously couldn’t afford a car - but what really broke the camels back was the ISIS hack that killed 15 million people during their work commute.

Alcohol is only for sale in supermarkets and in order to monitor population health, you’re strongly encouraged to buy food with your bank card. This gives insurance companies a precise overview of how many calories you and your family are consuming, and municipal health workers use this data to pro-actively put problematic people on a diet. Privacy activists cried wolf about this as usual, but the policy never caused any real issues and the health statistics speak for themselves. There was a proposal to allow Bitcoin payments in supermarkets by taking a passport scan, like with cash, but this lead to GDPR problems.

Anyway, why doesn’t Dmitry just use Bitonic to sell his coins? Well, because he has a criminal record for selling caffeine and people with criminal records are barred from buying and selling Bitcoin. Enter Kees, the main character in our story. Kees is a Bitcoin trader and he offers to buy Dmitry’s coins for 10% below their market price.

So Dmitry now has an empty wallet and Kees received just a little under 0.006,000,-- BTC in his wallet (miners take a small fee to process each transaction):

![](appendix/core-8.png){ width=100% }

Kees has a problem. He’s being watched. Soon after the trade with Dmitry an undercover cop offers to sell 0.001,000,-- BTC. Kees offers him cash at 10% below the market price and gives the address tb1q3nf… Now his wallet looks like this:

![](appendix/core-9.png){ width=100% }

Unbeknownst to Kees, Dmitry was caught on camera selling coffee that day, he was arrested on his way out of the supermarket. His (empty) Bitcoin wallet was confiscated, as was his now empty fiat wallet and what was left in the liquor bottle. The wallet contained transactions and notes as you can see above. The timing of each transaction coincided with the camera footage, the amount matched the well known price of fraps, and the notes even said it was fraps. The wallet also shows the destination address where Dmitry sent the BTC (tb1qja…), which the police suspect belongs to Kees. They suspect Dmitry sold the coins in exchange for cash, though they were too late to find the cash.

Kees is not arrested yet and so nobody knows what his Bitcoin addresses are. A privacy activist approaches him, because he wants to buy Bitcoin and doesn’t want the kind of surveillance that comes with buying coins online with iDeal. He has no intention of committing any crime whatsoever, not even tax evasion. He withdraws some of his hard and legally earned cash from an ATM. He then endures the long phone interrogation by his bank that always follows such behavior. He then negotiates a nice 3% fee above market rate. Kees sends him the coins, so Kees’ wallet now looks like this (2 buys, 1 sell):

![](appendix/core-10.png){ width=100% }

Meanwhile our police officer, let’s call him Donald, goes online and looks up the address used in his trade with Kees (tb1q3nf…). Bitcoin Core doesn’t support address lookups, because it doesn’t scale well and as Wladimir van der Laan put it “bitcoin core is not meant as a chain analysis platform”. His favorite block explorer blockchain.com doesn’t support bech32 address lookups, so he goes to a competitor:

![](appendix/explorer.png){ width=100% }

This page describes transactions related to the tb1q3nf… address. He suspects this address belongs to Kees, because it’s the address Kees gave him to send coins to.

Reading from bottom to top, at 13:51:15 officer Donald sees coins from his own address (tb1qjy4…, blue) go to this address (again: tb1q3nf…, yellow, the address Kees gave him). He also sees coins going back to his own wallet as change (tb1q80q…, also blue).

Above, at 14:01:03, he sees his coins (again: tb1q3nf…, this time blue) combined with coins from Dmitry’s wallet which was confiscated earlier (red). The coins go to some unknown address (which we know is the privacy activist).

This act of combining coins is crucial. If Kees had sold the undercover police coins seperate from Dmitry’s coins, there would have been no visible link between them.

Donald picks up a paper written ages ago in 2013 called A Fistful of Bitcoins, which says the following:^[<https://cseweb.ucsd.edu/~smeiklejohn/files/imc13.pdf>]

> HEURISTIC 1. If two (or more) addresses are inputs to the same transaction, they are controlled by the same user; i.e., for any transaction t, all pk E inputs(t) are controlled by the same user.

Well, that looks really scientific! Never mind that a heuristic is just that, a heuristic, not a fact. In his report, he also decides to leave out sentences like the following:

> Finally, we emphasize that our definition of address control is quite different from account ownership; for example, we consider a wallet service such as Instawallet to be the controller of each of the addresses it generates, even though the funds in these addresses are owned by a wide variety of distinct users.

In this case of course we know the heuristic was correct, because we’ve seen Kees’ wallet. But Kees used encryption and his wallet is safe. He uses his right to remain silent. Not always a wise choice when you’re confronted with money laundering charges, because presumption of innocence and the right to remain silent are more or less thrown out the window.

Kees is now charged with laundering 0.007,000,-- bitcoin, namely the amount from Donald plus the amount from Dmitry. If the “cluster” that forms his wallet included more transaction, then those would have been added to the total amount as well. Because Donald paid a 10% fee, it is automatically assumed he also charged Kees 10%, and since that is more than Bitonic charges, this - in the opinion of the public prosecutor, should have given Kees sufficient reason to suspect illegal origin of the funds, and thus he should have enquired about them.

The burden of evidence is therefore shifted to Kees and he needs to provide an explanation, one that is not a priori unreasonable, for the origin of the 0.006,000,--. He doesn’t, so he’s convicted and goes to jail.

This is the simplest case I can think of to demonstrate how cluster analysis works, and how it’s actually being used. In practice cases are far more complicated and the analysis isn’t done in the fairly thorough way I describe above. Instead, the police relies on companies like Chainalysis to figure out which addresses belong to whom and they produce fancy charts that tell if someone is guilty.

Nobody knows what data sources companies like Chainalysis use or how they find clusters; that proprietary evidence is held back. There are countless ways in which these analyses can go wrong, it very quickly leads to cargo cult science^[<https://en.wikipedia.org/wiki/Cargo_cult_science>] and witch trials, with potentially false convictions as a result. Good luck finding defense counsel who understands this, and even more luck explaining this in court (after you’ve spent a few months in prison without bail).
