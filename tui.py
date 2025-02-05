import subprocess
from picotui.widgets import *
from picotui.menu import *
from picotui.context import Context


# Dialog on the screen
d = None
list_dict = {}

# This routine is called to redraw screen "in menu's background"
def screen_redraw(s, allow_cursor=False):
    s.attr_color(C_WHITE, C_WHITE)
    s.cls()
    s.attr_reset()
    d.redraw()


# We have two independent widgets on screen: dialog and main menu,
# so can't call their individual loops, and instead should have
# "main loop" to route events to currently active widget, and
# switch the active one based on special events.
def main_loop():
    while 1:
        key = m.get_input()

        if isinstance(key, list):
            # Mouse click
            x, y = key
            if m.inside(x, y):
                m.focus = True

        if m.focus:
            # If menu is focused, it gets events. If menu is cancelled,
            # it loses focus. Otherwise, if menu selection is made, we
            # quit with with menu result.
            res = m.handle_input(key)
            if res == ACTION_CANCEL:
                m.focus = False
            elif res is not None and res is not True:
                cmd = "./hooami3_param.sh " + res
                stream = os.popen(cmd)
                output = stream.read()
                output_list = output.split('\n')
                plist = list()
                for out in output_list:
                    plist.append(out)
                    #if out.find('=') > -1:
                    #    out_split = out.split('=')
                    #    list_dict[out_split[0]] = out_split[1]
                #w_listbox = WListBox(90, 30, list(list_dict.keys()))
                w_listbox = WListBox(90, 30, plist)
                d.add(1, 3, w_listbox)
                #w_listbox.on("changed", listbox_changed)
                w_listbox.redraw()
        else:
            # If menu isn't focused, it can be focused by pressing F9.
            if key == KEY_F9:
                m.focus = True
                m.redraw()
                continue
            # Otherwise, dialog gets input
            res = d.handle_input(key)
            if res is not None and res is not True:
                return res


def listbox_changed(w):
    val = w.items[w.choice]
    w_listbox_val.t = list_dict[val] 
    w_listbox_val.redraw()


with Context():

    d = Dialog(20, 5, 100, 35)
    d.add(30, 1, WLabel("Press F9 for menu"))
    d.add(22, 2, WLabel("Meta Data"))
    ##d.add(1, 3, WListBox(16, 4, ["choice%d" % i for i in range(10)]))
    ##d.add(1, 24, WDropDown(10, ["Red", "Green", "Yellow"]))

    #d.add(1, 35, WLabel("Meta Data Information:"))
    w_listbox_val = WLabel("", w=80)
    d.add(25, 35, w_listbox_val)
    b = WButton(8, "OK")
    d.add(10, 38, b)
    b.finish_dialog = ACTION_OK

    b = WButton(8, "Cancel")
    d.add(23, 38, b)
    b.finish_dialog = ACTION_CANCEL

    screen_redraw(Screen)
    Screen.set_screen_redraw(screen_redraw)

    menu_file = WMenuBox([("ALL","ALL"),("bdm-ami", "bdm-ami"), ("bdm-ebs", "bdm-ebs"), ("event-hist","event-hist"), ("event-schd","event-schd")
                          ,("event-rebal","event-rebal"), ("iam-info","iam-info"),("iam-role","iam-role"),("inst-act","inst-act")
                          ,("inst-id","inst-id"), ("inst-type","inst-type"),("ker-id","ker-id"),("l-ip4","l-ip4"),("vpc-id","vpc-id")
                          ,("az","az"),("az-id","az-id"),("rg","rg"),("p-ip4","p-ip4"),("sg","sg"),("tag-inst","tag-inst")])
    m = WMenuBar([("COMMAND", menu_file)])
    m.permanent = True
    m.redraw()

    res = main_loop()


print("Result:", res)
