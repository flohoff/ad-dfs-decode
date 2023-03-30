package ADLDIF::LDAP::Object;
	use strict;
	use MIME::Base64;
	use List::Util qw/any/;
	use ADLDIF::LDAP::Attribute;
	use feature qw(signatures);
	no warnings qw(experimental::signatures);
	
	sub new {
		my ($class, $entry) = @_;

		my $self={};
		bless $self, $class;

		$self->_parse($entry);

		return $self;
	}

	sub _parse {
		my ($self, $entry) = @_;

		my $attr;

		foreach ( @{$entry} ) {
			if (/^([^:]+)(:+)\s*(.*)$/) {
				$attr=new ADLDIF::LDAP::Attribute($1, $2 eq '::', $3);
				push @{$self->{attr}{$1}}, $attr;
			} elsif (/^\s+(.*)$/) {
				$attr->append($1);
			}
		}
	}

	sub objectClass_contains {
		my ($self, $oc) = @_;
		return any { $_->value() eq $oc } @{$self->{attr}{"objectClass"}};
	}

	sub attribute {
		my ($self, $key) = @_;
		return $self->{attr}{$key};
	}

	sub attribute_value_first($self, $key, $ifundef=undef) {
		my $e=$self->attribute_first($key);

		return defined($e) ? $e->value() : $ifundef;
	}

	sub attribute_first {
		my ($self, $key) = @_;

		my $e=$self->attribute($key);

		return defined($e) ? $e->[0] : undef;
	}
1;


