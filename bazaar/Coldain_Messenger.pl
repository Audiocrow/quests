my $item1 = 2005772;
my $item2 = 2003201;
my $item3 = 2001414;
my $item4 = 2004578;

my $token_item = 2019101;

my $stage_desc = "Scars of Velious";
my $hero_desc = "The Dragon-Lords of Kunark must be brought low.";

sub EVENT_SAY {
    if ($text=~/hail/i){
        if (plugin::is_stage_complete($client, 'SoL')) {
            plugin::YellowText("You have access to the $stage_desc.");
        } else {
            plugin::NPCTell("To gain access to the $stage_desc, two paths lie before you; [hero] and [explorer].");
        }
    }
    elsif (!plugin::is_stage_complete($client, 'SoL')) {
        if ($text =~/hero/i) {
            plugin::NPCTell($hero_desc);
            plugin::list_stage_prereq($client, 'SoL');            
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
    if (!plugin::is_stage_complete($client, 'SoL')) {
        if (plugin::check_handin_fixed(\%itemcount, $item1 => 1, $item2 => 1, $item3 => 1, $item4 => 1)) {            
          plugin::set_subflag($client, 'SoV', 'Trakanon', 1);
          plugin::set_subflag($client, 'SoV', 'Talendor', 1);
          plugin::set_subflag($client, 'SoV', 'Gorenaire', 1);
          plugin::set_subflag($client, 'SoV', 'Severilous', 1);
          quest::ding();
          quest::exp(100000);

            if (quest::get_rule("Custom:MulticlassingEnabled") ne "true") {
                plugin::NPCTell("Here are two additional tokens for your companions to also gain access to the $stage_desc");
                quest::summonfixeditem($token_item);
                quest::summonfixeditem($token_item);
            }            
        } elsif (plugin::check_handin_fixed(\%itemcount, $token_item => 1)) {
          plugin::set_subflag($client, 'SoV', 'Trakanon', 1);
          plugin::set_subflag($client, 'SoV', 'Talendor', 1);
          plugin::set_subflag($client, 'SoV', 'Gorenaire', 1);
          plugin::set_subflag($client, 'SoV', 'Severilous', 1);
          quest::ding();
          quest::exp(100000);
        }
    }

    plugin::return_items(\%itemcount);
}