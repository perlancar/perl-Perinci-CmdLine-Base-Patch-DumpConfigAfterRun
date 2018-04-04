package Perinci::CmdLine::Base::Patch::DumpAndExit;

# DATE
# VERSION

use 5.010001;
use strict;
no warnings;

use Data::Dump::Color;
use Module::Patch;
use base qw(Module::Patch);

our %config;

sub patch_data {
    return {
        v => 3,
        patches => [
            {
                action      => 'wrap',
                sub_name    => 'run',
                code        => sub {
                    my $ctx = shift;

                    my ($self, $r) = @_;

                    {
                        local $self->{exit} = 0;
                        $ctx->{orig}->(@_);
                    }

                    dd $r->{config};

                    my $exitcode = $r->{res}[3]{'x.perinci.cmdline.base.exit_code'};

                    if ($self->exit) {
                        #log_trace("[pericmd] exit(%s)", $exitcode);
                        exit $exitcode;
                    } else {
                        # so this can be tested
                        return $r->{res};
                    }
                },
            },
        ],
        config => {
        },
   };
}

1;
# ABSTRACT: Patch Perinci::CmdLine::Base's run() to dump config after run

=for Pod::Coverage ^(patch_data)$

=head1 SYNOPSIS

 % PERL5OPT=-MPerinci::CmdLine::Base::Patch::DumpConfig yourscript.pl ...


=head1 DESCRIPTION

This patch can be used for debugging configuration reading. It wraps run()
to dump configuration after run.
