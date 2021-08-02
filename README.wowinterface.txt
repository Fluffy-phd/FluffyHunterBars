[SIZE="6"]TLDR[/SIZE]

This addon helps hunters perform the optimal single target DPS rotation irrespective of their gear, buffs and ranged weapon speed.
 
[SIZE="6"]Introduction[/SIZE]

We hunters have a tough life regarding our DPS due to the nature of our three main abilities (Autoshot, Aimedshot and Multi-shot). As a rule of thumb, we are advised not to clip Autoshots by casting Aimedshot prematurely. More experienced hunters, when they get familiar with their weapons, are able to optimize their rotations so that their Autoshots are clipped, however their net DPS is higher. Moreover, slower weapons are considered to be superior to their faster counterparts. However, the optimal timing of our abilities is almost impossible for an ordinary human to calculate on the fly, considering all the movement and haste buffs during the boss fights. This is where this addon comes in.

 

Ask yourself the following questions: Are you sometimes forgetting to use your abilities? Are your Autoshots delayed unnecessarily because you move at incorrect times? Would you like to know when to cast your Aimedshot and Multi-shot to obtain the maximal single target DPS? Do you have a faster or a brand new weapon?

 

If you answered yes to any of these questions, then this addon is here to help you out. When you just don't know what your are doing wrong, and others tell you just git gud, scrubb, this addon will offer you relevant information on how to improve. When you are an experienced player and get a new weapon, this addon will help you get used to new timings of your Aimedshots.

 
[SIZE="6"]How to use it[/SIZE]

The addon consists of up-to two icons which light-up whenever it is good for your DPS to cast the respective abilities (regarding clipping your Autoshots). In order for you to better prepare for what is to come, there are also up-to two bars representing the recommendations of the addon in the immediate future.

 
[SIZE="5"]The basics[/SIZE]

If you are a fresh hunter or you do not have your abilities learned yet, the addon looks something like in the following picture. There are no icons representing Aimedshot or Multi-shot, yet.

 

 
[IMG]https://media.forgecdn.net/attachments/thumbnails/357/983/310/172/basic.png[/IMG]
[B]Figure 1[/B]: [I]This is what the configured addon looks like when you don't know Aimedshot nor Multi-shot.[/I]

 

 
[IMG]https://media.forgecdn.net/attachments/thumbnails/357/984/310/172/basic_shooting.png[/IMG]
[B]Figure 2[/B]: [I]This is what the addon looks like when you fired off your Autoshot recently. The white sparks denotes the next time the Autoshot will be fired. The red box denotes the time in which you cause your next Autoshot to fire off with delay if you move.[/I]

 
[URL="https://www.youtube.com/watch?v=nmQhD9XIni4"]https://www.youtube.com/watch?v=nmQhD9XIni4[/URL]
[B]Video 1[/B]: [I]The basic use of the addon to execute the so called stutter-stepping technique.[/I]

 
[SIZE="5"]The advanced stuff[/SIZE]

When you learned your Aimedshot and Multi-shot and you successfully annoy your friends with it in dungeons and raids, the addon looks something like in the following pictures.

 

 
[IMG]https://media.forgecdn.net/attachments/thumbnails/357/989/310/172/advanced_standing_still.png[/IMG]
[B]Figure 3[/B]: [I]This is what it looks like for me personally when I am not shooting at anything. The icons for both the Aimedshot and Multi-shot are "lit-up", meaning I am currently being advised to cast either of them without hindering my DPS. The orange bar associated with Aimedshot and the blue bar associated with Multi-shot tell the player that in the near future it is recommended to cast Aimedshot or Multishot. The addon does not tell you which is better to cast over the other, that is based on your judgement of the current circumstances.[/I]

 
[IMG]https://media.forgecdn.net/attachments/thumbnails/358/0/310/172/advanced_shooting_multioncd.png[/IMG]
[B]Figure 4[/B]: [I]When the Multi-shot is on cooldown it will not be recommended by the addon (Duh). What we see in this picture is that in the near future, we will be advised to start casting Aimedshot around 400ms before the next Autoshot fires off (due to the spell queue) and if for some reason we do not manage to cast it as soon as advised, the addon tells us that it is still better to cast Aimed shot a fair amount of time after the depicted Autoshot fires off. This is going to clip the next Autoshot (not visible on the picture), but still results in more DPS than if we followed the rule of thumb and waited with our Aimedshot until the next Autoshot (3+ seconds in the future)[/I]

 
[IMG]https://media.forgecdn.net/attachments/thumbnails/357/999/310/172/advanced_shooting_aimedoncd.png[/IMG]
[B]Figure 5[/B]: [I]Recommendation for casting Multi-shot. We see that the addon is going to recommend we cast Multi-shot right at this moment (Icon is lit-up) and also in the near future, except for a short window before the following Autoshot because the trade-off between clipping your Autoshot and damage from Multi-shot is suboptimal.[/I]

 

 

 
[URL="https://www.youtube.com/watch?v=i9RMHvP77NE"]https://www.youtube.com/watch?v=i9RMHvP77NE[/URL]
[B]Video 2[/B]: [I]The complete functionality of the addon and its use in practise.[/I]

 
[SIZE="6"]Installation[/SIZE]

Download the associated zip file and extract its content into your WoW\Interface\AddOns directory. Alternatively, you may use the addon manager of your choice for automatic installation/updates, whenever this feature becomes a possibility.
 
[SIZE="6"]Configuration of the addon[/SIZE]

Right off the bat, the UI elements of the addon should be positioned in the center of your sceen. The addon is initially unlocked and you can [B]shift+drag&drop[/B] it to your desired position.

 

The [B]/fluffy[/B] command prints all available configuration commands.

 
[SIZE="5"]Changing size[/SIZE]

[B]/fluffy resize w h[/B] sets the size of the bars to be [B]w[/B] pixels wide and [B]h[/B] pixels tall

[B]/fluffy icosize l[/B] sets the size of the ability icons to be [B]l[/B] pixels wide and [B]l[/B] pixels tall

[B]/fluffy reset[/B] resets the position and size of the addon to default values and enables [B]shift+drag&drop[/B]

 
[SIZE="5"]Changing position[/SIZE]

[B]/fluffy move x y[/B] moves the UI elements in the direction of [B]x[/B] pixels to the right and [B]y[/B] pixels to the top

[B]/fluffy unlock[/B] enables [B]shift+drag&drop[/B]

[B]/fluffy lock[/B] disables [B]shift+drag&drop[/B]

[B]/fluffy reset[/B] resets the position and size of the addon to default values and enables [B]shift+drag&drop[/B]

 
[SIZE="5"]Changing visibility[/SIZE]

[B]/fluffy hide[/B] hides the UI elements

[B]/fluffy show[/B] shows the UI elements

 
[SIZE="5"]Changing the update frequency[/SIZE]

[B]/fluffy freq n[/B] sets the UI elements to update per every [B]1/n[/B] seconds

 
[SIZE="6"]Special Thanks[/SIZE]

I would like to express a huge thanks to Dvojnik, who was the main Beta tester of this addon. I would also like to thank Tphoenix for patiently helping me fix some of the issues after initial release.

 

There are also many people who provided a valuable feedback about the functionality and (in)correctness of the addon recommendations and who provided me with feature requests. Thank you ;)

 
[SIZE="6"]Final word[/SIZE]

Any and all feedback is more than welcome in the form of comments on this page. Any feature requests and addon modifications will be considered. I plan to update this addon for TBC:Classic so there will not be any need for all those 1:1 or 3:2 rotation shenanigans.

 

Thank you for visiting this page,

Fluffydork of Nethergarde Keep (EU)