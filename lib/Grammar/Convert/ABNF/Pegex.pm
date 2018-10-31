package Grammar::Convert::ABNF::Pegex;

use v5.20;

use strict;
use warnings;

use feature 'signatures';
no warnings 'experimental::signatures';

use Moo;
use Parse::ABNF;

has abnf   => ( is => 'ro', required => 1 );
has pegex  => ( is => 'ro', lazy => 1, default => sub ( $self ) {
    $self->_abnf_to_pegex;
});
has parser => ( is => 'ro', lazy => 1, default => sub {
    Parse::ABNF->new
});

sub _abnf_to_pegex ($self) {
    my $grammar = $self->parser->parse( $self->abnf );

    my @rules;
    for my $rule ( @{ $grammar || [] } ) {
        push @rules, $self->_rule_to_pegex( $rule );
    }

    my $pegex = join "\n\n", @rules;
    return "$pegex\n";
}

sub _rule_to_pegex ($self, $rule) {
    return if !$rule->{class} eq 'Rule';

    my $name      = $rule->{name};
    my $body_type = $rule->{value}->{class};
    my $sub       = $self->can('_conv_' . lc $body_type );

    return if !$sub;

    my $rule_body  = $self->$sub( $rule->{value} );
    my $pegex_rule = sprintf "%s: %s", $name, $rule_body;

    return $pegex_rule;
}

sub _conv_choice ($self, $choice ) {
    my @elements;

    for my $element ( @{ $choice->{value} || [] } ) {
        my $elem_type = $element->{class};
        my $sub       = $self->can('_conv_' . lc $elem_type );

        return if !$sub;

        push @elements, $self->$sub( $element );
    }

    return join ' | ', @elements;
}

sub _conv_group ( $self, $group ) {
    my @elements;

    for my $element ( @{ $group->{value} || [] } ) {
        my $elem_type = $element->{class};
        my $sub       = $self->can('_conv_' . lc $elem_type );

        return if !$sub;

        push @elements, $self->$sub( $element );
    }

    return sprintf "(%s)", join ' ', @elements;
}

sub _conv_repetition ( $self, $rep ) {
    my $elem_type = $rep->{value}->{class};
    my $sub       = $self->can('_conv_' . lc $elem_type );

    return if !$sub;

    my $name = $self->$sub( $rep->{value} );

    my %rep_map = (
        '0+' => '*',
        '1+' => '+',
        '01' => '?',
    );

    my $rep_key    = join '', ( $rep->{min} // 0, $rep->{max} // '+' );
    my $repetition = $rep_map{$rep_key} // '';

    return sprintf "%s%s", $name, $repetition;
}

sub _conv_reference ( $self, $element ) {
    return $element->{name};
}

sub _conv_literal ( $self, $element ) {
    return sprintf "'%s'", $element->{value};
}

1;
