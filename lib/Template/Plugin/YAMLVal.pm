##
# name: Template::Plugin::YAMLVal
# abstract: yamlval vmethod for Template Toolkit
# author: Ingy döt Net <ingy@ingy.net>
# license: perl
# copyright: 2011
# see:
# - Template
# - YAML

package Template::Plugin::YAMLVal;
use 5.008003;
use strict;
use base 'Template::Plugin';

our $VERSION = '0.10';

use Template::Toolkit::Simple 0.13;
use YAML 0.72 ();
use YAML::XS 0.35 ();

sub new {
    my ($class, $context) = @_;
    my $self = bless {}, $class;
    $context->define_vmethod(
        $_ => yamlval => sub {
            $self->yamlval(@_)
        }
    ) for qw[hash list scalar];
    return $self;
}

sub yamlval {
    my ($self, $value) = @_;
    my $dumper = ref($value)
        ? \&YAML::XS::Dump
        : \&YAML::Dump;
    my $dump = &$dumper({ fakekey => $value });
    $dump =~ s/^.*?fakekey://s;
    $dump =~ s/^ //s;
    chomp $dump;
    return $dump;
}

1;

=head1 SYNOPSIS

    [% USE YAMLVal %]
    foo: [% foo.yamlval %]
    bar: [% bar.yamlval %]

=head1 DESCRIPTION

This module lets you use Template Toolkit to write out YAML mapping files in a
certain top level key order, while making sure that the keys are properly YAML
encoded.

There may be other use cases, but that's the one that drove me to write this.
