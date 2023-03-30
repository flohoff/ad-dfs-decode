package ADLDIF::LDAP::Attribute;
	use strict;
	use MIME::Base64;
	
	sub new {
		my ($class, $key, $encoded, $value) = @_;

		my $self={
			key => $key,
			value => $value
		};

		if ($encoded) {
			$self->{encoded}=1;
		}

		bless $self, $class;

		return $self;
	}

	sub append {
		my ($self, $value) = @_;
		$self->{value}.=$value;
	}

	sub value_decoded {
		my ($self) = @_;
		my $string=$self->{value};
		$string=~ s|\\|/|g;
		return decode_base64($string);
	}

	sub value {
		my ($self) = @_;
		return defined($self->{encoded})
			? $self->value_decoded()
			: $self->{value};
	}

1;


