# https://developer.gnome.org/gtk3/stable/ch01s03.html
# builder.nim -- application style example using builder/glade xml file for user interface
# nim c builder.nim
import gintro/[gtk, gobject, gio], strformat
from osproc import execCmd
from os import paramStr

const glade = staticRead("main.glade")

proc quitApp(b: Button; app: Application) =
  echo "Bye"
  quit(app)

proc writeDesktopFile(name, comment, icon, command: string) =
  let text = fmt"[Desktop Entry]{'\n'}Name={name}{'\n'}Comment={comment}{'\n'}Icon={icon}{'\n'}Type=Application{'\n'}Exec={command}{'\n'}"
  writeFile(paramStr(1), text);
  discard execCmd(fmt"chmod +x {paramStr(1)}");

proc ok_proc(b: Button, args: tuple[builder: Builder, app: Application]) =
  let
    builder = args.builder
    app = args.app
    name    = builder.getEntry("name_entry").getText
    comment = builder.getEntry("comment_entry").getText
    icon    = builder.getEntry("icon_entry").getText
    command = builder.getEntry("command_entry").getText
  writeDesktopFile(name, comment, icon, command)
  quitApp(b, app);

proc appActivate(app: Application) =
  let builder = newBuilder()
  discard builder.addFromString(glade, glade.len)
  let window = builder.getApplicationWindow("window")
  window.setApplication(app)
  var button: Button = builder.getButton("ok_btn")
  button.connect("clicked", ok_proc, (builder, app))
  #button = builder.getButton("button2")
  #button.connect("clicked", hello, " again...")
  button = builder.getButton("cancel_btn")
  button.connect("clicked", quitApp, app)
  showAll(window)

proc main =
  let app = newApplication("org.gtk.example")
  connect(app, "activate", appActivate)
  discard run(app)

main()
