-module(action_event).
-author('Maxim Sokhatsky').
-include_lib("n2o/include/wf.hrl").
-compile(export_all).

render_action(#event{ 
    postback=Postback, actions=Actions, source=Source,
    anchor=Anchor, trigger=Trigger, target=Target, validation_group=ValidationGroup,
    type=Type, keycode=KeyCode, shift_key=ShiftKey, delay=Delay, delegate=Delegate,
    extra_param=ExtraParam}) ->
    Data = "[" ++ string:join([ "Bert.tuple(Bert.atom('"++atom_to_list(Src)++
                     "'), utf8.toByteArray($('#"++atom_to_list(Src)++"').vals()))" || Src <- Source ],",") ++ "]",

    Control = wf:coalesce([ValidationGroup, Trigger]),
    PostbackScript = wf_event:generate_postback_script(Postback, Anchor, Control, Delegate, event, Data),

    [
        wf:f("$('#~s').bind('~s',function anonymous(event) { ", [Control,Type]), PostbackScript, "});"
    ].
