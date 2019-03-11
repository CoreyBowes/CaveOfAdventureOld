package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;

class FancyDraw extends FlxSprite
{
    public static var _blackLine:LineStyle = {color: FlxColor.BLACK, thickness: 2};
    public static var _blueLine:LineStyle = {color: FlxColor.BLUE, thickness: 2};

    static public function getEyeIcon(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(iconWidth, iconHeight, FlxColor.WHITE, true);
        FlxSpriteUtil.drawCircle(returnIcon, returnIcon.width/2, returnIcon.height/2, returnIcon.width*2/5, FlxColor.TRANSPARENT,
        _blackLine);
        FlxSpriteUtil.drawCircle(returnIcon, returnIcon.width/2, returnIcon.height/2, returnIcon.width/10, FlxColor.BLACK,
        _blackLine);
        return returnIcon;
    }

    static public function getHandsIcon(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        /*
        Ellipse formula: x^2/a^2+y^2/b^2=1
        a=width/2, b=height/2
        x^2/a^2=1-y^2/b^2
        x^2=a^2*(1-y^2/b^2)
        x=sqrt(a^2*(1-y^2/b^2))
        */
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(iconWidth, iconHeight, FlxColor.WHITE, true);

        var bodyWidth = returnIcon.width*.4;
        var bodyHeight = returnIcon.height*.8;
        FlxSpriteUtil.drawEllipse(returnIcon, returnIcon.width/2-bodyWidth/2, 0,
        bodyWidth, bodyHeight, FlxColor.TRANSPARENT, _blackLine);

        var shoulderPt = new FlxPoint(returnIcon.width/2-bodyWidth/2, bodyHeight/2);
        var wristPt = new FlxPoint(returnIcon.width*.15, returnIcon.height*.2);
        var fingerPt = new FlxPoint(returnIcon.width*.07, wristPt.y);
        FlxSpriteUtil.drawLine(returnIcon, shoulderPt.x, shoulderPt.y, wristPt.x, wristPt.y, _blackLine);
        FlxSpriteUtil.drawLine(returnIcon, wristPt.x, wristPt.y, fingerPt.x, fingerPt.y, _blackLine);
        FlxSpriteUtil.drawLine(returnIcon, returnIcon.width-shoulderPt.x, shoulderPt.y, returnIcon.width-wristPt.x, wristPt.y, _blackLine);
        FlxSpriteUtil.drawLine(returnIcon, returnIcon.width-wristPt.x, wristPt.y, returnIcon.width-fingerPt.x, fingerPt.y, _blackLine);
        return returnIcon;
    }

    static public function getArmsIcon(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(iconWidth, iconHeight, FlxColor.WHITE, true);

        var bodyWidth = returnIcon.width*.4;
        var bodyHeight = returnIcon.height*.8;
        FlxSpriteUtil.drawEllipse(returnIcon, returnIcon.width/2-bodyWidth/2, 0,
        bodyWidth, bodyHeight, FlxColor.TRANSPARENT, _blackLine);

        var shoulderPt = new FlxPoint(returnIcon.width/2-bodyWidth/2, bodyHeight/2);
        var wristPt = new FlxPoint(returnIcon.width*.15, returnIcon.height*.2);
        var fingerPt = new FlxPoint(returnIcon.width*.07, wristPt.y);
        FlxSpriteUtil.drawLine(returnIcon, shoulderPt.x, shoulderPt.y, wristPt.x, wristPt.y, _blackLine);
        FlxSpriteUtil.drawLine(returnIcon, returnIcon.width-shoulderPt.x, shoulderPt.y, returnIcon.width-wristPt.x, wristPt.y, _blackLine);
        return returnIcon;
    }

    static public function getFeetIcon(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(iconWidth, iconHeight, FlxColor.WHITE, true);
        var btmPt = new FlxPoint(returnIcon.width*.4, returnIcon.height*.6);
        var ctrlPt = new FlxPoint(returnIcon.width*.17, returnIcon.height*.5);
        var toeXPos = returnIcon.width*.15;
        
        FlxSpriteUtil.drawLine(returnIcon, btmPt.x, 0, btmPt.x, btmPt.y, _blackLine);
        FlxSpriteUtil.drawLine(returnIcon, returnIcon.width-btmPt.x, 0, returnIcon.width-btmPt.x, btmPt.y, _blackLine);
        FlxSpriteUtil.drawCurve(returnIcon, btmPt.x, btmPt.y, ctrlPt.x, ctrlPt.y, toeXPos, btmPt.y, FlxColor.BLACK, _blackLine);
        FlxSpriteUtil.drawCurve(returnIcon, returnIcon.width-btmPt.x, btmPt.y, returnIcon.width-ctrlPt.x, ctrlPt.y, 
        returnIcon.width-toeXPos, btmPt.y, FlxColor.BLACK, _blackLine);
        return returnIcon;
    }

    static public function getLegsIcon(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(iconWidth, iconHeight, FlxColor.WHITE, true);
        return returnIcon;
    }

    static public function getHeartIcon(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        return getHeartIconCurves(iconWidth, iconHeight);
    }

    static public function getHeartIconCurves(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(iconWidth, iconHeight, FlxColor.WHITE, true);
        // var ctrlPt = new FlxPoint(returnIcon.width*1/10, returnIcon.height*1/5);
        var ctrlPt = new FlxPoint(0, returnIcon.height*1/5);
        var btmYPos = returnIcon.height*4/5;
        var topYPos = returnIcon.height*.35;

        FlxSpriteUtil.drawCurve(returnIcon, returnIcon.width/2, btmYPos, 
        ctrlPt.x, ctrlPt.y, returnIcon.width/2, topYPos, FlxColor.BLACK, _blackLine);
        FlxSpriteUtil.drawCurve(returnIcon, returnIcon.width/2, btmYPos, 
        returnIcon.width-ctrlPt.x, ctrlPt.y, returnIcon.width/2, topYPos, FlxColor.BLACK, _blackLine);
        return returnIcon;
    }

    static public function getHeartIconCircles(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(iconWidth, iconHeight, FlxColor.WHITE, true);
        // var ctrlPt = new FlxPoint(returnIcon.width*1/10, returnIcon.height*1/5);
        var ctrlPt = new FlxPoint(0, returnIcon.height*1/5);
        var circleCtrPt = new FlxPoint(0, returnIcon.height*1/5);
        var btmYPos = returnIcon.height*4/5;
        var circleYPos = returnIcon.height*.35;
        var topYPos = returnIcon.height*.35;

        FlxSpriteUtil.drawCurve(returnIcon, returnIcon.width/2, btmYPos, 
        ctrlPt.x, ctrlPt.y, returnIcon.width/2, topYPos, FlxColor.BLACK, _blackLine);
        FlxSpriteUtil.drawCurve(returnIcon, returnIcon.width/2, btmYPos, 
        returnIcon.width-ctrlPt.x, ctrlPt.y, returnIcon.width/2, topYPos, FlxColor.BLACK, _blackLine);
        return returnIcon;
    }

    /*
    Unlike other icon functions, scales width or height with the other parameter. If either 
    parameter is zero, calculates the other using the ratio. If both are zero, uses the default size. 
    width:height ratio is 2:1.
    */
    static public function getGoldBrick(?iconWidth=-1, ?iconHeight=-1):FlxSprite
    {
        var scaledWidth = iconWidth;
        var scaledHeight = iconHeight;
        if(iconWidth<0 && iconHeight<0)
        {
            scaledWidth = 10;
            scaledHeight = 5;
        }
        else if(iconWidth<0)
        {
            scaledWidth = iconHeight*2;
        }
        else if(iconHeight<0)
        {
            scaledHeight = Std.int(iconWidth/2);
        }
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(scaledWidth, scaledHeight, FlxColor.YELLOW, true);
        return returnIcon;
    }

    static public function getKey(?iconWidth=20, ?iconHeight=10):FlxSprite
    {
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(iconWidth, iconHeight, FlxColor.TRANSPARENT, true);
        FlxSpriteUtil.drawCircle(returnIcon, returnIcon.width/4, returnIcon.height/2, returnIcon.height*2/5, FlxColor.TRANSPARENT,
        _blueLine);
        FlxSpriteUtil.drawLine(returnIcon, returnIcon.width/4+returnIcon.height*2/5, returnIcon.height/2, 
        returnIcon.width, returnIcon.height/2, _blueLine);
        FlxSpriteUtil.drawLine(returnIcon, returnIcon.width*3/4, returnIcon.height/2, 
        returnIcon.width*3/4, 0, _blueLine);
        FlxSpriteUtil.drawLine(returnIcon, returnIcon.width-1, returnIcon.height/2, 
        returnIcon.width-1, 0, _blueLine);

        return returnIcon;
    }

    static public function getSpikesIcon(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(iconWidth, iconHeight, FlxColor.TRANSPARENT, true);

        var spikeVertices:Array<FlxPoint> = new Array();
        var numSpikes = Std.int(8*iconWidth/100);
        var spikeDepth = iconHeight/2;
        spikeVertices.push(new FlxPoint(0, spikeDepth));
        for(i in 0...numSpikes)
        {
            spikeVertices.push(new FlxPoint((i+0.5)*iconWidth/numSpikes, spikeDepth));
            spikeVertices.push(new FlxPoint((i+1)*iconWidth/numSpikes, iconHeight));
        }
        FlxSpriteUtil.drawPolygon(returnIcon, spikeVertices, FlxColor.WHITE);
        // FlxSpriteUtil.drawRect(this, 0, spikeDepth, width, (height-spikeDepth), FlxColor.WHITE);

        return returnIcon;
    }
}
