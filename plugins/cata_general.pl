#Used for Bic
sub ClassType {
    my $client = plugin::val('$client');
    my $class  = $client->GetClass();

    my %melee_classes = map { $_ => 1 } (1, 7, 9, 16);
    my %caster_classes = map { $_ => 1 } (11, 12, 13, 14);
    my %priest_classes = map { $_ => 1 } (2, 6, 10);

    if (exists $melee_classes{$class}) {
        return "melee";
    }

    if (exists $caster_classes{$class}) {
        return "caster";
    }

    if (exists $priest_classes{$class}) {
        return "priest";
    }

    return "hybrid";
}

#Usage: plugin::CheckCashPayment(target_val_in_copper, $copper, $silver, $gold, $platinum)
# Returns false if insufficient payment
# Returns true if sufficient payment
# Handles change, refunds, etc.
sub CheckCashPayment {
    my $client = plugin::val('$client');
    my $npc    = plugin::val('$npc');
    my ($target_value, $initial_copper, $initial_silver, $initial_gold, $initial_platinum) = @_;

    # Use a hash to store initial currency amounts for easier handling
    my %initial = (
        copper   => $initial_copper,
        silver   => $initial_silver,
        gold     => $initial_gold,
        platinum => $initial_platinum,
    );

    my $total_value = $initial{platinum} * 1000 + $initial{gold} * 100 + $initial{silver} * 10 + $initial{copper};
    my $remaining_value = $total_value - $target_value;

    if ($remaining_value >= 0) {
        my ($return_platinum, $return_gold, $return_silver, $return_copper) = (
            int($remaining_value / 1000),
            int(($remaining_value % 1000) / 100),
            int(($remaining_value % 100) / 10),
            $remaining_value % 10
        );

        my %spent = (
            platinum => $initial{platinum} - $return_platinum,
            gold     => $initial{gold} - $return_gold,
            silver   => $initial{silver} - $return_silver,
            copper   => $initial{copper} - $return_copper,
        );

        my $message = "You give ";
        my @messages;
        foreach my $currency (qw(platinum gold silver copper)) {
            push @messages, "$spent{$currency} $currency" if $spent{$currency} > 0;
        }
        $message .= join(' ', @messages) . " to " . $npc->GetCleanName() . ".";
        
        $client->Message(276, $message);

        # Inform the client of the change they receive, if any
        if ($remaining_value > 0) {
            my $change_message = "You receive ";
            my @change_parts;
            foreach my $currency (qw(platinum gold silver copper)) {
                if (${"return_$currency"} > 0) {
                    push @change_parts, "${return_$currency} $currency";
                }
            }
            $change_message .= join(' ', @change_parts) . " in change from " . $npc->GetCleanName() . ".";
            $client->Message(276, $change_message);
        }

        # Provide the change back to the player's account
        $client->AddMoneyToPP($return_copper, $return_silver, $return_gold, $return_platinum, 1);
        
        return 1;
    } else {
        # Refund all the money since the target value was not met
        $client->AddMoneyToPP($initial{copper}, $initial{silver}, $initial{gold}, $initial{platinum}, 1);
        my $refund_message = "Transaction failed. You have been refunded ";
        my @refund_parts;
        foreach my $currency (qw(platinum gold silver copper)) {
            push @refund_parts, "$initial{$currency} $currency" if ($initial{$currency} > 0);
        }
        $refund_message .= join(' ', @refund_parts) . ".";
        $client->Message(276, $refund_message);
        return 0;
    }
}