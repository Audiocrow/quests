sub EVENT_SAY { 
  if ($text=~/Hail/i) {
    quest::say("Hello there. There seems to be some strange problems with the boats in this area. 
                The Academy of Arcane Sciences has sent a small team of us to investigate them. 
                If you need to [" . quest::saylink("travel to Freeport") . "] or 
                [" . quest::saylink("travel to Butcherblock") . "] in the meantime, 
                I can transport you to my companion there.");
  } elsif ($text=~/travel to freeport/i && plugin::is_eligible_for_zone($client, 'freporte', 1)) {
    quest::say("Off you go!");
    quest::movepc(10,-1006.66,-14.65,-53.47,64); # Zone: freporte
  } elsif ($text=~/travel to butcherblock/i && plugin::is_eligible_for_zone($client, 'butcher', 1)) {
    quest::say("Off you go!");
    quest::movepc(68,3112,856,12,90);
  }
}
