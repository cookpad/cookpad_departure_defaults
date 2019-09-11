package pt_online_schema_change_plugin;

use strict;

sub new {
  my ($class, %args) = @_;
  my $self = { %args };
  return bless $self, $class;
}

sub init {
  my ($self, %args) = @_;
  $self->{orig_tbl} = $args{orig_tbl};
}

sub after_create_new_table {
  my ($self, %args) = @_;
  $self->{new_tbl} = $args{new_tbl};
}

sub after_copy_rows {
  my ($self, %args) = @_;
  my $orig_tbl = $self->{orig_tbl};
  my $new_tbl = $self->{new_tbl};
  my $tp = TableParser->new;
  my $dbh = $self->{cxn}->dbh;
  my $ddl =  $tp->get_create_table($dbh, $new_tbl->{db}, $new_tbl->{tbl});
  my $fks = $tp->get_fks($ddl, {database => $new_tbl->{db}});
  foreach my $name (keys %$fks) {
    my $fk = $fks->{$name};
    if ($fk->{parent_tblname} eq $orig_tbl->{name}) {
      # Rebuild a self-referencing foreign key in a new table to make it refer to itself.
      (my $constraint = $fk->{ddl}) =~ s/REFERENCES[^\(]+/REFERENCES $new_tbl->{name} /;

      # Rename the constraint to avoid a conflict.
      my $new_name;
      if ($name =~ /^__/) {
        ($new_name = $name) =~ s/^__//;
      } else {
        $new_name = '_' . $name;
      }
      $constraint =~ s/CONSTRAINT `$name`/CONSTRAINT `$new_name`/;

      print "Fixing self-referencing foreign key $name in table $new_tbl->{name}...\n";
      $dbh->do("SET foreign_key_checks = 0");
      my $sql = "ALTER TABLE $new_tbl->{name} DROP FOREIGN KEY `$name`, ADD $constraint";
      $dbh->do($sql);
      $dbh->do("SET foreign_key_checks = 1");
    }
  }
}

sub before_update_foreign_keys {
  my ($self, %args) = @_;
  my $dbh = $self->{cxn}->dbh;

  if ($self->{execute}) {
    # Disable foreign_key_checks to let MySQL use INPLACE algorithm
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
