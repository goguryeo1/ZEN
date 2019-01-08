/*
 * Author: mharis001
 * Initializes the "Bind Variable To Object" Zeus module display.
 *
 * Arguments:
 * 0: bindVariable controls group <CONTROL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [CONTROL] call zen_modules_fnc_ui_bindVariable
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_control"];

// Generic init
private _display = ctrlParent _control;
private _ctrlButtonOK = _display displayCtrl IDC_OK;
private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
TRACE_1("Logic Object",_logic);

_control ctrlRemoveAllEventHandlers "SetFocus";

// Validate module target
private _object = attachedTo _logic;
TRACE_1("Attached Unit",_object);

scopeName "Main";
private _fnc_errorAndClose = {
    params ["_msg"];
    _display closeDisplay 0;
    deleteVehicle _logic;
    [_msg] call EFUNC(common,showMessage);
    breakOut "Main";
};

if (isNull _object) then {
    [LSTRING(NothingSelected)] call _fnc_errorAndClose;
};

private _fnc_onUnload = {
    private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
    if (isNull _logic) exitWith {};

    deleteVehicle _logic;
};

private _fnc_onConfirm = {
    params ["_ctrlButtonOK"];

    private _display = ctrlParent _ctrlButtonOK;
    if (isNull _display) exitWith {};

    private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
    if (isNull _logic) exitWith {};

    private _object = attachedTo _logic;

    private _ctrlVariableName = _display displayCtrl IDC_BINDVARIABLE_NAME;
    private _variableName = ctrlText _ctrlVariableName;

    if (_variableName == "") exitWith {};

    private _ctrlPublic = _display displayCtrl IDC_BINDVARIABLE_PUBLIC;
    private _isPublic = lbCurSel _ctrlPublic > 0;

    missionNamespace setVariable [_variableName, _object, _isPublic];

    deleteVehicle _logic;
};

_display displayAddEventHandler ["Unload", _fnc_onUnload];
_ctrlButtonOK ctrlAddEventHandler ["ButtonClick", _fnc_onConfirm];