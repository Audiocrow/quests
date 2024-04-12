sub EVENT_SAY { 
    if ($text =~ /Hail/i) {
        quest::say("Hello there. There seem to be some strange problems with the boats in this area. " .
                   "The Academy of Arcane Sciences has sent a small team of us to investigate them. " .
                   "If you need to [" . quest::saylink("travel to Iceclad") . "] in the meantime, " .
                   "I can transport you to my companion there."); 
    }

    elsif ($text =~ /travel to iceclad/i && plugin::is_eligible_for_zone($client, 'iceclad', 1)) {
        quest::say("Off you go!");
        quest::movepc(110, 385, 5321, -16, 90); # Zone: iceclad
    }
}
