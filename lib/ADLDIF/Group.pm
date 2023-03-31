package ADLDIF::Group;
	use strict;
	
	sub new {
		my ($class, $ldapobject) = @_;

		my $self={
			lo => $ldapobject
		};

		bless $self, $class;

		return $self;
	}
1;


