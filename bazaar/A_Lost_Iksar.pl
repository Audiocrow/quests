my $item1 = 2028043;
my $item2 = 2010366;
my $item3 = 2010142;
my $item4 = 2026997;

my $token_item = 2019100;

my $stage_desc = "Ruins of Kunark";
my $hero_desc = "Slay the champions of the Old World; Nagafen and Vox.";

sub EVENT_SAY {
    if ($text=~/hail/i){
        if (plugin::is_stage_complete($client, 'RoK')) {
            plugin::YellowText("You have access to the $stage_desc.");
        } else {
            plugin::NPCTell("To gain access to the $stage_desc, two paths lie before you; [hero] and [explorer].");
        }
    }
    elsif (!plugin::is_stage_complete($client, 'RoK')) {
        if ($text =~/hero/i) {
            plugin::NPCTell($hero_desc);
            plugin::list_stage_prereq($client, 'RoK');            
        }
        if (($text =~/explorer/i)){
            my $item1_link = quest::varlink($item1);
            my $item2_link = quest::varlink($item2);
            my $item3_link = quest::varlink($item3);
            my $item4_link = quest::varlink($item4);

            my $response_string = "In that case, you will need to do is bring me the one each of following: [$item1_link], [$item2_link], [$item3_link], and [$item4_link].";
            if (quest::get_rule("Custom:MulticlassingEnabled") ne "true") {
                $response_string = $response_string . " Not only will I grant you access to the $stage_desc, but I will give you two tokens so that your companions can present them to me in order to also gain access.";
            }

            plugin::NPCTell($response_string);
        }
    }
}

sub EVENT_ITEM {
    if (!plugin::is_stage_complete($client, 'RoK')) {
        if (plugin::check_handin_fixed(\%itemcount, $item1 => 1, $item2 => 1, $item3 => 1, $item4 => 1)) {
            set_subflag($client, 'RoK', 'Lord Nagafen', 1);
            set_subflag($client, 'RoK', 'Lady Vox', 1);
            quest::ding();
            quest::exp(100000);

            if (quest::get_rule("Custom:MulticlassingEnabled") ne "true") {
                plugin::NPCTell("Here are two additional tokens for your companions to also gain access to the $stage_desc");
                quest::summonfixeditem($token_item);
                quest::summonfixeditem($token_item);
            }            
        } elsif (plugin::check_handin_fixed(\%itemcount, $token_item => 1)) {
            set_subflag($client, 'RoK', 'Lord Nagafen', 1);
            set_subflag($client, 'RoK', 'Lady Vox', 1);
            quest::ding();
            quest::exp(100000);
        }
    }

    plugin::return_items(\%itemcount);
}