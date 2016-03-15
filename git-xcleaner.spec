Name:           git-xcleaner
Version:        1.5
Release:        1%{?dist}

Summary:        Interactive git branch removal TUI

Group:          Applications/Productivity
License:        GPLv2
URL:            https://github.com/lzap/git-xcleaner
Source:         http://lzap.fedorapeople.org/projects/%{name}/%{name}-%{version}.tar.gz

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:      noarch

BuildRequires:  sed
%if 0%{?fedora} >= 22
BuildRequires:  rubygem-ronn
%endif
Requires:       /usr/bin/resize
Requires:       newt

%description
git-xcleaner helps with deleting unused topic branches using TUI (text user
interface). It also offers mechanisms for pre-selecting branches that can be
safely removed.

%prep
%setup -q -n %{name}-%{version}

%build
# Man page and ANSII-only text version of the man page for the embedded help
%if 0%{?fedora} >= 22
  ronn man/%{name}.md
  ronn -m man/%{name}.md | sed -r 's/\x1b\[[0-9;]*m?//g' > man/%{name}.1.txt
%else
  cp man/%{name}.md man/%{name}.1.txt
%endif

%install
rm -rf $RPM_BUILD_ROOT

install -Dp %{name} $RPM_BUILD_ROOT%{_bindir}/%{name}
%if 0%{?fedora} >= 22
  install -Dpm 644 man/%{name}.1 $RPM_BUILD_ROOT%{_mandir}/man1/%{name}.1
%endif

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc LICENSE README.md man/%{name}.1.txt
%{_bindir}/%{name}
%if 0%{?fedora} >= 22
%{_mandir}/man1/%{name}.1*
%endif

%changelog
* Tue Mar 15 2016 Lukas Zapletal <lzap+git@redhat.com> 1.5-1
- Updated man page (lzap+git@redhat.com)
- Fixed bugs (lzap+git@redhat.com)

* Wed Mar 09 2016 Lukas Zapletal <lzap+git@redhat.com> 1.4-1
- Improved confirmation message (lzap+git@redhat.com)
- Menu width is also fixed now (lzap+git@redhat.com)
- Added undelete instructions (lzap+git@redhat.com)
- Updated dependencies in README (lzap+git@redhat.com)
- Main menu is now smaller (lzap+git@redhat.com)
- Merged mode works with any base branch (lzap+git@redhat.com)
- Most of the lists are sorted by branch name now (lzap+git@redhat.com)
- Fix branch variables in message search mode (dcleal@redhat.com)
- Check for resize/xterm dependency (dcleal@redhat.com)
- Add missing require on resize/xterm (dcleal@redhat.com)

* Mon Aug 11 2014 Lukas Zapletal <lzap+git@redhat.com> 1.3-1
- Added dependency check during start (lzap+git@redhat.com)
- Cleaned source URL in SPEC (lzap+git@redhat.com)

* Thu Jul 24 2014 Lukas Zapletal <lzap+git@redhat.com> 1.2-1
- Reworded the welcome screen and URL change (lzap+git@redhat.com)

* Wed Jul 23 2014 Lukas Zapletal <lzap+git@redhat.com> 1.1-1
- new package built with tito

* Wed Jul 23 2014 Lukas Zapletal <lzap+rpm@redhat.com> 1.0-1
- Initial version

