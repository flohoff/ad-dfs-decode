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

	# This is Microsoft. They fucked up the RFC Standard beyond
	# repair. They mixed byte order as they whished.
	sub _decodeGUID($self, $binguid) {
		my @a=unpack("VvvnNn",$binguid);
		return sprintf("%08X-%04X-%04X-%04X-%08X%04X",
			$a[0], $a[1], $a[2], $a[3], $a[4], $a[5]);
	}

	sub objectGUID {
		my ($self) = @_;
		my $value=$self->attribute_value_first("objectGUID");
		return $self->_decodeGUID($value);
	}

	sub _decodeSID {
		my ($self, $sidbin) = @_;

		my($sid_rev, $num_auths, $id1, $id2, @ids) =
			unpack("H2 H2 n N V*", $sidbin);
		return join("-", "S", $sid_rev, ($id1<<32)+$id2, @ids);
	}

	sub objectSID {
		my ($self) = @_;
		my $value=$self->attribute_value_first("objectSid");
		if (!defined($value)) {
			return undef;
		}
		return $self->_decodeSID($value);
	}
1;


