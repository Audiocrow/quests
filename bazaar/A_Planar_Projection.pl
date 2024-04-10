my $item1 = 17324;
my $item2 = 2028708;
my $item3 = 2026826;
my $item4 = 2061227;

my $token_item = 2019103;

my $stage_desc  = "Planes of Power";
my $hero_desc   = "To enter the Planes of Power, you must slay the Crawling Beast, the Master of End, the Creature of Nightmares, the Giver of Hate, and the Mighty Emperor.";
my $stage_key   = "PoP";
my @target_list = (
    'Thought Horror Overfiend',
    'The Insanity Crawler',
    'Greig Veneficus',
    'Xerkizh the Creator',
    'Emperor Ssraeshza'
);


sub EVENT_SAY {
    if ($text=~/hail/i){
        if (plugin::is_stage_complete($client, $stage_key)) {
            plugin::YellowText("You have access to the $stage_desc.");
        } else {
            plugin::NPCTell("To gain access to the $stage_desc, two paths lie before you; [hero] and [explorer].");
        }
    }
    elsif (!plugin::is_stage_complete($client, $stage_key)) {
        if ($text =~/hero/i) {
            plugin::NPCTell($hero_desc);
            plugin::list_stage_prereq($client, $stage_key);            
        }
        if (($text =~/explorer/i)){
            my $item1_flag = quest::get_data($client->AccountID() . "-$item1-flag") || 0;
            my $item2_flag = quest::get_data($client->AccountID() . "-$item2-flag") || 0;
            my $item3_flag = quest::get_data($client->AccountID() . "-$item3-flag") || 0;
            my $item4_flag = quest::get_data($client->AccountID() . "-$item4-flag") || 0;

            my $item1_link = quest::varlink($item1);
            my $item2_link = quest::varlink($item2);
            my $item3_link = quest::varlink($item3);
            my $item4_link = quest::varlink($item4);

            my $response_string = "In that case, you will need to do is bring me the one each of following: [$item1_link], [$item2_link], [$item3_link], and [$item4_link].";
            if (quest::get_rule("Custom:MulticlassingEnabled") ne "true") {
                $response_string = $response_string . " Not only will I grant you access to the $stage_desc, but I will give you two tokens so that your companions can present them to me in order to also gain access.";
            }

            plugin::NPCTell($response_string);

            if ($item1_flag) {
                plugin::YellowText("You have collected a [$item1_link].");
            } else {
                plugin::YellowText("You yet to collect a [$item1_link].");
            }

            if ($item2_flag) {
                plugin::YellowText("You have collected a [$item2_link].");
            } else {
                plugin::YellowText("You yet to collect a [$item2_link].");
            }

            if ($item3_flag) {
                plugin::YellowText("You have collected a [$item3_link].");
            } else {
                plugin::YellowText("You yet to collect a [$item3_link].");
            }

            if ($item4_flag) {
                plugin::YellowText("You have collected a [$item4_link].");
            } else {
                plugin::YellowText("You yet to collect a [$item4_link].");
            }
        }
    }
}

sub EVENT_ITEM {
    if (!plugin::is_stage_complete($client, $stage_key)) {
        my $item1_flag = quest::get_data($client->AccountID() . "-$item1-flag") || 0;
        my $item2_flag = quest::get_data($client->AccountID() . "-$item2-flag") || 0;
        my $item3_flag = quest::get_data($client->AccountID() . "-$item3-flag") || 0;
        my $item4_flag = quest::get_data($client->AccountID() . "-$item4-flag") || 0;

        my $item1_link = quest::varlink($item1);
        my $item2_link = quest::varlink($item2);
        my $item3_link = quest::varlink($item3);
        my $item4_link = quest::varlink($item4);

        if (!$item1_flag && plugin::check_handin_fixed(\%itemcount, $item1 => 1)) {
            plugin::NPCTell("Perfect, this [$item1_link] is exactly what I needed.");
            quest::set_data($client->AccountID() . "-$item1-flag", 1);
        }

        if (!$item2_flag && plugin::check_handin_fixed(\%itemcount, $item2 => 1)) {
            plugin::NPCTell("Perfect, this [$item2_link] is exactly what I needed.");
            quest::set_data($client->AccountID() . "-$item2-flag", 1);
        }

        if (!$item3_flag && plugin::check_handin_fixed(\%itemcount, $item3 => 1)) {
            plugin::NPCTell("Perfect, this [$item3_link] is exactly what I needed.");
            quest::set_data($client->AccountID() . "-$item3-flag", 1);
        }

        if (!$item4_flag && plugin::check_handin_fixed(\%itemcount, $item4 => 1)) {
            plugin::NPCTell("Perfect, this [$item4_link] is exactly what I needed.");
            quest::set_data($client->AccountID() . "-$item4-flag", 1);
        }


        if ($item1_flag && $item2_flag && $item3_flag && $item4_flag) {            
            foreach my $target (@target_list) {
                set_subflag($client, $stage_key, $target, 1);
            }

            plugin::NPCTell("Excellent, you have collected all of the items which I require. Going forward, you will be able to access the $stage_desc.");
            quest::ding();      
            if (quest::get_rule("Custom:MulticlassingEnabled") ne "true") {
                plugin::NPCTell("Here are two additional tokens for your companions to also gain access to the $stage_desc");
                quest::summonfixeditem($token_item);
                quest::summonfixeditem($token_item);
            }

        } elsif (plugin::check_handin_fixed(\%itemcount, $token_item => 1)) {
            foreach my $target (@target_list) {
                set_subflag($client, $stage_key, $target, 1);
            }

            plugin::NPCTell("You want to call in a favor? Fine. Going forward, you will be able to access the $stage_desc.");
            quest::ding();
        } else {
            if ($item1_flag) {
                plugin::YellowText("You have collected a [$item1_link].");
            } else {
                plugin::YellowText("You yet to collect a [$item1_link].");
            }

            if ($item2_flag) {
                plugin::YellowText("You have collected a [$item2_link].");
            } else {
                plugin::YellowText("You yet to collect a [$item2_link].");
            }

            if ($item3_flag) {
                plugin::YellowText("You have collected a [$item3_link].");
            } else {
                plugin::YellowText("You yet to collect a [$item3_link].");
            }

            if ($item4_flag) {
                plugin::YellowText("You have collected a [$item4_link].");
            } else {
                plugin::YellowText("You yet to collect a [$item4_link].");
            }
        }   
    }

    plugin::return_items(\%itemcount);
}