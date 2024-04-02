sub EVENT_DEATH_COMPLETE {
    plugin::handle_death($npc);
    
    my $nanzata = $entity_list->GetMobByNpcTypeID(128090);
    my $ventani = $entity_list->GetMobByNpcTypeID(128091);
    my $hraashna = $entity_list->GetMobByNpcTypeID(128093);

    if (!$nanzata && !$ventani && !$hraashna) {
        quest::shout("Warders, I have fallen. Prepare yourselves, these fools are determined to unleash doom!");
    } else {
        quest::shout("Warders, I have fallen. Prepare yourselves, these fools are determined to unleash doom!");
    }
}

sub EVENT_KILLED_MERIT {
    plugin::handle_killed_merit($npc, $client);
}