sub EVENT_SAY { 
    if ($text=~/Hail/i) {
        quest::say("Hello there. We have most the ships working again. If you need to [travel to Butcherblock] 
                    or [travel to Overthere],  [travel to Oasis] or [travel to Firiona] I can help you with this."); 
    } elsif ($text=~/travel to butcherblock/i && plugin::is_eligible_for_zone($client, 'butcher', 1)) {
        quest::say("Off you go!");
        quest::movepc(68,3168.92,851.92,11.66);
    } elsif ($text=~/travel to firiona/i && plugin::is_eligible_for_zone($client, 'firiona', 1)) {
        quest::say("Off you go!");
        quest::movepc(84,1417,-4335,-103,0);
    } elsif ($text=~/travel to oasis/i && plugin::is_eligible_for_zone($client, 'oasis', 1)) {
        quest::say("Off you go!");
        quest::movepc(37,-824,886,0,140);
    } elsif ($text=~/travel to overthere/i && plugin::is_eligible_for_zone($client, 'overthere', 1)) {
        quest::say("Off you go!");
        quest::movepc(93,2739,3428,-158,260);
    }
}