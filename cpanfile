requires perl => 'v5.20';

requires 'Moo' => '1.003001';
requires 'Parse::ABNF';

on test => sub {
    requires 'Path::Tiny';
};

on develop => sub {
    requires 'Dist::Zilla::PluginBundle::Basic';
    requires 'Dist::Zilla::PluginBundle::Filter';
    requires 'Dist::Zilla::PluginBundle::Git';
    requires 'Dist::Zilla::Plugin::ContributorsFile';
    requires 'Dist::Zilla::Plugin::Git::GatherDir';
    requires 'Dist::Zilla::Plugin::Git::Contributors';
    requires 'Dist::Zilla::Plugin::GitHubREADME::Badge';
    requires 'Dist::Zilla::Plugin::MetaJSON';
    requires 'Dist::Zilla::Plugin::MetaProvides::Package';
    requires 'Dist::Zilla::Plugin::MetaResources';
    requires 'Dist::Zilla::Plugin::PodCoverageTests';
    requires 'Dist::Zilla::Plugin::PodSyntaxTests';
    requires 'Dist::Zilla::Plugin::PodWeaver';
    requires 'Dist::Zilla::Plugin::Prereqs::FromCPANfile';
    requires 'Dist::Zilla::Plugin::ReadmeAddDevInfo';
    requires 'Dist::Zilla::Plugin::ReadmeAnyFromPod';
    requires 'Dist::Zilla::Plugin::VersionFromModule';

    # These are for the Dist::Zilla generated Pod tests.
    requires 'Test::Pod';
    requires 'Test::Pod::Coverage';
    requires 'Pod::Coverage::TrustPod';
};
