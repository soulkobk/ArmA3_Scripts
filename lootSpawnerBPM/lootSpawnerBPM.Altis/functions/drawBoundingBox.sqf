// bounding box draw 3d code by killzonekid -> http://killzonekid.com/arma-3-bounding-box-utility/

params ["_buildingClass"];

if (isNil "_buildingClass") exitWith {};

_buildingClass call {
    private ["_obj","_bb","_bbx","_bby","_bbz","_arr","_y","_z"];
    _obj = _this;
    _bb = {
        _bbx = [_this select 0 select 0, _this select 1 select 0];
        _bby = [_this select 0 select 1, _this select 1 select 1];
        _bbz = [_this select 0 select 2, _this select 1 select 2];
        _arr = [];
        0 = {
            _y = _x;
            0 = {
                _z = _x;
                0 = {
                    0 = _arr pushBack (_obj modelToWorld [_x,_y,_z]);
                } count _bbx;
            } count _bbz;
            reverse _bbz;
        } count _bby;
        _arr pushBack (_arr select 0);
        _arr pushBack (_arr select 1);
        _arr
    };
    bboxr = boundingBoxReal _obj call _bb;
    addMissionEventHandler ["Draw3D", {
        for "_i" from 0 to 7 step 2 do {
            drawLine3D [
                bboxr select _i,
                bboxr select (_i + 2),
                [0,1,0,1]
            ];
            drawLine3D [
                bboxr select (_i + 2),
                bboxr select (_i + 3),
                [0,1,0,1]
            ];
            drawLine3D [
                bboxr select (_i + 3),
                bboxr select (_i + 1),
                [0,1,0,1]
            ];
        };
    }];
};
