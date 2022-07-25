use strict;
use warnings;

use 5.006001;

use lib qw{ inc };

use ExtUtils::MakeMaker;
use My::Module::Meta qw{
    build_required_module_versions
    meta_merge
    required_module_versions
    requires_perl
    recommended_module_versions
};

( my $mmv = ExtUtils::MakeMaker->VERSION ) =~ s/_//g;

my %args = (
    NAME            => 'Perl::Critic::Policy::Variables::ProhibitNumericNamesWithLeadingZero',
    VERSION_FROM    => 'lib/Perl/Critic/Policy/Variables/ProhibitNumericNamesWithLeadingZero.pm',
    ABSTRACT_FROM    => 'lib/Perl/Critic/Policy/Variables/ProhibitNumericNamesWithLeadingZero.pm',
    PREREQ_PM       => { required_module_versions() },
    PL_FILES        => {},        # Prevent old MakeMaker from running Build.PL
    AUTHOR          => 'Tom Wyant (wyant at cpan dot org)',
);

$mmv >= 6.31
    and $args{LICENSE} = 'perl';

$mmv >= 6.4501
    and $args{META_MERGE} = meta_merge();

$mmv >= 6.4701
    and $args{MIN_PERL_VERSION} = requires_perl();

$mmv >= 6.5501
    and $args{BUILD_REQUIRES} = { build_required_module_versions() }
    or $mmv >= 6.4501
    and $args{META_MERGE}{build_requires} = { build_required_module_versions() };

WriteMakefile( %args );

sub MY::postamble {
    # my ( $self, @args ) = @_;
    my ( $self ) = @_;

    my $authortest = $self->test_via_harness(
	'$(FULLPERLRUN)', '$(AUTHORTEST_FILES)' );
    $authortest =~ s/ \s+ \z //smx;
    $authortest =~ s/ \A \s+ //smx;
    chomp $authortest;

    return <<"EOD";

AUTHORTEST_FILES = t/*.t xt/author/*.t

authortest :: pure_all
	AUTHOR_TESTING=1 $authortest

testcover :: pure_all
	cover -test
EOD
}

##############################################################################
# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
