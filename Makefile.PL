use inc::Module::Install;

name     'Data-SCORM-Manifest';
all_from 'lib/Data/SCORM/Manifest.pm';
author   q{OSFAMERON <osfameron@cpan.org>};
license  'perl';

build_requires 'Test::More';
build_requires 'Test::LongString';

requires 'Any::Moose';
requires 'Mouse';
requires 'MouseX::AttributeHelpers';
requires 'Mouse::Util::TypeConstraints';
requires 'Scalar::Util';
requires 'XML::Twig';
requires 'Archive::Extract';
requires 'File::Temp';
requires 'JSON::Any';

auto_install;

WriteAll;

