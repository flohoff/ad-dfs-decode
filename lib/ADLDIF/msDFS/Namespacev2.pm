package ADLDIF::msDFS::Namespacev2;
	use strict;
	use feature qw(signatures);
	no warnings qw(experimental::signatures);
	use XML::Simple qw(:strict);
	
	sub new {
		my ($class, $ldapobject) = @_;

		my $self={
			lo => $ldapobject
		};

		bless $self, $class;

		return $self;
	}

	sub name($self) {
		return $self->{lo}->attribute_value_first("name");
	}

	sub id($self) {
		return $self->{lo}->attribute_value_first("msDFS-NamespaceIdentityGUIDv2");
	}

	sub targets($self) {
		my $lo=$self->{lo};

		my $xml=$lo->attribute_value_first("msDFS-TargetListv2");
		my $link=$lo->attribute_value_first("msDFS-LinkPathv2");

		my $data=XMLin($xml, KeyAttr => { targets => "targets" }, ForceArray => [ "targets" ]);
	
		return $data->{target};
	}
1;


