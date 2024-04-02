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
            plugin::NPCTell("You are one of patience, I see. All you need to do is bring me an Apocryphal Elemental Binder, an Apocryphal Djarn's Amethyst Ring, an Apocryphal Crown of the Froglok Kings, and an Apocryphal Scalp of the Ghoul Lord. This will grant you three Apocryphal tokens. When one is turned in to me, that hero will be granted access to The Ruins of Kunark.");
        }
    }

    if ($client->GetGM() && $text =~/debug/i) {
        $client->DeleteBucket("5003-progress-flag-RoK");
    }
}

sub EVENT_ITEM {
    my $test = quest::get_rule("Custom:MulticlassingEnabled");
    quest::debug("Rule Debug: $test");
    if (!plugin::is_stage_complete($client, 'RoK')) {
        if (plugin::check_handin_fixed(\%itemcount, 2028043 => 1, 2010366 => 1, 2010142 => 1, 2026997 => 1)) {
            set_subflag($client, 'RoK', 'Lord Nagafen', 1);
            set_subflag($client, 'RoK', 'Lady Vox', 1);
            quest::ding();
            quest::exp(100000);

            if (quest::get_rule("Custom:MulticlassingEnabled") ne "true") {
                plugin::NPCTell("Here are two additional tokens for your companions to also gain access to the Ruins of Kunark");
                quest::summonfixeditem(2019100);
                quest::summonfixeditem(2019100);
            }            
        } elsif (plugin::check_handin_fixed(\%itemcount, 2019100 => 1)) {
            set_subflag($client, 'RoK', 'Lord Nagafen', 1);
            set_subflag($client, 'RoK', 'Lady Vox', 1);
            quest::ding();
            quest::exp(100000);
        }
    }

    plugin::return_items(\%itemcount);
}