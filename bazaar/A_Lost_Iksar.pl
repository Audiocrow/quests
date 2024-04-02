my $item1 = 2028043;
my $item2 = 2010366;
my $item3 = 2010142;
my $item4 = 2026997;

my $stage_desc = "Ruins of Kunark";
my $hero_desc = "Slay the champions of the Old World; Nagafen and Vox.";

sub EVENT_SAY {
    if ($text=~/hail/i){
        quest::emote("looks around, as if confused.");
        if (plugin::is_stage_complete($client, 'RoK')) {
            plugin::YellowText("You have access to the $stage_desc.");
        } else {
            plugin::NPCTell("To gain access to the $stage_desc, two paths lie before you; [hero] and [explorer].");
        }
    }
    elsif (!plugin::is_stage_complete($client, 'RoK')) {
        if ($text =~/hero/i) {
            plugin::NPCTell("Slay the champions of the Old World; Nagafen and Vox.");
            plugin::list_stage_prereq($client, 'RoK');            
        }
        if (($text =~/explorer/i)){
            my $item1_link = quest::varlink($item1);
            my $item2_link = quest::varlink($item2);
            my $item3_link = quest::varlink($item3);
            my $item4_link = quest::varlink($item4);

            my $response_string = "In that case, you will need to do is bring me an [$item1_link], a [$item2_link], a [$item3_link], and a [$item4_link].";
            if (quest::get_rule("Custom:MulticlassingEnabled") ne "true") {
                $response_string = $response_string . " Not only will I grant you access to the $stage_desc, but I will give you two tokens so that your companions can present them to me in order to also gain access.";
            }

            plugin::NPCTell($response_string);
        }
    }
}

sub EVENT_ITEM {
    if (!plugin::is_stage_complete($client, 'RoK')) {
        if (plugin::check_handin_fixed(\%itemcount, 2028043 => 1, 2010366 => 1, 2010142 => 1, 2026997 => 1)) {
            set_subflag($client, 'RoK', 'Lord Nagafen', 1);
            set_subflag($client, 'RoK', 'Lady Vox', 1);
            quest::ding();
            quest::exp(100000);

            if (quest::get_rule("Custom:MulticlassingEnabled") ne "true") {
                plugin::NPCTell("Here are two additional tokens for your companions to also gain access to the $stage_desc");
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