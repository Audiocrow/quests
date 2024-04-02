sub EVENT_SAY {
    if ($text=~/hail/i){
        quest::emote("looks around, as if confused.");
        if (plugin::is_stage_complete($client, 'RoK')) {
            plugin::YellowText("You have access to the Ruins of Kunark.");
        } else {
            plugin::NPCTell("To gain access to the Ruins of Kunark, two paths lie before you; [hero] and [explorer].");
        }
    }
    elsif (!plugin::is_stage_complete($client, 'RoK')) {
        if ($text =~/hero/i) {
            plugin::NPCTell("Slay the champions of the Old World; Nagafen and Vox.");
            plugin::list_stage_prereq($client, 'RoK');            
        }
        if (($text =~/explorer/i) && ($expansion <2)){
            plugin::Whisper("You are one of patience, I see. All you need to do is bring me an Apocryphal Elemental Binder, an Apocryphal Djarn's Amethyst Ring, an Apocryphal Crown of the Froglok Kings, and an Apocryphal Scalp of the Ghoul Lord. This will grant you three Apocryphal tokens. When one is turned in to me, that hero will be granted access to The Ruins of Kunark.");
        }
    }
}

sub EVENT_ITEM {
    my $test = quest::get_rule("Custom:MulticlassingEnabled");
    quest::debug("Rule Debug: $test");
    if (!plugin::is_stage_complete($client, 'RoK')) {
    }

    plugin::return_items(\%itemcount);

    if ($expansion < 20){
        if (plugin::check_handin_fixed(\%itemcount, 2028043 => 1, 2010366 => 1, 2010142 => 1, 2026997 => 1)) {
		    plugin::Whisper("Here are three tokens. Hand them back to me for your flag!");
            quest::ding();
            quest::exp(100000);
            quest::summonfixeditem(2019100);
            quest::summonfixeditem(2019100);
            quest::summonfixeditem(2019100);
        }
        if (plugin::check_handin_fixed(\%itemcount, 2019100 => 1)) {
		    plugin::Whisper("Beware of the evils that lurk Kunark $name!");
            quest::ding();
            quest::set_data($key, 2);
            quest::set_data($nagkey, 1);
            quest::set_data($voxkey, 1);
	    }
	    #:: Return unused items
    }
}