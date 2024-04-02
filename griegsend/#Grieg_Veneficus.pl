sub EVENT_DEATH_COMPLETE {
    plugin::handle_death($npc);
}

sub EVENT_KILLED_MERIT {
    plugin::handle_killed_merit($npc, $client);
}