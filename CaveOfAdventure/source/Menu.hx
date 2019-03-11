package;

import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;

enum ButtonType
{
    Wooden;
    Gray;
    Text;
    Gold;
}

enum Layout
{
    Horizontal;
    Vertical;
}

class Menu extends FlxSpriteGroup
{
    public var _isVertical:Bool = true;
    public var _buttonOffset:Float = 100;
    public var _verticalOffset = 30;
    public var _horizontalOffset = 100;
    public var _buttonType:ButtonType = Gray;

    override public function new(?X:Float=0, ?Y:Float=0, ?maxSize:Int=0, ?verticalMenu:Bool=true, ?menuButtonsOffset:Float=0,
    ?menuButtonsType:ButtonType)
    {
        super(X, Y, maxSize);
        _isVertical = verticalMenu;
        if(_isVertical)
        {
            _buttonOffset = _verticalOffset;
        }
        else
        {
            _buttonOffset = _horizontalOffset;
        }



        if(menuButtonsType!=null)
        {
            _buttonType=menuButtonsType;
        }
    }

    public function arrangeButtons()
    {
        for(i in 0...members.length)
        {
            if(_isVertical)
            {
                members[i].setPosition(0+x, _buttonOffset*i+y);
            }
            else
            {
                members[i].setPosition(_buttonOffset*i+x, 0+y);
            }
        }
    }

    public function addButton(?buttonText:String, ?OnDown:Void->Void)
    {
        var buttonToAdd:FancyButton = new FancyButton();
        switch(_buttonType)
        {
            case Gray:
                buttonToAdd = new FancyButton(0, 0, buttonText, OnDown);
            case Wooden:
                buttonToAdd = FancyButton.makeWoodenButton(0, 0, buttonText, OnDown);
            default:
                buttonToAdd = new FancyButton(0, 0, buttonText, OnDown);
        }
        add(buttonToAdd);
        arrangeButtons();
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}