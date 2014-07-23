Name:           git-xcleaner
Version:        1.1
Release:        1%{?dist}

Summary:        Interactive git branch removal TUI

Group:          Applications/Productivity
License:        GPLv2
URL:            https://github.com/lzap/git-xcleaner
Source:         %{name}-%{version}.tar.gz

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:      noarch

BuildRequires:  rubygem-ronn sed
Requires:       newt

%description
git-xcleaner helps with deleting unused topic branches using TUI (text user
interface). It also offers mechanisms for pre-selecting branches that can be
safely removed.

%prep
%setup -q -n %{name}-%{version}

%build
ronn man/%{name}.md
ronn -m man/%{name}.md | sed -r 's/\x1b\[[0-9;]*m?//g' > man/%{name}.1.txt

%install
rm -rf $RPM_BUILD_ROOT

install -Dp %{name} $RPM_BUILD_ROOT%{_bindir}/%{name}
install -Dpm 644 man/%{name}.1 $RPM_BUILD_ROOT%{_mandir}/man1/%{name}.1

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc LICENSE README.md man/%{name}.1.txt
%{_bindir}/%{name}
%{_mandir}/man1/%{name}.1*

%changelog
* Wed Jul 23 2014 Lukas Zapletal <lzap+git@redhat.com> 1.1-1
- new package built with tito

* Wed Jul 23 2014 Lukas Zapletal <lzap+rpm@redhat.com> 1.0-1
- Initial version

