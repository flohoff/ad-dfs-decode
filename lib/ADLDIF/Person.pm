package ADLDIF::Person;
	use strict;
	
	sub new {
		my ($class, $ldapobject) = @_;

		my $self={
			lo => $ldapobject
		};

		bless $self, $class;

		return $self;
	}

	sub samaccountname {
		my ($self) = @_;

		return $self
			->{lo}
			->attribute_value_first("sAMAccountName");
	}
1;


