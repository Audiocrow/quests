sub EVENT_SAY {
	if ($client->GetGM()) {
		if ($text=~/god on/i) {
			quest::set_data("god-open", 10);
			quest::say("Enabling Gates of Discord Access");
		} elsif ($text=~/god off/i) {
			quest::delete_data("god-open");
			quest::say("Disabling Gates of Discord Access");
		}
	}
}