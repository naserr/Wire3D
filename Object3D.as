﻿/*
	Ali.MD.Object3D.v1beta (As Simple as posible 3D Rotate in Flash)
	by Ali Mihandoost - i@ali.md
	Special tanx to Ali Vojdany for mathematical logic
*/

function Point2D(x, y) {
	this.x = x;
	this.y = y;
}

function Point3D(x, y, z) {
	this.x = x;
	this.y = y;
	this.z = z;
}

function Object3D(screenX, screenY) {
	this.screenX = screenX;
	this.screenY = screenY;
	this.D = 500;
	this.PointList = new Array();
	this.FaceList = new Array();
	this.NumPoints = 0;
	this.NumFaces = 0;
}

Object3D.prototype.AddPoint = function(x, y, z) {
	this.PointList[this.NumPoints++] = new Point3D(x, y, z);
};

Object3D.prototype.AddFace = function(FaceName, Face, Colour, Outline) {
	this.FaceList[this.NumFaces] = Face;
	this.FaceList[this.NumFaces].FaceName = FaceName;
	this.FaceList[this.NumFaces].Colour = Colour;
	this.FaceList[this.NumFaces++].Outline = Outline;
};

Object3D.prototype.DrawFace = function(Face, depth) {
	var Pt2D = new Array();
	for (var i = 0; i<Face.length; i++) {
		Pt2D[i] = new Point2D((this.D*(this.PointList[Face[i]].x/(this.PointList[Face[i]].z+this.D)))+this.screenX, (this.D*(this.PointList[Face[i]].y/(this.PointList[Face[i]].z+this.D)))+this.screenY);
	}
	if (this.getVisible(Pt2D[0], Pt2D[1], Pt2D[2])) {
		_root.createEmptyMovieClip(Face.FaceName, depth);
		tellTarget (_root[Face.FaceName]) {
			beginFill(Face.Colour, 100);
			if (Face.Outline) {
				lineStyle(0, 0x000000, 100);
			}
			moveTo(Pt2D[0].x, Pt2D[0].y);
			for (var i = 1; i<Face.length; i++) {
				lineTo(Pt2D[i].x, Pt2D[i].y);
			}
			lineTo(Pt2D[0].x, Pt2D[0].y);
			endFill();
		}
	} else {
		_root[Face.FaceName].removeMovieClip();
	}
};

Object3D.prototype.getVisible = function(p1, p2, p3) {
	return ((p2.x-p1.x)*(p3.y-p1.y)<(p3.x-p1.x)*(p2.y-p1.y));
};

Object3D.prototype.DrawObject3D = function() {
	for (var i = 0; i<this.FaceList.length; i++) {
		this.DrawFace(this.FaceList[i], i);
	}
};

Object3D.prototype.RotateObject3D = function(x, y) {
	for (var i = 0; i<this.PointList.length; i++) {
		var px = this.PointList[i].x;
		var py = this.PointList[i].y;
		var pz = this.PointList[i].z;
		var temp_y = py*Math.cos(x)+pz*Math.sin(x);
		var temp_z1 = pz*Math.cos(x)-py*Math.sin(x);
		var temp_x = px*Math.cos(y)-temp_z1*Math.sin(y);
		var temp_z = px*Math.sin(y)+temp_z1*Math.cos(y);
		this.PointList[i] = new Point3D(temp_x, temp_y, temp_z);
	}
};

Object3D.prototype.Delete = function (){
    var i = 0;
    while (i < this.FaceList.length)
    {
        removeMovieClip(this.FaceList[i].FaceName);
        i++;
    }
};

function Stop3D(objName) {
    _root.onMouseDown = null;
    _root.onMouseMove = null;
    _root.onMouseUp = null;
    _root.onEnterFrame = null;
    this[objName].Delete();
    delete this[objName];
}

// main test

var fx:Number;
var fy:Number;
var gh:Number;
var obj:Number;
var den:Number;
var omx:Number;
var omy:Number;
var xa:Number;
var ya:Number;
var mb:Boolean;

omx = 0;
omy = 0;
xa = 0;
ya = 0;
fx = 800/2;
fy = 600/2;
gh = 100;
den = .98;
mb = false;

Robj = new Object3D(fx, fy);

// - Create the object -
var obj:Number;

// Number of created object <--- *** ---
obj = Math.floor(Math.random()*3+1);

// ----------------------
if (obj == 1) {
	Robj.AddPoint(gh, -gh, gh);
	Robj.AddPoint(gh, gh, gh);
	Robj.AddPoint(-gh, gh, gh);
	Robj.AddPoint(-gh, -gh, gh);
	Robj.AddPoint(-gh, -gh, -gh);
	Robj.AddPoint(-gh, gh, -gh);
	Robj.AddPoint(gh, gh, -gh);
	Robj.AddPoint(gh, -gh, -gh);
	Robj.AddFace("Face0", [0, 1, 2, 3], 0xff0000, true);
	Robj.AddFace("Face1", [4, 5, 6, 7], 0xffff00, true);
	Robj.AddFace("Face2", [7, 6, 1, 0], 0x0000ff, true);
	Robj.AddFace("Face3", [6, 5, 2, 1], 0xff00ff, true);
	Robj.AddFace("Face4", [5, 4, 3, 2], 0x00ffff, true);
	Robj.AddFace("Face5", [4, 7, 0, 3], 0x00ff00, true);
	Robj.RotateObject3D(0, .5);
} else if (obj == 2) {
	Robj.AddPoint(gh, -gh, gh);
	Robj.AddPoint(gh, -gh, -gh);
	Robj.AddPoint(-gh, -gh, -gh);
	Robj.AddPoint(-gh, -gh, gh);
	Robj.AddPoint(0, 2*gh, 0);
	Robj.AddFace("Face0", [4, 0, 1], 0x00ff00, true);
	Robj.AddFace("Face1", [4, 1, 2], 0x0000ff, true);
	Robj.AddFace("Face2", [4, 2, 3], 0xffff00, true);
	Robj.AddFace("Face3", [4, 3, 0], 0xff0000, true);
	Robj.AddFace("Face4", [3, 2, 1, 0], 0x00ffff, true);
	Robj.RotateObject3D(0, .5);
} else if (obj=3) {
	Robj.AddPoint(-gh/2, 0, gh+gh/2);
	Robj.AddPoint(-gh/2, -gh, gh);
	Robj.AddPoint(-gh/2, -gh-gh/2, 0);
	Robj.AddPoint(-gh/2, -gh, -gh);
	Robj.AddPoint(-gh/2, 0, -gh-gh/2);
	Robj.AddPoint(-gh/2, gh, -gh);
	Robj.AddPoint(-gh/2, gh+gh/2, 0);
	Robj.AddPoint(-gh/2, gh, gh);
	Robj.AddPoint(gh/2, 0, gh+gh/2);
	Robj.AddPoint(gh/2, -gh, gh);
	Robj.AddPoint(gh/2, -gh-gh/2, 0);
	Robj.AddPoint(gh/2, -gh, -gh);
	Robj.AddPoint(gh/2, 0, -gh-gh/2);
	Robj.AddPoint(gh/2, gh, -gh);
	Robj.AddPoint(gh/2, gh+gh/2, 0);
	Robj.AddPoint(gh/2, gh, gh);
	Robj.AddFace("Face0", [0, 1, 9, 8], 0xff9900, true);
	Robj.AddFace("Face1", [1, 2, 10, 9], 0xffcc00, true);
	Robj.AddFace("Face2", [2, 3, 11, 10], 0xff9900, true);
	Robj.AddFace("Face3", [3, 4, 12, 11], 0xffcc00, true);
	Robj.AddFace("Face4", [4, 5, 13, 12], 0xff9900, true);
	Robj.AddFace("Face5", [5, 6, 14, 13], 0xffcc00, true);
	Robj.AddFace("Face6", [6, 7, 15, 14], 0xff9900, true);
	Robj.AddFace("Face7", [7, 0, 8, 15], 0xffcc00, true);
	Robj.AddFace("Face8", [8, 9, 10, 11, 12, 13, 14, 15], 0xcc0000, true);
	Robj.AddFace("Face9", [7, 6, 5, 4, 3, 2, 1, 0], 0xcc3300, true);
	Robj.RotateObject3D(0, .5);
}

// -- All Events Fuction --

// -- Mosuse effect --
this.onMouseDown = function() {
	mb = true;
	ya = 0;
	xa = 0;
	omx = _root._xmouse;
	omy = _root._ymouse;
	onEnterFrame = null;
};
this.onMouseMove = function() {
	if (mb) {
		xa = (_root._xmouse-omx)/150;
		ya = (omy-_root._ymouse)/150;
		Robj.RotateObject3D(ya, xa);
		Robj.DrawObject3D();
		omx = _xmouse;
		omy = _ymouse;
	}
};
_root.onMouseUp = function() {
	mb = false;
	_root.onEnterFrame = function() {
		if (Math.abs(xa)<.0001 and Math.abs(ya)<.0001) {
			_root.onEnterFrame = null;
		}
		xa *= den;
		ya *= den;
		Robj.RotateObject3D(ya, xa);
		Robj.DrawObject3D();
	};
};

// -- Action of Frame 1 --
stop();
Robj.DrawObject3D();

