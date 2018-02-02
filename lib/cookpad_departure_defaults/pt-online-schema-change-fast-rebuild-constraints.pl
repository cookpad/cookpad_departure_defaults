# This file is used by pt-online-schema-change, when migrations are ran via
# the Departure gem, to speed migration by turning off foreign key checks
# until after the migration is completed.

package pt_online_schema_change_plugin;

use strict;

sub new {
  my ($class, %args) = @_;
  my $self = { %args };
  return bless $self, $class;
}

sub before_update_foreign_keys {
  my ($self, %args) = @_;
  my $dbh = $self->{cxn}->dbh;

  if ($self->{execute}) {
    print "Disable foreign key checks\n";
    $dbh->do("set foreign_key_checks=0");
  }
}

sub after_update_foreign_keys {
  my ($self, %args) = @_;
  my $dbh = $self->{cxn}->dbh;

  if ($self->{execute}) {
    print "Enable foreign key checks\n";
    $dbh->do("set foreign_key_checks=1");
  }
}

1;
