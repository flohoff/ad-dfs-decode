package ADLDIF::msDFS::Linkv2;
	use strict;
	use feature qw(signatures);
	no warnings qw(experimental::signatures);
	use XML::Simple qw(:strict);
	use Data::Dumper;
	
	sub new {
		my ($class, $ldapobject) = @_;

		my $self={
			lo => $ldapobject
		};

		bless $self, $class;

		return $self;
	}

	sub path($self) {
		my $path=$self->{lo}->attribute_value_first("msDFS-LinkPathv2");

		if (!defined($path)) {
			printf("No path in Linkv2\n");
			return undef;
		}
		return $path;
	}

	sub namespaceid($self) {
		return $self->{lo}->attribute_value_first("msDFS-NamespaceIdentityGUIDv2");
	}


	sub targets($self) {
		my $lo=$self->{lo};

		my $xml=$lo->attribute_value_first("msDFS-TargetListv2");
		my $link=$lo->attribute_value_first("msDFS-LinkPathv2");

		my $data=XMLin($xml, KeyAttr => { targets => "targets" }, ForceArray => [ "targets", "target" ]);
	
		return $data->{target};
	}
1;

