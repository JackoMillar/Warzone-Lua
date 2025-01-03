function CauseOfDeath(name)
	local death = {
		name .. " fell down the stairs!",
		name .. " got stepped on by an elephant",
		name .. " went out as they lived, a nobody",
		name .. " went out riding a live shark with 250 pounds of dynamite strapped to his chest into an active volcano!",
		name .. " fell out of a plane"

	};

	return death[math.random(#death)];
end

function gullible(name)
	local gull = {
		name .. " is gullible",
		name .. " pressed the big red button, expecting something to happen",
		"Guess why this is here... because " .. name .. " couldnt keep their hands to themself",
		name .. " pressed the wrong button, nearly broke the game",
		name .. " decided to cheat",
		name .. " is a big cheater, BOOOOOO!!!!",
		"Today " .. name .. " decided to cheat. Shame on them!",
		name .. " is never gonna give you up, never gonna let you down, EXCEPT THIS TIME!",
		name .. " has been caught out trying to cheat, boo them!",
		"Ive got nothing to say " .. name .." except im disappointed in you",
		"HEY ".. name .." how did you get into the admin menu?",
		"Stop trying to access the admin menu " .. name .. "! Im always watching... always"
	};

	return gull[math.random(#gull)];
end

function advert()
	local adverts = {
		"Breaking news: Rick Ashley’s body was stolen by cultists from the cemetery today, body snatchers post video stating that they “are never gonna give him up”",
		"Police provide public statement on latest abduction of Rick Ashley’s body: “we promise to never let you down in our hunt for the thief”",
		"Docu-series: the tragedy of clan league 42 has released today, with critics saying it’s an instant horror classic",
		"Tired of your boring life, where everything is always the same old crap? Start a new life! UFO Abduction Services® makes leaving your past life behind an outer world experience! Contact us at UFO-76-UFO-76 for a free trial probing!",
		"Help Wanted: Participant in cut-throat competition involving deceit, betrayal, and a BOX!",
		"HangFire's Amusement Park - Featuring Day and Night Demolition Shows. Open Tuesday thru Sunday 9 AM to Midnight. First time visitors and children under 12 receive one free stick of dynamite and 50% off Entry fee.",
		"HangFire's Amusement Park - Activities include: M-60 Firing Range, Grenade Pit, Mortar and Bazooka Range, Close Quarters Combat, Landmine Racing and more!",
		"HangFire's Amusement Park - Fun for the whole family. Come one, come all. Reservations and Family Packages Available. Call 1-444-EXPLODE (397-5633), Sponsored by Seefore Productions and Blow My Mind Supply Store!",
		"Nigerian prince needs help getting inheritance back. Mail me for more info: musaibrahim@Warzone.com",
		"New chest enlargement pills!!! More info at myplacebo.Warzone.com",
		"Why Warzone was almost a fizzer. Today, at 20:00, only at warlight news.",
		"Breaking news! Activision suit finally finished. Call of Duty: Warlight renames back to Call of Duty: Warzone.",
		"Lionheart - who was this mapmaking furry? This and more at ZoneWar weekly.",
		"Grover",
		"Zonop tries to revive CL after the Let's Fight fiasco. Will she succeed? This and more at ZoneWar weekly.",
		"Discombobulator's blockade - did Timinator use it first? This and more at ZoneWar weekly.",
		"Letting everybody know, that Rachel (+1-202-555-0121) is a bloody harlot! I am divorcing you scoundrel!1!1!1!!",
		"Fancy dot's appear all over western hemisphere, scientists are baffled!",
		"Warzone: 2069, created and sponsored by a flying UFO!",
		"Latest study shows that 86% of office hours are spent playing Warzone instead of working.",
		"New calendar explodes into popularity, years are now marked as BW (Before Warzone) and AW (After Warzone), 0AW set to be what was once 2020",
		"Breaking news: a new study finds that 95% of people will believe 'facts' if you claim it is a new study.",
		"A man was admitted to the hospital with 25 toy horses shoved up his rectum. Doctors described his condition as stable.",
		"Doctor was too busy with CW to even visit the patient. Diagnosis considered questionable.",
		"TR-8R EXPOSES COMPANY WIDE CORRUPTION, Details on ZoneWar News at 6.",
		"Interview with Fizzer - the creator of Warzone and the first person to be uploaded to AI. This and more at ZoneWar weekly.",
		"New update - minus one army must stand guard. What does it mean to the community? This and more at ZoneWar weekly.",
		"Youtube bans Warzone streaming. Streamers move to Cornhub. This and more at ZoneWar weekly.",
		"Breaking news! Riots at Finnish-Chinese borders.",
		"War on Ukraine after 47 years finally resolved? Country leaders agree to play 'guiroma' for contested areas. This and more at ZoneWar weekly.",
		"World Health Organisation finds torture by Siege LD as cruel and inhuman. This and more at ZoneWar weekly.",
		"MASTERS clan - from elite to 'newbie boot camp'. Unique interview with the clan leadership. This and more at ZoneWar weekly.",
		"Warzone and derivative - part IV of Warzone and math. This and more at ZoneWar weekly.",
		"Want to win this game? Give 1000 coins to JK_3 and get nothing! You dont think it an amazing deal? That's why you're losing my friend..",
		"Do you like this mod, check out my other creations such as CivLight and Meteor strike.",
		"North Korean basin declared nuclear free zone after 40 years.",
		"Scotland tourism soars after the Edinburgh - Glasgow Canal finally opens",
		"New element was found today, Scientists are calling it 'fizzium'",
		"UN declares that all future conflicts must take place on Warzone after the deadly 1 day war kills 5% of world population",
		"UN declares that doplhins are as intelligent as people, ambassador for the species to be met today",
		"JK_3, the alt master, overruns server with 1000's of accounts. Find out more at ZoneWar weekly!",
		"Just_A_Dutchman completes 1000th mod, wins noble prize. Find out more at ZoneWar weekly",
		"Grover's Cafe launchs first cafe on the moon, 'It was actually quite easy, barely an inconvenience' - Grover",
		"Fizzer becomes first trillionaire. Find out more at ZoneWar weekly",
		"Join the Warzone Modding discord at: https://discord.gg/2FzGWFPv",
		"Error: Idiot has joined the game",
		"Zombie outbreak starts in the USA. contained within 1 hour with 6 dead(er)",
		"Half Life 3 announcement today, company Valve states 'we have reached the midpoint in development.'",
		"Do you ever wonder why we are here?",
		"Clan League XXIII: peepee poo MASTERs absorbed by 10ONE!st. Can Python ever win Clan League?",
		"Scandal: mod is no Modder. Does he has to rename?",
		"ZoneWar and the Riemann hypothesis: are strategies linked to position of zeros?",
		"Breaking news: 2+2=5 for sufficiently large values of 2",
		"Person wakes up from coma, plays a Wasteland Earth 1 Small, then asks his opponent whether the Riemann hypothesis has been solved",
		"Shop: Pi sells Totally Real Proof of the Lindelof Hypothesis for 31415 coins! Come buy now! Comes free with Premium Pumpkin Pie colour!",
		"Powerup: Game Tree Solved, Badly: Get the AI to play for you, like Autopilot, but for free! Only 5900 coins! Buy now! Definitely cheaper than a LTM!",
		"Fizzer: Fizzer fizzers Fizzer's Fizzerpicks to fizzer Fizzer's Flunky Fizzers",
		"Silence is golden and speech is silver:",
		"Get off Warzone, your mum misses you.",
		"Probing victim blames UFO",
		"UFO identifies as Identified Flying Object",
		"Coming soon: Warzone VR - bringing the full experience of war to you",
		"Experience WW3 allover again in the WZ Classic app under Open Games",
		"Top story: Warzone denies allegations of banning those worshiping Activision, counter claim sent"
	};

	return adverts[math.random(#adverts)];
end
