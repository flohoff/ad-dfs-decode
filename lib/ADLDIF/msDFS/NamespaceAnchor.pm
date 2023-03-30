package ADLDIF::msDFS::NamespaceAnchor;
	use strict;
	use XML::Simple qw(:strict);
	
	sub new {
		my ($class, $ldapobject) = @_;

		my $self={
			lo => $ldapobject
		};

		bless $self, $class;

		return $self;
	}
1;


