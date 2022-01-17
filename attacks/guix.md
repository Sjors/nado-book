\newpage
## Why Open Source Matters (guix) {#sec:guix}


![Ep. 21 {l0pt}](qr/21.png)

discuss why it matters that Bitcoin software is open source… and why even open source software doesn't necessarily solve all software-specific trust issues.

In theory, the fact that most Bitcoin nodes, wallets and applications are open source should ensure that developers can’t include malicious code in the programs: anyone can inspect the source code for malware. In practice, however, the number of people with enough expertise to do this is limited, while the reliance of some Bitcoin projects on external code libraries (“dependencies”) makes it even harder.

Furthermore, even if the open source code is sound, this doesn’t guarantee that the binaries (computer code) really correspond with the open source code. Aaron and Sjors explain how this risk is largely mitigated in Bitcoin through a process called Gitian building, where several Bitcoin Core developers sign the binaries if, and only if, they all produced the exact same binaries from the same source code. This requires special compiler software.

Finally, Aaron and Sjors discuss Guix, a relatively new project that goes above and beyond the Gitian process, to minimize the level of trust required to turn source code into binaries — including trust in the compiler itself.

Presentation by Carl Dong, author of Guix.^[<https://www.youtube.com/watch?v=I2iShmUTEl8>]

### Free vs. Open Source

A brief primer on the historical difference between free software and open source software, and how they were combined into FOSS (Free and open-source software).

The idea behind the free (as in freedom) software movement is that if software is closed source, it results in a power relationship between developers and users, because users don't know what software they're running.

The reason for this is that the actual software you're running on your computer are binaries. They're ones and zeros. That's the stuff computers can read. While humans, when they write software, they write computer code, and the two aren't the same thing. So when you're running closed software, you're just running the binaries and you are not exactly sure what your computer's actually doing.

So, for example, if a developer puts malware into the closed software, your computer could spy on you or do something you don't actually want the software to do. So in that sense, you have to trust that the developer didn't include malware or tamper with anything.

Richard Stallman didn't like the idea of closed software, so he started the free software movement where the source code had to be available so people could actually check what they were running on their computer. This in turn eliminated the power dynamic. So, free in that context means freedom. It doesn't mean free as in free beer.

A slightly different, but compatible, perspective was given by Eric S. Raymond in his 1999 _The Cathedral and the Bazaar: Musings on Linux and Open Source by an Accidental Revolutionary_^[<https://en.wikipedia.org/wiki/The_Cathedral_and_the_Bazaar>]. In this book, he explained the benefits of free software and how it could actually provide high-quality code. According to him, "given enough eyeballs, all bugs are shallow." In other words, the more the code is seen and reviewed, the better the chance all bugs are found.

Because of this pragmatic reasoning about code quality, the people at the Netscape Communications Corporation were convinced to turn their internal browser into an open source project, Mozilla. We're calling it open source now because this group of people rebranded free (as in freedom) software to open source to better accentuate these different benefits. There weren't necessarily in favor of open sourcing software for the philosophical freedom reasons Stallman was advertising, but rather more for pragmatic reasons. And that's where the difference between free software and open source stems from.

### Bitcoin, an Open Source Project

All of this is connected to Bitcoin. Just imagine you're trying to use Bitcoin. You install a computer program and it gives you an address, and then it turns out there's some code in there that just steals your Bitcoin. That would be bad. It's an extreme example, but it makes it very clear why you really need the maximum transparency of what exactly is running on your machine.

It sounds easy enough, but in reality, it's a lot harder to ensure the code on your computer is actually doing what you want it to do. That's why you want whatever Bitcoin code is running to be open source, so you can see what it is.

One thing you can do, if you have the skill, is to compile Bitcoin Core yourself, avoiding the need to download an untrusted binary. That doesn't solve the problem for the vast majority of users though.

Bitcoin code is open source and it's hosted on GitHub in a repository. This means anyone with the know-how can look at the source code and check that it does what it's supposed to do. But in reality, the number of people is limited.^[The number of people who can read this code depends on what you mean by actually read. How many people are computer literate in general? How many can roughly read what a C++ program is doing? Probably tens of millions (<https://redmonk.com/jgovernor/2017/05/26/just-how-many-darned-developers-are-there-in-the-world-github-is-puzzled/>). But of those perhaps only a few thousand have ever worked on crypto currency or similar software. There are dozens of active developers on any given day, who all look at the code. But none of them can oversee all changes in the entire project, because that requires specialization: one developer might know everything about peer-to-peer networking code, and absolutely nothing about wallet code.] Occasionally they get some help from developers that work on altcoins.^[For example the very serious CVE-2018-17144 was found by Bitcoin Cash developer Awemany (<https://bitcoinops.org/en/topics/cve-2018-17144/>). Many altcoin projects started by copy-pasting the Bitcoin source code and then changing a few things to differentiate themselves. For example, Dogecoin changed the inflation schedule, decreased the time between blocks and used a different proof-of-work algorithm. But that still left 99% of their codebase identical to Bitcoin Core: digital signatures are still checked the same way, transactions and blocks are still verified the same way, the peer to peer network works the same way, etc. So when altcoin developers are working on their project, they may discover bugs in that 99% of the codebase they share with Bitcoin Core. This adds to the security of Bitcoin.]

If we wanted to increase the number of people who could read and understand Bitcoin source code, it would need to be cleaner and more readable. The original code Satoshi wrote was very, very hard to reason about.^[To understand what it means to reason about something, imagine you're looking at the code and you see, there's a function called make a private key. Your line of thinking might go as follows: "OK What does that function do? Oh, it calls in this other function. Where's that other function? Oh, it's 20,000 lines up in the same file. Let me scroll 20,000 lines up and have a look at that code. I see, it's referring to a variable. Oh, but this variable is also accessed in 15 different places in the codebase..."]

### Checking the Validity

Let's say you trust the development and release process, so you download the binaries from Bitcoincore.org. The first problem is that you don't know if Bitcoincore.org is run by the Bitcoin developers. Even if you were confident of that, it could be that the site is hacked, or the site isn't hacked, but the DNS is hacked. There are lots of reasons why what you download isn't actually the thing you think you're downloading: it could be malware.

To get around this, open source projects almost always publish a checksum. What this means is that if you download something and run a particular script on it, the resulting checksum you get should match what they say it should be. In theory, that works. However, whoever hacked the site might have also hacked the checksum, so it's not foolproof.

The next step is to sign the checksum. So, for example, a well-known person — in this case, Wladimir van der Laan, the (Dutch) lead maintainer^[Maintainers are not as powerful as some people think they are: <https://blog.lopp.net/who-controls-bitcoin-core-/>] of Bitcoin Core — signs the checksum with a signature, with a key, with a PGP key that's publicly known. It's been the same for 10 years. So then at least you have something to check.

And he knows the binaries reflect the open source code because he took the source code, ran a command, and got the binary. In other words, he put the code through some other piece of software that produces binaries from the open source software.

Here's where it gets a little bit more complicated. Ideally, what you do is you run the same command and you also compile it, and then hopefully, you get the same result.

Sometimes that works with a specific project, but as the project gets complicated, it often doesn't work, because it depends on some very specific details on your computer system what the exact binary file is going to be.

Take a trivial c++ program:

```
int main() {
  return 0;
}
```

This program exits and returns `0`. It's more boring than Hello World.

When I compile this on one of my Macs it produces a 16536 byte program. When I repeat that on a different Mac, it produces an identical file, as evidenced by its sha256 checksum. But when I compile it on my Ubuntu machine I get a 15768 byte result.


All it takes is one changed letter in a computer program, or in its compiled binary, and boom, your checksum doesn't work anymore.

If the compiled program includes a library (see chapter @sec:libsecp) then the end result depends on the exact library version that happened to be on the developer machine when they created the binary.

So when you download the latest Bitcoin Core from its website, and you compare it to what you compiled yourself, it's going to have a different checksum. Perhaps the difference is due to you have a more recent version of some library, or perhaps it's due to a subtle difference between your system and that of Wladimir.

As mentioned above, if you're one of those lucky people who can compile code yourself, this isn't a big deal. More likely however your security depends on the hope that somebody else will do this check for you. Those people might then sound the alarm if anything is wrong.

But because it's so difficult to check if the source code matches the downloadable binary, should you really assume that anyone out there does this?

### Fixing the Problem with Gitian

If your goal is to verify that nothing went wrong, you need to somehow make sure the same source code compiles into the exact same binaries. This phenomena is called reproducible builds, or deterministic builds.

What deterministic implies is that, given a source, you're going to get the same binary. And if you change one letter in the source, you're going to get a different binary, but everybody will get the same result if they make the same change.

In addition we need to solve the problem of slight differences in machine configuration leading to a different binary file.

Until mid 2021 the way Bitcoin Core did this is with Gitian.^[<https://gitian.org/>] In short, you take a virtual or physical computer, download the installation "CD" for a very specific Ubuntu version and install that. This ensures everyone has an identical starting position, and because Ubuntu is widely used, there's some confidence that there is no Bitcoin-backdoor on that installation disk.

Inside that machine, you build another virtual machine, which has been tailor made to ensure it builds identical binaries for everyone who using it. For example it uses a fixed fake time so that if a timestamp ends up in the final binary, it's going to be the same timestamp no matter what time you ran the compiler. It ensures all the libraries are the exact same versions, it uses a very specific compiler version, etc. And then you build Bitcoin Core inside that virtual machine, and look at the checksum. This should now match the downloadable files on bitcoincore.org.

About a dozen developers and other volunteers run this "computer within a computer". Around each new released version, they all compile the binaries and publish the resulting hashes for others to see. In addition they sign these hashes with their public PGP key.

However, while this sounds easy in theory, in practice, it's always been a huge pain to get the system working. There aren't many open source projects that use Gitian — as far as I know only Bitcoin Core and Tor do. Even most, if not all, altcoin forks of the Bitcoin Core software don't bother with this process.

### Dependencies, dependencies, dependencies

However, this isn't the only problem.

Let's say you just read the Facebook terms and conditions, but it turns out those terms and conditions point to some other document, perhaps the entirety of US copyright law. So now yo have to read that too.

Similarly just reviewing the Bitcoin Core code is not enough, because like most computer programs, it uses all sorts of other things, known as dependencies, mostly in the form of libraries (see chapter @sec:libsecp). And each library might in turn use some other library, and so forth and so on. You need to inspect all of those too.

One of the constraints Bitcoin Core developers work with is to keep the number of dependencies as small as possible, and also to not update them all the time. Such updates require extra review work. And of course the people who maintain those dependencies know Bitcoin Core is using it; all the more reason to be somewhat on your toes to make sure that those projects are being scrutinized, too.

And if it turns out that a dependency is corrupt, it could steal your coins. This actually happened at least in one other project 2018. It involved a dependency of a dependency of a dependency of the Copay library, which itself is a dependency of several wallets. Fortunately, it was detected quickly,^[What happened was they had a piece of software that's open source, meaning everybody could review it. But it uses dependencies, and those dependencies use dependencies, and so on.
\
They were using npm, which is the package manager for Node.js. This is, in turn, a large open source community, and it's a highly modular system.
\
Every single package links to a repository on GitHub, with its own maintainer who can release updates whenever they want. A typical piece of wallet software might be pulling in 10,000 dependencies indirectly. You might start with five dependencies, and each of those pull in 50 dependencies, and those each pull in another 50 dependencies. If even a single one of the developers or maintainers of any of these packages is corrupted, they could include coin stealing malware.
\
A javascript wallet like CoPay stores the users private keys somewhere inside the browser memory. Unfortunately that is a very egalitarian place, meaning that any piece of JavaScript can access it. This is how malware hidden in a sub-sub-dependency can steal coins.
\
See also this writeup: <https://www.synopsys.com/blogs/software-security/malicious-dependency-supply-chain/>] so it was never exploited in the wild.


### The Solution

This begs the questions of what the solution is, and unfortunately, it's to not depend on dependencies. If necessary, it's important to use as few as possible, and you especially want to stay away from things that have nested dependencies.

In the case of Bitcoin Core, it's not too bad, because it doesn't have many dependencies and they don't have a lot of nested ones. So, it's not a big tree. It's relatively shallow and you'd have to go after those specific dependencies directly to attack.

### Can Gitian Be Corrupted?

Earlier in this chapter we discussed how Gitian helps create deterministic builds. But that begs the question of it Gitian itself is corrupted somehow.

More specifically, Gitian uses Ubuntu, and somebody might say, "Hey, this Bitcoin project's pretty cool. This Ubuntu project's pretty cool. Let me contribute some source to Ubuntu."

Now, when everybody runs their Gitian builder, which includes Ubuntu, there's a compiler on Ubuntu and maybe that compiler is modified to add some code to steal coins. It would be very, very scary, because it'd still have deterministic builds, and everybody would be using the same malware to build it.

Aaron:
Yeah. I guess that's a dependency in itself then, right? That's like a dependency for Ubuntu, or am I saying that right?

Sjors:
Yeah, I guess there's two kinds of dependencies. One is the dependency you are actively running that's inside the binary that you're shipping to your customers. But the other dependency, and that's a real can of worms, are all the tools that you're using to produce the binary and even to download the binary, but yeah.

Aaron:
Yeah. So if the tools you use to build Bitcoin Core is corrupt, then you still have a problem because all of the developers are getting to solve the same binaries from their Gitean process, but if that's corrupted... Anyways, I think our listeners get it. So what's the-

Sjors:
Right. So what you're hoping is that the people who are maintaining all these compilers and all the other things know what they're doing and would never let any such back door through. But that would be boring, so how do we get more paranoid?

Aaron:
How do we get more paranoid? How do we solve this problem?

Sjors:
Well, the key there is to make everything open source and everything a deterministic build. So not just Bitcoin is an deterministic build, but every dependency of Bitcoin is a deterministic build, and every tool that is used to build Bitcoin is a deterministic build, including the compiler.

Sjors:
And this is where we introduce Geeks. This is a project Carl Dong has been working on and has given several talks on that. We'll probably link to in the show notes.

Aaron:
Yeah, Carl Dong, he's with Chaincode Labs, right?

Sjors:
Yeah.

Aaron:
Yeah. So the trick then, it's a difficult trick. Well, it sounds very difficult to me because you need a compiler that itself needs to be compiled as well, because the compiler is also software. So if you want to-

Sjors:
Yeah, so this is turtles all the way down.

Aaron:
Exactly.

Sjors:
So the ambition of Geeks is roughly as follows. You start with about, I think it's 150 bytes, of actual machine code. So that is binary code that you must trust, but it's only 150 bytes, and the whole world can study it and put it on a temple wall or something like that. But from that 150 bytes, all you need to do now is read source and compile source. So how do you do that because there's no compiler yet, right? So this 150 bytes is able to bootstrap. It is able to read something. That's all it can do, basically, and produce a little bit more code.

Sjors:
So it reads some something and then it builds up a very simple compiler. And once it has the very simple compiler, that very simple compiler reads another piece of source, which then builds a slightly more complicated compiler. And then that slightly more complicated compiler builds another compiler. And this goes on for quite a while, I think, until eventually, you have the modern C compiler that we all know and love, which is itself, of course, open source, right? All compilers have this fundamental problem that who compiles the compiler?

Aaron:
It sounds pretty fascinating. So it's like a-

Sjors:
It is turtles all the way down, but there's actually a bottom.

Aaron:
Yeah. It's a-

Sjors:
It's not turtles all the way down.

Aaron:
It's a C that builds a compiler that builds compilers.

Sjors:
Yeah. So all the compilers and sub-compilers are all open source. It's just that C that is not sourced, that has to be a binary. Because you have to start with the binary somewhere. But you can literally just type it.

Aaron:
And this is a work in progress. This isn't used or finished yet, right?

Sjors:
I think it's a work in progress, but it is also working. I believe we can now use this for Bitcoin Core, because I recently did it as well. Tried to just hit the commands blindly, and it was producing actual Bitcoin Core binaries that could be run and that are not turtles all the way down. I think it doesn't start at the very bottom. So I still had problems going from the bootstrap, but that's where it's going.

Aaron:
So do one of these compilers build like the Gitean thing? Is it the same thing or is it-

Sjors:
It's not building Gitean itself, but it's a similar principle. So the idea is it can build, I think the idea eventually, is that it can build a whole operating system. So then your virtual machine or your physical machine would be running a operating system that you've built from scratch. But in this case, I think it just builds the compiler tools. And once those compiled tools are there, it can just start building Bitcoin Core as it would otherwise do.

Sjors:
Similar to Gitean as in it has to make sure that there are no timestamps in there and it doesn't use anything else from your computer. So it solves two things, right? It has no untrusted dependencies. It's not using random libraries. It's always using the same versions of libraries, which means that everybody can produce the same result.

Aaron:
Interesting. Okay. So these 115 bites, were they 115?

Sjors:
I don't know. I think it was a 150.

Aaron:
Just a small-

Sjors:
But they're pretty small.

Aaron:
So do we still need to trust these? Or, I don't know how big the leap of trust is there.

Sjors:
Well, you can read them. There's machine code. As far as I know, it's machine code that can parse a hexadecimal piece of text. And then I guess it parses the hexadecimal piece of text and that piece of text is another piece of machine code, I guess, which is then run. So it's still open source in the sense that the binary is the source. But machine code can be read, right? It's very, very tedious to read it.

Aaron:
Wait, these 115 bytes, they're source code or they're binaries?

Sjors:
No, they're binaries, but you can read a binary. It's not fundamentally impossible to read a binary. It's just very difficult to read a binary if it's big.

Aaron:
I see.

Sjors:
But if the binary is tiny, then it's just a set of machine instructions. Because what happens when you run a program is the CPU just looks at the first two bytes or whatever, and it says what's the instruction? And then the instruction says, okay, create a variable. And the next instruction says set this variable to two. And then the next instruction says add five to the variable. And the fourth instruction says restart the computer or something like that. So if it's just 150 bytes, you can look at every single byte and see what the computer instruction is in there, and you can still reason about it.

Aaron:
I see.

Sjors:
And I believe the only thing it does is it just has a small program that's able to open a file and read that file and then execute that file.

Aaron:
Interesting.

Sjors:
And then slowly you try to get to a point where it's human readable. So the very low level compilers, the very simple compilers, might have code that's not very easy to read, but still very short. And then very quickly you get very nice, elegant programming languages that you can read. But something like Rust, in order to build Rust, you need to build compilers that can compile Rust. In order to make it build a Rust compiler, you probably need a C compiler. So, yeah.

Aaron:
Yeah, this sounds super fascinating to me, the fact that this is possible.

Sjors:
Yeah. And then at least you have this ginormous spider web of code. All of it is code and you know that it produces a binary, and then you just need lots and lots of people to review every single piece of code in there and be very conservative about updating any of it. Because if you update any of it, well, it could be malware again.

Aaron:
Right.

Sjors:
And most people are used to automatically updating the computer.

Aaron:
Okay. Well, so this is how we're going to make Bitcoin truly trustless, essentially?

Sjors:
Well, turtles really all the way down because you're still running it on a piece of hardware.

Aaron:
Ah, true, yeah, of course. That's a whole other-

Sjors:
So trusted hardware-

Aaron:
Nightmare.

Sjors:
Open source hardware is another movement that are trying to get rid of all these weird chips on your computer that are doing arbitrary things. You have no idea what it is doing.

Aaron:
Yeah. Do we want to give a shout out to walletscrutiny.com?

Sjors:
Yeah. So walletscrutiny.com is a website that looks at various wallets, whether they are open source at all-

Aaron:
And a lot of them aren't.

Sjors:
Yep.

Aaron:
That's pretty scary. There's dozens of wallets that aren't even open source.

Sjors:
Yeah. So the only way to verify those wallets would be to inspect the binaries, which there are tools to make that also slightly less painful than it sounds. So if there's some very obvious code in those wallets that says steal coins, somebody will probably still find it. But it's not good.

Sjors:
Yeah. And then you have wallets that have source published, but if you have that source and you want to make sure that the binary they give you in the play store is the same, it's not that easy. Sometimes they don't offer any feature functionalities for it. Sometimes they do, but it doesn't work because it hasn't been maintained, because not a lot of-

Aaron:
How would you make that? How would you check that? What's the process there? How do you make sure that-

Sjors:
So Wallet Scrutiny actually, for some wallets, for example, ABCore, which is a full note on Android, it's a bit of a toy project, but it's very cool, on the site they just have 20 lines of code that you run in a terminal. Get this thing from GitHub, get these Android libraries, build this project, and then compare the checksums. And they show, if you execute these commands, you get the exact result.

Aaron:
So the app you're downloading on your Android phone, you can check the checksum for it?

Sjors:
Yeah.

Aaron:
Okay.

Sjors:
I think so, but I don't think they've done it for iOS yet. And I don't even know if you can do it with iOS.

Aaron:
Right.

Sjors:
So for computers, for normal computer programs, you might need something like Gitean, which is very tedious and I don't think a lot of people are going to do it.

Aaron:
Yeah, so Wallet Scrutiny-

Sjors:
Web applications are, again, a different possibility. I once worked on that, and I think I once got a web application to be a deterministic build and you could actually run a command and it would do it. But if you don't maintain that, it's going to break. Because all the Node.js tooling and all that stuff is not designed to make reproducible builds too easy.

Aaron:
Yeah. So, okay. So walletscrutiny.com, it's a project by [Leo Van der Schlepp 00:33:36] and it categorizes wallets into custodial, not even open source, so not custodial, but also not open source, which is probably even worse than custodial. I don't know what you think.

Sjors:
Depends if you know who it is.

Aaron:
Yeah, I guess.

Sjors:
If some random person, the only way you can find out who they are is to ask Apple, and then Apple says, "Oh, sorry. That was some random BVI thing. We have no idea."

Aaron:
Yeah, anyway, so custodial, non-custodial and also not open source, and then there's non-custodial but at least open source. And then there's the category non-custodial, open source, and deterministically buildable, which are only a few wallets. That's sort of the category you want to be in, but that's only a handful.

Sjors:
And I think the site only covers Android wallets.

-->
