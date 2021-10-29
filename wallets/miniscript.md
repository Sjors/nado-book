\newpage
## Script and Miniscript {#sec:miniscript}

Listen to Bitcoin, Explained episode 4:\
![](qr/04.png){ width=25% }

<!-- Helpful Links:
* Andrew Poelstra on script and miniscript (mentioned at the end of the episode) https://www.youtube.com/watch?v=_v1lECxNDiM
* list of Bitcoin script op codes: https://en.bitcoin.it/wiki/Script
  * also shows a table of the "OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG" flow I describe
-->

This chapter will talk about Miniscript and how it makes using Bitcoin Script much easier. TODO

### Constraints

Constraints are a way of specifying limitations: When you want to receive bitcoin, you tell the person sending it what rules apply to the transaction. For example, everybody can touch whatever's in your wallet, but then people can add a constraint such as "Only I can spend these coins." Or to be more precise, "These coins can only be spent if the transaction includes a signature that's made with a specific public key."

So you'd tell the other person your public key or the hash of it. Then, you'd put that on the blockchain with a note on it saying that only the owner of that public key can spend it. You're not sending a file; you're just publishing something on the blockchain that says, "Whoever has this public key can now spend these coins." And that happens to be the recipient's public key.

However, although this a common type of constraint, there are all sorts of other types of constraints, and you can even specify multiple constraints, such as "I can spend this, but my mom also needs to sign it. But after 35 years, maybe I can sign it alone." In such a scenario, if you want to spend the money, you only need to fulfill one of the criterium to override the constraint.

### Script Hash

Now if I want to receive coins from someone, I have to specify exactly what script to use. This is strange, because I'd be telling them how I want to spend my coins. And if this was put in an address, then the above example would be a very long address, due to all these different possible constraints.

We already explained in chapter @sec:address how addresses typically use the hash of the public key rather than the public itself. Similarly, instead of giving my counterparty (the sender) the full script — I give them the hash of the script, which is always the same length and happens to be the same length of a normal address.

In 2012, the Pay-to-Script-Hash (P2SH) was standardized. These kinds of transactions let you send to a script hash, which is an address beginning with 3, in place of sending to a public key hash, which is an address beginning with 1. Otherwise, they'll look kind of the same.

The person on the other end has to copy-paste it, put it in their Bitcoin wallet, and send money to it. And it works. Now, when I want to spend that money, I need to reveal the actual script to the blockchain, which my wallet will handle automatically. So I don't have to bother anyone else with the complexity of remembering what the script was and correctly sending to it.

In other words, if you receive money, you only have to share a hash. The person that's sending you money doesn't need to care what this hash actually hides. And then only when you spend the coins do you need to reveal the constraints. From a privacy point of view, this is much better than immediately putting the script on the chain. To learn more about privacy, specifically as it pertains to Taproot, refer the chapter @sec:taproot_basics.

### Miniscript and Script

[Miniscript <https://medium.com/blockstream/miniscript-bitcoin-scripting-3aeff3853620>] is a project that was designed by a few Blockstream engineers: Pieter Wuille, Andrew Poelstra, and Sanket Kanjalkar. [It's <http://bitcoin.sipa.be/miniscript>] "a language for writing (a subset of) Bitcoin Scripts in a structured way, enabling analysis, composition, generic signing and more."

Script is a programming language that was introduced in Bitcoin, though it resembles a preexisting language known as Forth. Script seems to have been cobbled together as an afterthought, but it was only later that people realized that you can only change Bitcoin through very carefully grafted soft forks.

So you can't just say, "Oh, let's just start with a draft language," and then clean it up later. As a result, it's been a complete nightmare to make sure the language doesn't do anything surprising or bad. And in turn, a lot of the operations that were part of the language were removed almost immediately, because there were all sorts of ways that you could just crash a node or do other things.

Ethereum had a similar experience in 2015, where complex programs could do all sorts of unexpected things. But Bitcoin had that in the beginning too.

### How Script Works

Script is a stack-based language, so think of it like a stack of plates. You can put plates on it, and you can take the top plate off, but generally you don't want to just take a plate out of the middle.

This is just easy to implement as a programming language in general, e.g. when people made early computer processors, it was easier to have a memory where you could only put things on top of it and take the top element off. You didn't have addresses — like with memory, you have to say which part of the memory you want.

With a stack, you put something on it and take something away from it. So the standard Bitcoin Script reads as follows:

- OP_DUP (as in double or duplicate)
- Op_Hash160 (as in take the 160 SHA hash, and then the RIPEMD-160 hash)
- pubKeyHash (the public key hash)
- OP_EQUAL_VERIFY

These things tell your computer what to do and check, such as if things match or not, etc.

When the blockchain encounters this script, it's in the output of a transaction. The output of a transaction shows the script that it's locked with and the amount. Now, if you want to spend that, you need to publish what you want to put on the stack, and that probably includes a signature.

What that actually looks like is a couple of things that you're putting on the stack. The Bitcoin interpreter will see what you put on the stack, and it'll start running the program from the output. In this case, what you put on the stack is your signature and your public key, because the original script didn't have your public key; it had the hash of your public key.

So we start with a stack that has two plates. Plate 1 at the bottom is your signature, and on top of that is a plate with your public key. And then the script says OP_DUP. It takes the top element of the stacks, takes the top plate, the public key and duplicates it. So now you have two plates with a public key at the top of the stack. And your signature's still at the bottom.

The next instruction is Op_Hash160. This takes what's on top of the stack — one of the public keys — and hashes it, and then puts the hash back on the stack.

At the bottom is the six, still the signature, then there's a public key and then there's the hash of the public key, that's what's on the stack.

The next operation is pubKeyHash, which is the hash of your public key again. So now, the top of the stack is the hash of your public key twice.

The next operation is OP_EQUAL_VERIFY, which takes the two things off the top of the stack and checks to see if they're the same.

What's left on the stack is your signature and your public key, and it calls object six. So it checks the signature using your public key. And then, the stack is empty.

That's how the Bitcoin program is run. And you can do arbitrarily complicated things. However, during this entire process, the signature isn't checked.

### Really Absurd Things

The script's language is diverse enough to allow for weird stuff. So if you're sending money to yourself, you only need this very simple standard script that everybody's seen a million times.

But let's say you're collaborating, and you want to do a multi-signature, or multisig. Now there are actually instructions for how to do this, but let's say they didn't yet exist. So one way you could do a multisig is to use the script that was just explained (with the recipient's public key or public key hash), along with the script with the sender's public key hash, just in sequence.

Essentially, if you start with those two public keys and two signatures on the stack, and you run both of these scripts in sequence, and then if both people signed, it's all good. This would be a poor man's multisig.

However, someone who doesn't know better, or someone with bad intentions, could insert an op code called OP_RETURN in the middle. This OP_RETURN code basically instructs XXX to stop evaluating the program.

Now, if I had an electronic lawyer that wanted to check that this multisig is what it says it does, that lawyer might say, "Well, I see that my signature's being checked, but I don't care about whatever the rest of the script does." But of course, the electronic lawyer should see that OP_RETURN statement and warn me. But the problem is there are countless ways in which scripts can go wrong, which is why we need a standardized way of dealing with these scripts.

[In an interview with Bitcoin Magazine <https://bitcoinmagazine.com/technical/miniscript-how-blockstream-engineers-are-making-bitcoin-programming-easyer>], Andrew Poelstra said, "There are opcodes in Bitcoin Script which do really absurd things, like, interpret a signature as a true/false value, branch on that; convert that boolean to a number and then index into the stack, and rearrange the stack based on that number. And the specific rules for how it does this are super nuts."

This quote exemplifies the complexity of potential ways to mess around with script.

To continue with the plate analogy, you'd take a hammer and smash one, and then you'd confuse two and paint one red and then it still works, if you do it correctly. It's completely absurd.

So that's the long and short of the problem with scripts: It's easy to make mistakes or hide bugs and make all sorts of complex arrangements that people might or might not notice. And then your money goes places you don't want it to go. We've already seen [in other projects <https://ogucluturk.medium.com/the-dao-hack-explained-unfortunate-take-off-of-smart-contracts-2bd8c8db3562>] how bad things can get if you have a very complicated language that does things you're not completely expecting.

### How Miniscript Works

Now with Miniscript, it takes certain example scripts, i.e. a sequence of op codes, and it lists a few dozen templates. And whereas Bitcoin Script uses an alphabet essentially, Miniscript has a set of words. So it's not a subset of the alphabet, but it's a subset of words. There are certain patterns of op codes you're allowed to use, and they need to be used in a specific way.

This removes some of the foot guns, but it also allows you to do very cool stuff safely. In particular, it lets you do things like, `AND`. So you can say condition `A` must be true `AND` condition `B` must be true and you can do things like `OR`. And whatever's inside the `OR` or inside the `AND` can be arbitrarily complex.

In contrast, with Bitcoin Script, you have `if` and `L` statements, but if you're not careful, those `if` and `L` statements won't do what you think they're going to do, because there's complexity hidden after these statements.

Meanwhile, with Miniscript, the templates make sure you're only doing things that are actually doing what you think they're doing. Let's say you're a company and you offer a semi-custodial wallet solution, where you have one of the keys of the user and the user has the other has two keys. You don't have a majority of the keys, but maybe there's a five-year timeout where you do have control in case the user dies or something else happens.

This would be like a multisig set up. Normally, when you set up a multisig, everybody gives their master key, their expo, for example, and you create a simple script that has three keys and three people sign. But the problem is, because you're a big business that offers a service, you have some really complicated internal accounting department and you maybe want to have five different signatures by specific people with varied levels of complexity.

There's a lot of complex stuff you can do with it, and all the complex stuff should count as one key.

The problem with that is how does the customer know the script is OK? They'd have to hire their own electronic lawyer to check that the script doesn't have any little gimmicks in it.

Miniscript allows you to check that, as long as the script you're getting is compatible with Miniscript, because Miniscript to normal script goes both ways. In other words, you can take any Miniscript and turn it into a normal script. And, you can take any normal script and turn it into a Miniscript (unless it doesn't match). If there are codes in it that don't apply, then it just doesn't compile or translate. So, if you can turn something into Miniscript, then you can analyze it using all sorts of tools that can analyze any Miniscript.

With Bitcoin Script, it's challenging to draw out what a contract would look like, but with Miniscript, it's actually fairly simple. For example, every wallet out there could have a Miniscript interpreter, and the interpreter could show you a little pie chart, saying "You're this one piece of the pie, and there's this other piece of the pie that's really complicated, but you don't have to worry about it. It's not going to do anything sneaky."

### Policy Language

A policy language is a way to express your intentions. You could just write a script or the Miniscript directly, but when writing the policy language, you can have a compiler that can be very smart. A simple policy language might be just give me two of two signatures. And the policy language would probably convert that to Op_Multisig or we'll convert that to Multisig in Miniscript and Multisig in Miniscript is just Op_Multisig.

Basically, you write a policy language, which is like a higher-level programming language. What happens is usually when you see a programmer looking at a screen, you see something that looks like English, with words like four and next etc., but eventually, the machine is just reading bits and bytes.

The bits and bytes are close to what Bitcoin op codes look like. They're very low level. They're instructions such as "put this on the stack," "take that away from the stack," etc. The Miniscript is essentially the same; it's only a subset of it, but it's slightly more readable.

However, the policy language is slightly higher level. You start at the higher level, which is easier for a programmer to write, and then a computer looks at that high-level language and says, "How can I write this into low-level machine-readable stuff as efficiently as possible?"

In the case of multisig, I might say, "I just want two out of two signatures. I don't care how you do that." The compiler knows that there are multiple ways to execute the intention. And then, the question is, which of them will be picked? The answer to that depends on the transaction weight and the fees that might be involved.

However, you can also tell the compiler, "OK, I think most of the time it's condition A, but only 10 percent of the time it's condition B." The compiler can then try condition A nine times, and condition B one time, and then figure out what the expected fee is. It can optimize for typical use cases, worst case scenarios, all these things, and it can then spit out either a Bitcoin Script or a Miniscript that then becomes a Bitcoin Script.

And in very practical terms, another thing it could do, I don't know if it can already do that is you have SegWit scripts now, but we'll have hopefully half Taproot, which can put things in a Merkle tree. So your compiler could figure out where to put stuff in the Merkle tree. You don't have to worry about how to build the Merkle tree.

The technical term for going from Miniscript to script — or for transforming source code from any language into another similar one — is trans-piling, which can basically be done in two directions. So you can go from Miniscript to script, or from script to Miniscript, but you can't go back to a policy language.

As mentioned above, Bitcoin Script is essentially an alphabet, just different letters that have different meanings. Meanwhile, Miniscript is a set of words — not really words, because you can put things between the words, but maybe words and brackets and commas. And then the policy language is the thing that can be converted to Miniscript. It's a bit more high level. And there are several of those apparently by now.

Miniscript has to be set in stone, because you want to do all the safety checks on it, but then just like you can have different programming language, you can have different policy languages.

### Limitations and Policy Languages

All this said, there are some limitations when you're using policy language or Miniscript in general.

In practice, some policies might be very complicated and there would be infinite ways to execute these in Bitcoin Scripts. And because of all these weird double comma foot guns in Bitcoin Script, sometimes that's an advantage. Sometimes you can write something really efficiently in Bitcoin Script, that's just really horrible if you look at it objectively, but it's really fast or really fee-efficient.

Lightning uses that the way they sometimes deal with time locks or hashes or nonces. So there are some optimizations where like what Poelstra said, "Oh, you do some weird switching of the stack and you interpret things, not the way they were," you put a public key on it, but you interpret it as a number, those kind of weird tricks.

Those might be very hard to reason about, and a human might be able to do it, but the Miniscript compiler wouldn't, which means you end up with longer, potentially longer Lightning scripts, if you don't have all the whistles and bells in it. So it's possible Miniscript would be expanded if there were some other optimal way to do it. But you have to be careful, because you really want to make sure there's nothing in Miniscript that brings back the scary properties of the underlying language.

With policy language, you're still steps away from having a practical tool for setting up a very complicated multisig wallet. There are all sorts of questions to answer, such as: How exactly do you do this setup? What are you emailing to each other? Are you emailing your keys or are you emailing something a little bit more abstract that you agree on first and then you exchange keys? These are practical things that aren't solved inside a Miniscript.
