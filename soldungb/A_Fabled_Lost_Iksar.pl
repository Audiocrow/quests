sub EVENT_SPAWN {
  quest::settimer(1,1200);
}

	  


sub EVENT_SAY {

$key = $client->AccountID() . "-kunark-flag";
$expansion = quest::get_data($key);

$nagkey = $client->AccountID() . "-fabled-nag";

if ($text=~/hail/i){
  
  if (quest::get_data($nagkey) == "") {
    quest::set_data($nagkey, 1);
  quest::say("I am but one half. In death, I am warm. In death, she is cold. Oh how I miss spending evenings in Cabilis with you, my love.");
  $client->Message(4, "You have gained an expansion flag!");
  quest::set_data($key, quest::get_data($key) + 1);
  }
else
{
  quest::say("I have already given you my blessing! Would you like to check your [expansions] unlocked?");
}

}

 if (($text =~ /Expansions/i) && ($ == 0)) {
  quest::say("You don't have any expansions unlocked!");
 }

 if (($text =~ /Expansions/i) && ($expansion == 1)) {
  quest::say("You don't have any expansions unlocked!");
 }

 if (($text =~ /Expansions/i) && ($expansion >= 2)) {
  quest::say("Expansions Unlocked: Kunark");
 }
  if (($text =~ /Expansions/i) && ($expansion >= 6)) {
  quest::say("Expansions Unlocked: Velious");
 }
  if (($text =~ /Expansions/i) && ($expansion >= 14)) {
  quest::say("Expansions Unlocked: Luclin");
 }
  if (($text =~ /Expansions/i) && ($expansion >= 19 )) {
  quest::say("Expansions Unlocked: Planes of Power");
 }
 if (($text =~ /Expansions/i) && ($expansion >= 20 )) {
  quest::say("Expansions Unlocked: Fabled Vanilla");
 }

}

sub EVENT_TIMER {
  quest::depop();
}