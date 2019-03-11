package;

import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class FancyButton extends FlxButton
{
    public var _isSelected = false;
    
    /*
    Calls the FlxButton constructor using the same default arguments.    
    */
	public function new(?X:Float = 0, ?Y:Float = 0, ?Label:String, ?OnDown:Void->Void, ?Width:Int = -1)
	{
		super(X, Y, Label, OnDown);
		
        /*
        // Only makes sense for pure text buttons. Will probably reuse this code.
		if (Width > 0)
        {
			width = Width;
        }
		else
        {
            if(Label!=null)
            {
			    width = Label.length * 7;
            }
            else
            {
                width = 30;
            }
        }
        */
		
		// label.color = FlxColor.BLACK;
	}
    public function updateWidth()
    {
        width = text.length * 7;
		makeGraphic(Std.int(width), Std.int(height), 0);
    }

    static public function makeWoodenButton(?x:Float=0, ?y:Float=0, ?text:String="", ?OnDown:Void->Void, ?Width:Int = -1):FancyButton
    {
        var returnButton:FancyButton = new FancyButton(x, y, text, OnDown, Width);
        // returnButton.makeGraphic(Std.int(returnButton.width), Std.int(returnButton.height), FlxColor.BROWN);
        returnButton.color = FlxColor.BROWN;
        returnButton.label.color = FlxColor.BLACK;
        return returnButton;
    }
	
	/**
	 * Override set_status to change how highlight / normal state looks.
	 */
     /*
	override function set_status(Value:Int):Int
	{
		if (label != null)
		{
			if (Value == FlxButton.HIGHLIGHT)
			{
                // Highlighted: White text, black border
				#if !mobile // "highlight" doesn't make sense on mobile
				label.color = FlxColor.WHITE;
				label.borderStyle = OUTLINE_FAST;
				label.borderColor = FlxColor.BLACK;
				#end
			}
			else 
			{
                // Not highlighted: Black text, white border
				label.color = FlxColor.BLACK;
				label.borderStyle = OUTLINE_FAST;
				label.borderColor = FlxColor.WHITE;
                if(_isSelected)
                {
                    setSelectionStatus(_isSelected);
                }
			}
		}
		return status = Value;
	}
    */

    public function setSelectionStatus(isSelected:Bool)
    {
        _isSelected = isSelected;
		if (_isSelected)
		{
            // If selected: White text, black border, same as if highlighted. Overrides normal highlight appearance.
			#if !mobile // "highlight" doesn't make sense on mobile
			label.color = FlxColor.WHITE;
			label.borderStyle = OUTLINE_FAST;
			label.borderColor = FlxColor.BLACK;
			#end
		}
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
