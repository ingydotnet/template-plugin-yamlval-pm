use strict;
package Template::Plugin::YAMLVal;
our $VERSION = '0.12';

use base 'Template::Plugin';

use Template::Toolkit::Simple;
use YAML();
use YAML::XS();

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
