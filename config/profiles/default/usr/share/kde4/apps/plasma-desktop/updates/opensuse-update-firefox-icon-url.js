function updateFirefoxUrl(widget, containment) {
  if (widget != undefined) {
    if (widget.readConfig('Url') == 'file:///usr/share/applications/MozillaFirefox.desktop')
    {
      widget.writeConfig('Url', 'firefox.desktop');
      widget.reloadConfig();
    }
  }
}

var template = loadTemplate('org.kde.plasma-desktop.findWidgets');
if (template != undefined && template.findWidgets != undefined) {
  template.findWidgets('icon', updateFirefoxUrl)
}
