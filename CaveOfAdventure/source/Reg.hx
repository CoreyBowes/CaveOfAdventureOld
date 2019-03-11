/*
Global information class. Contains information like what sacrifices have been made, etc.
*/
package;

class Reg
{
    public static var LVL:LevelState;
    public static var _currentLevel = 1;
    public static var _maxLevel = 13;
    public static var _gravity = 600;
    public static var _goldNuggetsTotal = 3;
    public static var _goldNuggetsCollected = 0;
    public static var _abilities:Array<Bool> = [false, false, false, false, false, false];
    public static var _abilityNames:Array<Bool> = [false, false, false, false, false, false];

    public static var DOUBLE_JUMP(default, never):Int = 0;
    public static var DASH_BOOTS(default, never):Int = 1;
    public static var CLUB(default, never):Int = 2;
    public static var BOOMERANG(default, never):Int = 3;
    public static var FLY(default, never):Int = 4;
    public static var SPIKE_BOOTS(default, never):Int = 5;

    // Constants
    // public static var HEART(default, never):Int = 6;

    /*
    Initializes all the global variables the game needs that aren't initialized elsewhere.
    */
    public static function initializeGame()
    {
        Achievements.initializeAchievements();
    }
}
